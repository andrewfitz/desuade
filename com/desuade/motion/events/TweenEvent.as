package com.desuade.motion.events {

	import flash.events.Event;
	
	/**
	 *  This event is created by any of the tween classes in the motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class TweenEvent extends Event {
		/**
		 *	This event is fired when a tween starts.
		 */
		public static const STARTED:String = "started";
		
		/**
		 *	This event is fired when a tween is updating the target's property.
		 */
		public static const UPDATED:String = "updated";
		
		/**
		 *	This even is fired when a tween ends.
		 */
		public static const ENDED:String = "ended";

		/**
		 *	<p>This this object that gets passed that has different objects depending on what dispatches it and what event:</p>
		 *	
		 *	<p>PrimitiveTweens pass 1 object, themselves: <code>primitiveTween</code>.</p>
		 *	<p>BasicTweens and Tweens (and decedents) pass 2 objects, themselves and the PrimitiveTweens they create: <code>tween</code> and <code>primitiveTween</code>.</p>
		 *	<p>Note: The ENDED event does not pass a PrimitiveTween when it's a func-only tween, or when a delayed tween is stopped before it begins to tween.</p>
		 *	
		 */
		public var data:Object;
		
		/**
		 *	Creates a new TweenEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function TweenEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new TweenEvent(this.type, this.data, this.bubbles, this.cancelable);
		}

	}

}