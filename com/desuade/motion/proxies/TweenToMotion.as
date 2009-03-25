package com.desuade.motion.proxies {
	
	import com.desuade.motion.tween.*
	import com.desuade.debugging.*

	public class TweenToMotion extends Object {
		
		public static var engineName:String = "Desuade Motion";
		public static var engineVersion:Number = 1.0;
	
		public static function init():void {
			TweenProxy.loadProxy(engineName, engineVersion, {func_tween: standardTween, func_sequence: standardSequence});
		}
		
		//remember to make sure the custom tweening engine can recognize the ease String 'linear'
		public static function standardTween($to:Object):Tween {
			var t:Tween = new Tween($to);
			t.start();
			return t;
		}
		
		public static function standardSequence($ta:Array):Sequence {
			var ss:Sequence = new Sequence();
			for (var i:int = 0; i < $ta.length; i++) {
				ss.push($ta[i]);
			}
			ss.start();
			return ss;
		}
	
	}

}

