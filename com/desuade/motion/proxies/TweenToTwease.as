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
			$to[$to.prop] = $to.value;
			delete $to.prop;
			delete $to.value;
			delete $to.duration;
			Twease.tween($to);
		}
		
		public static function standardSequence($ta:Array):void {
			for (var i:int = 0; i < $ta.length; i++) {
				var t:Object = $ta[i];
				t.time = t.duration;
				t[t.prop] = t.value;
				delete t.prop;
				delete t.value;
				delete t.duration;
			}
			Twease.tween($ta);
		}
	
	}

}

