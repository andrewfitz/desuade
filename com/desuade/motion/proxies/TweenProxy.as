package com.desuade.motion.proxies {
	
	import com.desuade.debugging.*
	
	public class TweenProxy extends Object {
		
		public static var engine:String;
		public static var engineVersion:Number;
		protected static var func_tween:Function;
		protected static var func_sequence:Function;
		protected static var func_sequenceEnd:Function;
		protected static var func_sequenceStop:Function;

		public static function loadProxy($name:String, $version:Number, $po:Object):void {
			engine = $name;
			engineVersion = $version;
			for (var i:String in $po) {
				TweenProxy[i] = $po[i];
			}
			Debug.output('motion', 10003, [engine, engineVersion]);
		}
		
		public static function tween($tweenObject:Object):* {
			return func_tween($tweenObject);
		}
		
		public static function sequence($sequenceArray:Array):* {
			return func_sequence($sequenceArray);
		}
		
		public static function sequenceEndFunc($seq:*, $fc:Function):void {
			func_sequenceEnd($seq, $fc);
		}
		
		public static function stopSequence($seq:*, $prop:String, $func:Function = null):void {
			func_sequenceStop($seq, $prop, $func);
		}
		
	}

}

