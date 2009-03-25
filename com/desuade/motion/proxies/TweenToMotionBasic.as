package com.desuade.motion.proxies {
	
	import com.desuade.motion.tween.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	public class TweenToMotionBasic extends Object {
		
		public static var engineName:String = "Desuade Motion(basic)";
		public static var engineVersion:Number = 1.0;
	
		public static function init():void {
			TweenProxy.loadProxy(engineName, engineVersion, {func_tween: basicTween, func_sequence: basicSequence, func_sequenceEnd: listenToSequenceEnd, func_sequenceStop: stopSequence});
		}
		
		//remember to make sure the custom tweening engine can recognize the ease String 'linear'
		public static function basicTween($to:Object):BasicTween {
			var t:BasicTween = new BasicTween($to);
			t.start();
			return t;
		}
		
		public static function basicSequence($ta:Array):BasicSequence {
			var ss:BasicSequence = new BasicSequence();
			for (var i:int = 0; i < $ta.length; i++) {
				ss.push($ta[i]);
			}
			ss.start();
			return ss;
		}
		
		public static function listenToSequenceEnd($seq:BasicSequence, $fc:Function):void {
			$seq.addEventListener(SequenceEvent.ENDED, $fc);
		}
		
		public static function stopSequence($seq:Sequence, $prop:String, $func:Function):void {
			$seq.stop();
		}
	
	}

}

