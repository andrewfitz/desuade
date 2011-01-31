/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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
	 *  This uses BitmapData to display particles as pixels.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.04.2010
	 */
	public class PixelRenderer extends BitmapRenderer {
		
		/**
		 *	@private
		 */
		protected var _particles:Object = {};
		
		/**
		 *	@private
		 */
		protected var _pixelBuffer:BitmapData;
		
		/**
		 *	<p>This creates a new PixelRenderer to render PixelParticles.</p>
		 *	<p>Note: If regular Particles are used, it will convert them into a single pixel. For best performance, set your emitter.particleBaseClass to PixelParticle or BasicPixelParticle.</p>
		 *	
	 	 *	@param	width	The width of the Bitmap.
		 *	@param	height	The height of the Bitmap.
		 *	@param	automagic	If the renderer should start in automagic mode (starts/stops renderer based on need).
		 */
		public function PixelRenderer($width:int, $height:int, $automagic:Boolean = true) {
			super($width, $height, 'top', $automagic);
			_pixelBuffer = new BitmapData($width, $height, true, 0);
		}
		
		/**
		 *	An object of all the current particles in the renderer.
		 */
		public function get particles():Object{
			return _particles;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function resize($width:int, $height:int):void {
			_pixelBuffer.dispose();
			_pixelBuffer = new BitmapData($width, $height, true, 0);
			super.resize($width, $height);
		}
		
		/**
		 *	@inheritDoc
		 */
		protected override function drawMethod():void {
			_pixelBuffer.fillRect(bitmapdata.rect, 0x00000000);
			var bm:String = null;
			for each (var tp:* in _particles) {
				var argb:uint = (255 * tp.alpha)<<24;
				argb += tp.color;
				if(tp.alpha <= 0.01) argb = 0;
				for (var i:int = 0; i < tp.group.length; i++) {
					_pixelBuffer.setPixel32((tp.x + tp.group[i][0]), (tp.y + tp.group[i][1]), argb);
				}
				if(bm == null) bm = tp.blendMode;
			}
			_offbitmap.draw(_pixelBuffer, null, null, bm);
		}
		
		/**
		 *	@private
		 */
		protected override function level1Check($e:MotionEvent = null):void {
			var pc:Boolean = false;
			for (var f:String in _particles) {
				pc = true;
				break;
			}
			if(pc){
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
		 *	@inheritDoc
		 */
		public override function addParticle($p:IBasicParticle):void {
			_particles[$p.id] = $p;
			Debug.output('partigen', 40002, [$p.id]);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeAllParticles():void {
			_particles = {};
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($p:IBasicParticle):void {
			delete _particles[$p.id];
			Debug.output('partigen', 40004, [$p.id]);
		}
		
	}
}