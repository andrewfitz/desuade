package com.desuade.motion.proxies {
	
	import com.desuade.motion.tween.*
	import com.desuade.debugging.*

	public class TweenToMotionBasic extends Object {
		
		public static var engineName:String = "Desuade Motion(basic)";
		public static var engineVersion:Number = 1.0;
	
		public static function init():void {
			TweenProxy.loadProxy(engineName, engineVersion, {func_tween: standardTween, func_sequence: standardSequence});
		}
		
		//remember to make sure the custom tweening engine can recognize the ease String 'linear'
		public static function standardTween($to:Object):void {
			new BasicTween($to).start();
		}
		
		public static function standardSequence($ta:Array):void {
			var ss:BasicSequence = new BasicSequence();
			for (var i:int = 0; i < $ta.length; i++) {
				ss.push($ta[i]);
			}
			ss.start();
		}
	
	}

}

