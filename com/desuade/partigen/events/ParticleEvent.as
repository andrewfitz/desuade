package com.desuade.partigen.events {

	import flash.events.Event;

	public class ParticleEvent extends Event {
		
		public static const BORN:String = "born";
		public static const DIED:String = "died";

		public var info:Object;

		public function ParticleEvent($type:String, $info:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.info = $info;
		}

		public override function clone():Event{
			return new ParticleEvent(this.type, this.info, this.bubbles, this.cancelable);
		}
		
	}

}
