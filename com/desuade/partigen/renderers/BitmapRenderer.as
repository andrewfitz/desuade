/*
This software is distributed under the MIT License.

Copyright (c) 2009 Desuade (http://desuade.com/)

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
	import flash.geom.Point;
	
	import com.desuade.partigen.particles.BasicParticle;
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
		 *	@private
		 */
		protected var _offbitmap:BitmapData;
		
		/**
		 *	@private
		 */
		protected var _zeroPoint:Point;
		
		/**
		 *	Creates a new BitmapRenderer. This will use BitmapData to render particles.
		 *	
		 *	@param	bitmapdata	 The BitmapData object to render to.
		 *	@param	order	 The visual order of a new particle to be created - either 'top' or 'bottom'.
		 */
		public function BitmapRenderer($bitmapdata:BitmapData, $order:String = 'top') {
			super(new Sprite(), $order);
			bitmapdata = $bitmapdata;
			_zeroPoint = new Point(0, 0);
			_offbitmap = new BitmapData(bitmapdata.width, bitmapdata.height, true, 0);
			_offbitmap.copyPixels(bitmapdata, bitmapdata.rect, _zeroPoint);
		}
		
		/**
		 *	Starts the renderer writing to the BitmapData.
		 */
		public override function start():void {
			BaseTicker.addEventListener(MotionEvent.UPDATED, render);
		}
		
		/**
		 *	Stops the renderer from writing to the BitmapData.
		 */
		public override function stop():void {
			BaseTicker.removeEventListener(MotionEvent.UPDATED, render);
		}
		
		/**
		 *	@private
		 */
		protected function render($e:Object):void {
			_offbitmap.fillRect(bitmapdata.rect, 0);
			_offbitmap.draw(target);
			bitmapdata.copyPixels(_offbitmap, _offbitmap.rect, _zeroPoint);
		}
	
	}

}
