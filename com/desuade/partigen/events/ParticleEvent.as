package com.desuade.partigen.events {

	import flash.events.Event;
	
	/**
	 *  Events for particles. Events are broadcasted from the emitter.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class ParticleEvent extends Event {
		
		/**
		 *	This gets fired everytime a particle is born.
		 */
		public static const BORN:String = "born";
		
		/**
		 *	This gets fired everytime a particle dies. Occurs naturally, or when kill() is called.
		 */
		public static const DIED:String = "died";
		
		/**
		 *	This is the info object that's gets passed to the function. It contains the <code>particle</code> property, that is the particle that the event is associated with.
		 */
		public var info:Object;

		/**
		 *	Creates a new ParticleEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function ParticleEvent($type:String, $info:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.info = $info;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new ParticleEvent(this.type, this.info, this.bubbles, this.cancelable);
		}
		
	}

}
