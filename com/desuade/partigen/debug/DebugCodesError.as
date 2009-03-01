package com.desuade.partigen.debug {

	public class DebugCodesError extends Object {
		
		public static var codeSet:String = 'error';
		
		public static function load():void {
			Debug.loadCodes(codeSet, _codes);
		}
		
		private static var _codes:Object = {
			1000: "Debug codes for actual code and engine errors.",
			1001: "This is error code 1"
		}
	
	}

}

