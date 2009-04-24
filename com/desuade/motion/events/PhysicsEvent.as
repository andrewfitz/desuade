package com.desuade.motion.events {

	import flash.events.Event;
	
	/**
	 *  This event is created by the BasicPhysics class in the motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class PhysicsEvent extends Event {
		/**
		 *	This event is fired when a BasicPhysics object is updating the target's property.
		 */
		public static const UPDATED:String = "updated";
		
		/**
		 *	<p>This this object that gets passed when an event is fired. It contains the BasicPhysics object: <code>basicPhysics</code></p>
		 */
		public var info:Object;
		
		/**
		 *	Creates a new PhysicsEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function PhysicsEvent($type:String, $info:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.info = $info;
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new TweenEvent(this.type, this.info, this.bubbles, this.cancelable);
		}

	}

}