package com.desuade.utils {

	/**
	 *  The Random class offers an object or a static method to return a random value between 2 specified values, also allowing for decimal place precision.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class Random extends Object {
		
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
		 *	This creates a Random object than can be used over again for creating new random values from the same range. Can be used with the Tween classes.
		 *	
		 *	@param	min	 The first value in the range
		 *	@param	max	 The second value in the range
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
		 *	This property of a Random object returns a new random value within the range each time it's read.
		 */
		public function get randomValue():Number{
			return fromRange(min, max, precision);
		}
		
		/**
		 *	This static function is used to return a random value from a given range.
		 *	
		 *	@param	min	 The first value in the range
		 *	@param	max	 The second value in the range
		 *	@param	precision	 This determines how many decimal places the random value should be in
		 *	@see	#min
		 *	@see	#max
		 *	@see	#precision
		 */
		public static function fromRange($min:Number, $max:Number, $precision:int = 0):Number {
			if($min == $max) return $min;
			else {
				var dp:int = Math.pow(10, $precision);
				var rn:Number = ((int((($min + (Math.random() * ($max - $min))) * dp))) / dp);
				return rn;
			}
		}
	}
}
