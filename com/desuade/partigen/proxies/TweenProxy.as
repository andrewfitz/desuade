package com.desuade.partigen.proxies {
	
	import com.desuade.partigen.debug.*
	
	public class TweenProxy extends Object {
		
		public static var engine:String;
		public static var engineVersion:Number;
		public static var func_tween:Function;

		public static function loadProxy(name:String, version:Number, po:Object):void {
			engine = name;
			engineVersion = version;
			for (var i:String in po) {
				TweenProxy[i] = po[i];
			}
			Debug.output('info', 1001, [engine, engineVersion]);
		}
		
		public static function tween(target:Object, prop:String, value:Number, duration:Number, ease:String = 'linear', delay:Number = 0):void {
			var to:Object = {target:target, time:duration, ease:ease, delay:delay};
			to[prop] = value;
			func_tween(to, prop);
		}
		
	}

}

