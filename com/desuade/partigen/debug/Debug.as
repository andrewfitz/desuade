package com.desuade.partigen.debug {

	public class Debug extends Object {
	
		private static var _codes:Object = {};
		public static var onlyCodes:Boolean = false;
		
		public static function loadCodes(codeSet:String, co:Object):void {
			_codes[codeSet] = co;
		}
		
		public static function output(codeSet:String, code:Number, props:Array = null):void {			
			if(onlyCodes){
				trace("Debug: " + codeSet + " #" + code);
			} else {
				if(_codes[codeSet] != undefined) {
					trace(r(_codes[codeSet][code], props));
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

