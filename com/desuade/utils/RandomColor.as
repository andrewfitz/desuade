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
		 *	This creates a RandomColor object than can be used over again for creating new random colors from the same range. Can be used with the ColorTween classes.
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
