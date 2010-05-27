/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.desuade.partigen.renderers {
	
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import com.desuade.partigen.interfaces.*;
	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.partigen.events.RenderEvent;
	import com.desuade.debugging.*;
	import com.desuade.motion.bases.*;
	import com.desuade.motion.events.*;
	
	/**
	 *  This uses BitmapData to display particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  04.08.2009
	 */
	public class BitmapRenderer extends StandardRenderer {
		
		/**
		 *	The BitmapData to render to.
		 */
		public var bitmapdata:BitmapData;
		
		/**
		 *	What function to run on the bitmap on each render.
		 *	
		 *	@param	bitmap	 The BitmapData that is passed to the function
		 */
		public var renderfunc:Function = nullfunc;
		
		/**
		 *	If true, this draws the particles first, then applies the fade/fadeblur, then the renderfunc. If false, it draws the particles after (default).
		 */
		public var predraw:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _offbitmap:BitmapData;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _automagic:Boolean = false;
		
		/**
		 *	This is a Point for the offset of the bitmapdata.
		 */
		public var offset:Point = new Point(0, 0);
		
		/**
		 *	@private
		 */
		protected var _fadeCT:ColorTransform = new ColorTransform (1, 1, 1, 0, 0, 0, 0, 0);
		
		/**
		 *	@private
		 */
		public var _blur:BlurFilter = new BlurFilter(0,0,1);
		
		/**
		 *	@private
		 */
		protected const ZP:Point = new Point(0,0);
		
		/**
		 *	Creates a new BitmapRenderer. Use a BitmapCanvas object to display the particle bitmap.
		 *	
		 *	@param	width	The width of the Bitmap.
		 *	@param	height	The height of the Bitmap.
		 *	@param	order	The visual stacking order for new particles to be created – 'top', 'bottom', or 'random'.
		 *	@param	automagic	If the renderer should start in automagic mode (starts/stops renderer based on need).
		 */
		public function BitmapRenderer($width:int, $height:int, $order:String = 'top', $automagic:Boolean = true) {
			super(new Sprite(), $order);
			bitmapdata = new BitmapData($width, $height, true, 0);
			_offbitmap = new BitmapData(bitmapdata.width, bitmapdata.height, true, 0);
			if($automagic) automagicModeStart();
		}
		
		/**
		 *	If the renderer is running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	If the renderer is currently running in automagic mode.
		 */
		public function get automagic():Boolean { 
			return _automagic; 
		}
		
		/**
		 *	Starts the renderer writing to the BitmapData.
		 */
		public function start():void {
			if(!active){
				_active = true;
				_offbitmap = new BitmapData(bitmapdata.width, bitmapdata.height, true, 0);
				_offbitmap.copyPixels(bitmapdata, bitmapdata.rect, offset);
				BaseTicker.addEventListener(MotionEvent.UPDATED, render);
				dispatchEvent(new RenderEvent(RenderEvent.STARTED, {renderer:this}));
			}
		}
		
		/**
		 *	Stops the renderer from writing to the BitmapData.
		 */
		public function stop():void {
			if(active){
				_active = false;
				BaseTicker.removeEventListener(MotionEvent.UPDATED, render);
				dispatchEvent(new RenderEvent(RenderEvent.STOPPED, {renderer:this}));
			}
		}
		
		/**
		 *	This "resizes" the BitmapData for the renderer. Dispatches resize event to listening BitmapCanvases.
		 *	
		 *	@param	width	 The new width
		 *	@param	height	 The new height
		 */
		public function resize($width:int, $height:int):void {
			bitmapdata.dispose();
			_offbitmap.dispose();
			bitmapdata = new BitmapData($width, $height, true, 0);
			_offbitmap = new BitmapData(bitmapdata.width, bitmapdata.height, true, 0);
			dispatchEvent(new RenderEvent(RenderEvent.RESIZED, {renderer:this}));
		}
		
		/**
		 *	@private
		 */
		protected function nullfunc($bitmap:BitmapData):void {
			//
		}
		
		/**
		 *	<p>The amount of fade to perform on the BitmapData.</p>
		 *	<p>A value of 0 will instantly fade the BitmapData, leaving no trail.</p>
		 *	<p>A value of 1 will not fade the BitmapData, "painting" the screen.</p>
		 *	<p>Any value in between will fade the BitmapData, like a motion trail.</p>
		 */
		public function set fade($value:Number):void {
			_fadeCT.alphaMultiplier = $value;
		}
		
		/**
		 *	@private
		 */
		public function get fade():Number{
			return _fadeCT.alphaMultiplier;
		}
		
		/**
		 *	The amount of blur to perform on the fade.
		 */
		public function get fadeBlur():int{
			return _blur.blurX;
		}
		
		/**
		 *	@private
		 */
		public function set fadeBlur($value:int):void {
			_blur.blurX = _blur.blurY = $value;
		}
		
		/**
		 *	This clears the BitmapData on the renderer.
		 */
		public function clear():void {
			_offbitmap.fillRect(bitmapdata.rect, 0x00000000);
			bitmapdata.fillRect(bitmapdata.rect, 0x00000000);
		}
		
		/**
		 *	@private
		 */
		protected function render($e:Object):void {
			_offbitmap.lock();
			if(_fadeCT.alphaMultiplier != 0) _offbitmap.colorTransform(_offbitmap.rect, _fadeCT);
			else _offbitmap.fillRect(bitmapdata.rect, 0x00000000);
			if(predraw) drawMethod();
			if(fadeBlur != 0 && fade != 0) _offbitmap.applyFilter(_offbitmap, _offbitmap.rect, ZP, _blur);
			renderfunc(_offbitmap);
			if(!predraw) drawMethod();
			_offbitmap.unlock();
			bitmapdata.copyPixels(_offbitmap, _offbitmap.rect, offset);
		}
		
		/**
		 *	@private
		 */
		protected function drawMethod():void {
			_offbitmap.draw(target);
		}
		
		/**
		 *	This starts the automagic mode that will automagically start/stop the renderer based on need. This starts automatically by default when the renderer is created.
		 */
		public function automagicModeStart():void {
			if(!automagic){
				_automagic = true;
				BaseTicker.addEventListener(MotionEvent.UPDATED, level1Check);
			}
		}
		
		/**
		 *	This stops the automagic mode that automagically starts/stops the renderer based on need.
		 */
		public function automagicModeStop():void {
			if(automagic){
				_automagic = false;
				BaseTicker.removeEventListener(MotionEvent.UPDATED, level1Check);
			}
		}
		
		/**
		 *	@private
		 */
		protected function level1Check($e:MotionEvent = null):void {
			if(target.numChildren > 0){
				if(!active) start(); //if there's any particles in it, start it
			} else {
				//no particles alive, so let's check the bitmap
				if(active) {
					//let's check to see if there's any drawing things on the stage
					if(!compareBitmaps()) stop();
				}
			}
		}
		
		/**
		 *	@private
		 */
		protected function compareBitmaps():Boolean {
			var ncr:Rectangle = _offbitmap.getColorBoundsRect(0xff000000, 0x00000000, false);
			return (ncr.width == 0 || ncr.height == 0) ? false : true;
		}

	}

}
