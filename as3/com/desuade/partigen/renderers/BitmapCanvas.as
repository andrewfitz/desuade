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
	import flash.utils.*;
	
	import com.desuade.partigen.events.RenderEvent;
	
	/**
	 *  Displays particles on the screen from a BitmapRenderer
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  03.03.2010
	 */
	public class BitmapCanvas extends Sprite {
		
		/**
		 *	The renderer used to get the bitmapdata from.
		 */
		public var renderer:Renderer;
		
		/**
		 *	The internal bitmap.
		 */
		public var bitmap:Bitmap;
		
		/**
		 *	@private
		 */
		public var indicator:Sprite;
		
		/**
		 *	@private
		 */
		protected var _isLivePreview:Boolean;
		
		/**
		 *	This creates a BitmapCanvas that actually displays the particles from the BitmapRenderer.
		 *	
		 *	@param	renderer The BitmapRenderer to use.
		 *	@param	x	 The x coord for the canvas
		 *	@param	y	 The y coord for the canvas
		 *	
		 */
		public function BitmapCanvas($renderer:Renderer = null, $x:Number = 0, $y:Number = 0) {
			if($renderer != null) setRenderer($renderer);
			x = $x, y = $y;
			_isLivePreview = (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
		}
		
		/**
		 *	This sets the renderer to be used.
		 *	
		 *	@param	renderer The BitmapRenderer to use.
		 */
		public function setRenderer($renderer:Renderer):void {
			renderer = $renderer;
			setBitmap();
			renderer.addEventListener(RenderEvent.RESIZED, setBitmap, false, 0, false);
		}
		
		protected function setBitmap(o:Object = null):void {
			if(bitmap != null) this.removeChild(bitmap);
			bitmap = new Bitmap(renderer.bitmapdata);
			this.addChild(bitmap);
		}
		
		/**
		 *	If the BitmapCanvas indicator should be shown, marking it's position on the stage.
		 */
		[Inspectable(name = "Show Indicator", defaultValue = true, variable = "showIndicator", type = "Boolean")]
		public function set showIndicator($value:Boolean):void {
			indicator.visible = $value;
		}
		
		/**
		 *	@private
		 */
		public function get showIndicator():Boolean{
			return indicator.visible;
		}
			
	}
	
}