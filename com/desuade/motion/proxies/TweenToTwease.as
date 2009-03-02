package com.desuade.motion.proxies {

	import com.visualcondition.twease.*
	import com.desuade.debugging.*

	public class TweenToTwease extends Object {
		
		public static var engineName:String = "Twease";
		public static var engineVersion:Number = Twease.version;
	
		public static function init():void {
			Twease.register(Easing, Colors);
			TweenProxy.loadProxy(engineName, engineVersion, {func_tween: standardTween, func_sequence: standardSequence});
		}
		
		//remember to make sure the custom tweening engine can recognize the ease String 'linear'
		public static function standardTween($to:Object):void {
			$to.time = $to.duration;
			delete $to.duration;
			Twease.tween($to);
		}
		
		public static function standardSequence($ta:Array):void {
			for (var i:int = 0; i < $ta.length; i++) {
				$ta[i].time = $ta[i].duration;
				delete $ta[i].duration;
			}
			Twease.tween($ta);
		}
	
	}

}

