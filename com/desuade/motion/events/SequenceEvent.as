package com.desuade.motion.events {

	import flash.events.Event;

	public class SequenceEvent extends Event {
		public static const STARTED:String = "started";
		public static const ADVANCED:String = "advanced";
		public static const ENDED:String = "ended";

		public var info:Object;

		public function SequenceEvent($type:String, $info:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.info = $info;
		}

		public override function clone():Event{
			return new SequenceEvent(this.type, this.info, this.bubbles, this.cancelable);
		}

	}

}