package com.desuade.partigen.proxies {

	import com.desuade.partigen.proxies.TweenProxy
	import com.visualcondition.twease.*

	public class TweenToTwease extends Object {
		
		public static var engineName:String = "Twease";
		public static var engineVersion:Number = Twease.version;
	
		public static function init():void {
			Twease.register(Easing);
			TweenProxy.loadProxy(engineName, engineVersion, {func_tween: standardTween});
		}
		
		public static function standardTween(to:Object, prop:String):void {
			trace("standard tween: " + to['target'] + " - " + prop);
			Twease.tween(to);
		}
	
	
	}

}

