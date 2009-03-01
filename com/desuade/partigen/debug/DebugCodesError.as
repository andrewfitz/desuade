package com.desuade.partigen.debug {

	public class DebugCodesError extends Object {
		
		public static var codeSet:String = 'error';
		
		public static function load():void {
			Debug.loadCodes(codeSet, _codes);
		}
		
		private static var _codes:Object = {
			1001: "This is a test error code",
			1002: "This is yet another test code for errors",
			1003: "The property $ was found to reset at $",
			1004: "Test code 4"
		}
	
	}

}

