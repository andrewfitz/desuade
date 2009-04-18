package com.desuade.utils {

	public class RandomColor extends Random {
	
		public function RandomColor($min:*, $max:*) {
			super($min, $max, 0);
		}
		
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
