package com.desuade.utils {

	public class ColorHelper extends Object {
	
		public function ColorHelper() {
			super();
		}
		
		public static function hexStringToDec($hex:String):int {
			return parseInt($hex, 16);
		}
		
		public static function decToHexString($dec:int):String {
			return Number($dec).toString(16);
		}
		
		public static function hexToRGB($color:*):Object {
			var cc:uint = cleanColorValue($color);
			var ob:Object = {r:0, g:0, b:0};
			ob.r = (cc >> 16);;
			ob.g = ((cc >> 8) & 0xFF);
			ob.b = (cc & 0xFF);
			return ob;
		}
		
		public static function RGBToHex(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}
		
		public static function cleanColorValue($rgb:*):uint {
			if (typeof $rgb == 'string') {
				if ($rgb.charAt(0) == '#') $rgb = $rgb.slice(1);
				$rgb = (($rgb.charAt(1)).toLowerCase()!='x') ? ('0x'+$rgb) : ($rgb);
			}
			return uint($rgb);
		}
		
		public static function getColorObject(type:String, amt:Number = 1, rgb:* = null, cco:Object = null):Object {
			var cr:Number; var cg:Number; var cb:Number; var cr2:Number; var cg2:Number; var cb2:Number;
			if(cco != null){
				cr = cco.redOffset;
				cb = cco.blueOffset;
				cg = cco.greenOffset;
				cr2 = int(cr*.5);
				cb2 = int(cb*.5);
				cg2 = int(cg*.5);
			} else {
				cr = cb = cg = 255;
				cr2 = cb2 = cg2 = 128;
			}
			switch (type) {
				case 'brightness':
					var percent:Number = (1-Math.abs(amt));
					var offset:Number = ((amt > 0) ? (255*amt) : 0);
					return {redMultiplier:percent, redOffset:offset, greenMultiplier:percent, greenOffset:offset, blueMultiplier:percent, blueOffset:offset};
				break;
				case 'brightOffset':
					return {redMultiplier:1, redOffset:(cr*amt), greenMultiplier:1, greenOffset:(cg*amt), blueMultiplier:1, blueOffset:(cb*amt)};
				break;
				case 'contrast':
					return {redMultiplier:amt, redOffset:(cr2-(cr2*amt)), greenMultiplier:amt, greenOffset:(cg2-(cg2*amt)), blueMultiplier:amt, blueOffset:(cb2-(cb2*amt))};
				break;
				case 'invert':
					return {redMultiplier:(1-2*amt), redOffset:(amt*(cr)), greenMultiplier:(1-2*amt), greenOffset:(amt*(cg)), blueMultiplier:(1-2*amt), blueOffset:(amt*(cb))};
				break;
				case 'tint':
					var rgbnum:int = cleanColorValue(rgb);
					return {redMultiplier:(1-amt), redOffset:(rgbnum >> 16)*amt, greenMultiplier:(1-amt), greenOffset:((rgbnum >> 8) & 0xFF)*amt, blueMultiplier:(1-amt), blueOffset:(rgbnum & 0xFF)*amt};
				break;
				case 'reset':
					return {redOffset:0, redMultiplier:1, greenOffset:0, greenMultiplier:1, blueOffset:0, blueMultiplier:1};
				break;
			}
			return {};
		};
	
	}

}
