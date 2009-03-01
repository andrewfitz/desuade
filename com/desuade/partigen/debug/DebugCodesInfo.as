package com.desuade.partigen.debug {

	public class DebugCodesInfo extends Object {
		
		public static var codeSet:String = 'info';
		
		public static function load():void {
			Debug.loadCodes(codeSet, _codes);
		}
		
		private static var _codes:Object = {
			1000: "Debug codes for showing helpful information and status updates.",
			1001: "Initialized Tween Proxy: $ v$"
		}
	
	}

}
