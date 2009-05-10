package com.desuade.motion.events {

	import flash.events.Event;

	/**
	 *  This event is created by the Sequence class in the Motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class SequenceEvent extends Event {
		
		/**
		 *	This event is fired when a sequence starts.
		 */
		public static const STARTED:String = "started";
		
		/**
		 *	This event is fired when a tween ends and the sequence moves to the next item.
		 */
		public static const ADVANCED:String = "advanced";
		
		/**
		 *	This event is fired when a sequence ends.
		 */
		public static const ENDED:String = "ended";

		/**
		 *	<p>This this object that gets passed that has different objects depending on what event:</p>
		 *	
		 *	<p>STARTED and ENDED: <code>sequence</code></p>
		 *	<p>ADVANCED: <code>sequence</code> and <code>position</code></p>
		 */
		public var data:Object;
		
		/**
		 *	Creates a new SequenceEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function SequenceEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new SequenceEvent(this.type, this.data, this.bubbles, this.cancelable);
		}

	}

}