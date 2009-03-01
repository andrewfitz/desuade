package com.desuade.partigen.debug {

	public class DebugCodesDevelop extends Object {
		
		public static var codeSet:String = 'develop';
		
		public static function load():void {
			Debug.loadCodes(codeSet, _codes);
		}
		
		private static var _codes:Object = {
			1000: "Debug codes for aiding in development.",
			1001: "Called: TweenToTwease.standardTween - target: $",
			1002: "Point '$' added at position $"
		}
	
	}

}
