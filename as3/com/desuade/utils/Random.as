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
	 *  The Random class offers an object or a static method to return a random Number between 2 specified values, also allowing for decimal place precision.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class Random {
		
		/**
		 *	@private
		 */
		protected static const RATIO:Number = 1 / uint.MAX_VALUE;
		
		/**
		 *	@private
		 */
		protected static var r:uint = Math.random() * uint.MAX_VALUE;
		
		/**
		 *	The Random object's minimum value for the random range.
		 */
		public var min:Number;
		
		/**
		 *	The Random object's maximum value for the random range.
		 */
		public var max:Number;
		
		/**
		 *	This is the amount of decimal places to keep when returning the value.
		 *	
		 *	For example, values such as alpha use a 0-1 scale, so a precision of 2 would be used 0.00
		 */
		public var precision:int;
		
		/**
		 *	This creates a Random object than can be used over again for creating new random values from the same range. Can be used with the Tween classes, as well as any other properties requiring a Number.
		 *	
		 *	@param	min	 The first value in the range
		 *	@param	max	 The second value in the range, up to but not including
		 *	@param	precision	 This determines how many decimal places the random value should be in
		 *	@see	#min
		 *	@see	#max
		 *	@see	#precision
		 */
		public function Random($min:Number, $max:Number, $precision:int = 0):void {
			min = $min;
			max = $max;
			precision = $precision;
		}
		
		/**
		 *	This returns a new random value within the range each time the Random object is read. Use var rn:Number = Number(my_random_object) to assign a constant number.
		 */
		public function valueOf():Number {
			return fromRange(min, max, precision);
		}
		
		/**
		 *	This returns a new random value within the range each time the Random object is read. Use var rns:String = String(my_random_object) to assign a constant string.
		 */
		public function toString():String{
			return String(valueOf());
		}
		
		/**
		 *	This static function is used to return a random value from a given range.
		 *	
		 *	@param	min	 The first value in the range
		 *	@param	max	 The second value in the range, up to but not including
		 *	@param	precision	 This determines how many decimal places the random value should be in
		 *	@see	#min
		 *	@see	#max
		 *	@see	#precision
		 */
		public static function fromRange($min:Number, $max:Number, $precision:int = 0):* {
			if($min == $max) return $min;
			else {
				if($precision == 0) return int($min + (XORandom() * ($max - $min)));
				else {
					var dp:int = 10;
					for (var i:int = 1; i < $precision; i++) dp*=10;
					return ((int((($min + (XORandom() * ($max - $min))) * dp))) / dp);
				}
			}
		}
		
		/**
		 *	@private
		 */
		public static function XORandom():Number{
			r ^= (r << 21);
			r ^= (r >>> 35);
			r ^= (r << 4);
			return (r * RATIO);
		}
	}
}
