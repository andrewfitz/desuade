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

package com.desuade.utils {

	import flash.geom.Point;
	import flash.display.*;
	import com.desuade.motion.eases.*;

	/**
	 *  Provides basic static methods for drawing.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  12.11.2009
	 */
	public class Drawing {
		
		/**
		 *	@private
		 */
		private static var degToRad:Number = Math.PI/180;
		
		/**
		 *	This method draws a slice graphic to the target sprite
		 *	
		 *	@param	target	 The target sprite to write to
		 *	@param	beginAngle	 The beginning angle to use to create the slice
		 *	@param	endAngle	 The end angle to use
		 *	@param	radius	 How big to make the slice
		 *	@param	color	 The color of the slice to draw - "#00ff00", 0x909090, etc.
		 *	@param	x	 The x offset to draw to - defaults 0
		 *	@param	y	 The y offset to draw to - defaults 0
		 *	@param	precision	 How many segments to make
		 *	
		 */
		public static function drawSlice($target:Object, $beginAngle:Number, $endAngle:Number, $radius:Number, $color:*, $x:Number = 0, $y:Number = 0, $precision:int = 20):void {
			var ba:Number = $beginAngle;
			var ea:Number = $endAngle;
			if ($endAngle < $beginAngle) {
				ba = $endAngle;
				ea = $beginAngle;
			}
			var n:Number = ((ea-ba)/$precision);
			var theta:Number = -1*((ea-ba)/n)*degToRad;
			var cr:Number = $radius/Math.cos(theta/2);
			var angle:Number = -1*ba*degToRad;
			var cangle:Number = angle-theta/2;
			$target.graphics.moveTo($x, $y);
			$target.graphics.beginFill(ColorHelper.cleanColorValue($color));
			$target.graphics.lineTo($x+$radius*Math.cos(angle), $y+$radius*Math.sin(angle));
			for (var i:int = 0; i < n; i++)	{
				angle += theta;
				cangle += theta;
				var endX:Number = $radius*Math.cos (angle);
				var endY:Number = $radius*Math.sin (angle);
				var cX:Number = cr*Math.cos (cangle);
				var cY:Number = cr*Math.sin (cangle);
				$target.graphics.curveTo($x+cX,$y+cY, $x+endX,$y+endY);
			}
			$target.graphics.lineTo($x, $y);
		}
		
		/**
		 *	This draws a line showing a visual representation of an easing equation, often used with Tweens.
		 *	
		 *	@param	target	 The target DisplayObject to draw to
		 *	@param	start	 A Point to start at (the beginning value of a tween)
		 *	@param	end	 A Point to end at (the final value of a tween)
		 *	@param	easeX	 The easing equation for the x value ('linear' if drawing horizontal)
		 *	@param	easeX	 The easing equation for the y value ('linear' if drawing vertical)
		 *	@param	segments	 How many segments to divide the line in (higher is more detailed)
		 */
		public static function drawEase($target:Sprite, $start:Point, $end:Point, $easeX:String, $easeY:String, $segments:int = 100):void {
			$target.graphics.moveTo($start.x, $start.y);
			$target.graphics.lineStyle(1, 0xeeeeee);
			var curX:Number = $start.x;
			var curY:Number = $start.y;
			var difX:Number = ($start.x > $end.x) ? ($end.x-$start.x) : -($start.x-$end.x);
			var difY:Number = ($start.y > $end.y) ? ($end.y-$start.y) : -($start.y-$end.y);
			if($easeX == 'linear' && $easeY == 'linear'){
				//nothing
			}
			else {
				for (var i:int = 0; i < $segments; i++) {
					curX = Easing[$easeX](i, $start.x, difX, $segments);
					curY = Easing[$easeY](i, $start.y, difY, $segments);
					$target.graphics.lineTo(curX, curY);
				}
			}
			$target.graphics.lineTo($end.x, $end.y);
		}

	}

}
