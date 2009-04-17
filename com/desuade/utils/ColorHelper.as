package com.desuade.utils {

	public class ColorHelper extends Object {
	
		public function ColorHelper() {
			super();
		}
		
		public static function hexToDec($hex:String):int {
			return parseInt($hex, 16);
		}
		
		public static function decToHex($dec:int):String {
			return Number($dec).toString(16);
		}
		
		public static function cleanColorValue($rgb:*):int {
			if (typeof $rgb == 'string') {
				if ($rgb.charAt(0) == '#') $rgb = $rgb.slice(1);
				$rgb = (($rgb.charAt(1)).toLowerCase()!='x') ? ('0x'+$rgb) : ($rgb);
			}
			return int($rgb);
		}
		
		public static function getColorObject(type:String, amt:Number, rgb:*, cco:Object = null):Object {
			var cr:Number; var cg:Number; var cb:Number; var cr2:Number; var cg2:Number; var cb2:Number;
			if(cco != null){
				cr = cco.redOffset;
				cb = cco.blueOffset;
				cg = cco.greenOffset;
				cr2 = int(cr/2);
				cb2 = int(cb/2);
				cg2 = int(cg/2);
			} else {
				cr = cb = cg = 255;
				cr2 = cb2 = cg2 = 128;
			}
			switch (type) {
				case 'brightness':
					var percent:Number = (1-Math.abs(amt));
					var offset:Number = ((amt > 0) ? (255*(amt/1)) : 0);
					return {redMultiplier:percent, redOffset:offset, greenMultiplier:percent, greenOffset:offset, blueMultiplier:percent, blueOffset:offset};
				break;
				case 'brightOffset':
					return {redMultiplier:1, redOffset:(cr*(amt/1)), greenMultiplier:1, greenOffset:(cg*(amt/1)), blueMultiplier:1, blueOffset:(cb*(amt/1))};
				break;
				case 'contrast':
					return {redMultiplier:amt, redOffset:(cr2-(cr2/1*amt)), greenMultiplier:amt, greenOffset:(cg2-(cg2/1*amt)), blueMultiplier:amt, blueOffset:(cb2-(cb2/1*amt))};
				break;
				case 'invertColor':
					return {redMultiplier:(1-2*amt), redOffset:(amt*(cr/1)), greenMultiplier:(1-2*amt), greenOffset:(amt*(cg/1)), blueMultiplier:(1-2*amt), blueOffset:(amt*(cb/1))};
				break;
				case 'tint':
				 	if (rgb != null) {
						var rgbnum:int = cleanColorValue(rgb);
						return {redMultiplier:(1-amt), redOffset:(rgbnum >> 16)*(amt/1), greenMultiplier:(1-amt), greenOffset:((rgbnum >> 8) & 0xFF)*(amt/1), blueMultiplier:(1-amt), blueOffset:(rgbnum & 0xFF)*(amt/1)};
					}
				break;
			}
			return {redOffset:0, redMultiplier:1, greenOffset:0, greenMultiplier:1, blueOffset:0, blueMultiplier:1}; //full reset
		};
	
	}

}
