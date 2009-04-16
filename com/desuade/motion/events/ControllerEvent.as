package com.desuade.motion.events {

	import flash.events.Event;

	public class ControllerEvent extends Event {
		public static const STARTED:String = "started";
		public static const ENDED:String = "ended";

		public var info:Object;

		public function ControllerEvent($type:String, $info:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.info = $info;
		}

		public override function clone():Event{
			return new ControllerEvent(this.type, this.info, this.bubbles, this.cancelable);
		}

	}

}