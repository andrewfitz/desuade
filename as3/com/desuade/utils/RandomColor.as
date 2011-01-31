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

	/**
	 *  The RandomColor class offers an object or a static method to return a random color between 2 specified colors.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 *	
	 *	@see	Random
	 *	@see	ColorHelper
	 */
	public class RandomColor extends Random {
	
		/**
		 *	This creates a RandomColor object than can be used over again for creating new random colors from the same range. Can be used with the ColorTween classes, as well as any other properties requiring a Color.
		 *	
		 *	@param	min	 The first color in the range
		 *	@param	max	 The second color in the range
		 *	@see	#min
		 *	@see	#max
		 */	
		public function RandomColor($min:*, $max:*) {
			super($min, $max, 0);
		}
		
		/**
		 *	This static function is used to return a random color from a given range.
		 *	
		 *	@param	min	 The first color in the range
		 *	@param	max	 The second color in the range
		 *	@see	#min
		 *	@see	#max
		 */
		public static function fromRange($min:*, $max:*):uint {
			if($min == $max) return $min;
			else {
				var rgbmin:Object = ColorHelper.hexToRGB($min);
				var rgbmax:Object = ColorHelper.hexToRGB($max);
				var rgbrandom:Object = {r:Random.fromRange(rgbmin.r, rgbmax.r), g:Random.fromRange(rgbmin.g, rgbmax.g), b:Random.fromRange(rgbmin.b, rgbmax.b)};
				return ColorHelper.RGBToHex(rgbrandom.r, rgbrandom.g, rgbrandom.b);
			}
		}
	
	}

}
