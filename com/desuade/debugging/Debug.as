package com.desuade.debugging {

	public class Debug extends Object {
	
		private static var _codes:Object = {};
		public static var onlyCodes:Boolean = false;
		public static var enabled:Boolean = true;
		
		public static function load(codeset:CodeSet):void {
			_codes[codeset.setname] = codeset.codes;
		}
		
		public static function output(codeSet:String, code:Number, props:Array = null):void {
			if (enabled) {
				if(_codes[codeSet] != undefined) {
					if(onlyCodes){
						trace("Debug: " + codeSet + " #" + code);
					} else {
						trace(r(_codes[codeSet][code], props));
					}
				} else {
					trace("Debug: " + codeSet + "(missing) #" + code);
				}
			}
		}
		
		private static function r(str:String, arr:Array):String {
			var ns:String = str;
			for (var i:int = 0; i < arr.length; i++) {
				ns = ns.replace("$", arr[i]);
			}
			return ns;
		}
	}

}

