package com.desuade.partigen.proxies {

	import com.visualcondition.twease.*
	import com.desuade.partigen.debug.*

	public class TweenToTwease extends Object {
		
		public static var engineName:String = "Twease";
		public static var engineVersion:Number = Twease.version;
	
		public static function init():void {
			Twease.register(Easing);
			TweenProxy.loadProxy(engineName, engineVersion, {func_tween: standardTween});
		}
		
		//remember to make sure the custom tweening engine can recognize the ease String 'linear'
		public static function standardTween(to:Object, prop:String):void {
			Twease.tween(to);
			//debug shows standard tween being called
			Debug.output('develop', 1001, [to['target'], prop])
		}
	
	}

}

