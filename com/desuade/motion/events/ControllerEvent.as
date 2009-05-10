package com.desuade.motion.events {

	import flash.events.Event;
	
	/**
	 *  This event is created by controller classes in the Motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class ControllerEvent extends Event {
		
		/**
		 *	This event is fired when a controller starts at the 'begin' point.
		 */
		public static const STARTED:String = "started";
		
		/**
		 *	This event is fired when a controller gets to and begins a tween from the next point.
		 */
		public static const ADVANCED:String = "advanced";
		
		/**
		 *	This event is fired when a controller finishes and reaches the 'end' point.
		 */
		public static const ENDED:String = "ended";

		/**
		 *	<p>This this object that gets passed that has different objects depending on what event:</p>
		 *	
		 *	<p>STARTED and ENDED: <code>controller</code></p>
		 *	<p>ADVANCED: <code>controller</code> and <code>position</code></p>
		 */
		public var data:Object;

		/**
		 *	Creates a new ControllerEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function ControllerEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new ControllerEvent(this.type, this.data, this.bubbles, this.cancelable);
		}

	}

}