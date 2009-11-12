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

package com.desuade.utils {

	/**
	 *  Class with static methods for drawing
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
			if ($endAngle < $beginAngle) $endAngle += 360;
			var n:Number = (($endAngle-$beginAngle)/$precision);
			var theta:Number = -1*(($endAngle-$beginAngle)/n)*degToRad;
			var cr:Number = $radius/Math.cos(theta/2);
			var angle:Number = -1*$beginAngle*degToRad;
			var cangle:Number = angle-theta/2;
			$target.graphics.moveTo($x, $y);
			$target.graphics.beginFill(ColorHelper.cleanColorValue($color));
			$target.graphics.lineTo($x+$radius*Math.cos(angle), $y+$radius*Math.sin(angle));
			for (var i:int = 0; i < n; i++)	{
				angle += theta;
				cangle += theta;
				var endX = $radius*Math.cos (angle);
				var endY = $radius*Math.sin (angle);
				var cX = cr*Math.cos (cangle);
				var cY = cr*Math.sin (cangle);
				$target.graphics.curveTo($x+cX,$y+cY, $x+endX,$y+endY);
			}
			$target.graphics.lineTo($x, $y);
		}

	}

}
