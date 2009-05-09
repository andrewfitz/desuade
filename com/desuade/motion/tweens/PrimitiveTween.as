package com.desuade.motion.tweens {

	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	import com.desuade.motion.eases.Linear;
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	/**
	 *  This is the most basic tween with no management. Users should not create this directly, instead use BasicTween.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class PrimitiveTween extends EventDispatcher {
		
		/**
		 *	@private
		 */
		public static var _count:int = 0;
		
		/**
		 *	@private
		 */
		internal static var _sprite:Sprite = new Sprite();
		
		/**
		 *	This is the unique internal id of the tween.
		 */
		public var id:int;
		
		/**
		 *	The target object to perform the tween on.
		 */
		public var target:Object;
		
		/**
		 *	The property to tween on the target.
		 */
		public var property:String;
		
		/**
		 *	The new (end) value the property will be tweened to.
		 */
		public var value:Number;
		
		/**
		 *	How long the tween will last in ms.
		 */
		public var duration:int;
		
		/**
		 *	What easing equation to use to tween.
		 */
		public var ease:Function;
		
		/**
		 *	@private
		 */
		internal var startvalue:Number;
		
		/**
		 *	@private
		 */
		internal var starttime:int;
		
		/**
		 *	@private
		 */
		internal var difvalue:Number;
		
		/**
		 *	This creates a new, raw PrimitiveTween. Users should use the Basic tweens instead of creating this directly.
		 *	
		 *	@param	target	 The target object to perform the tween on.
		 *	@param	property	 The property to tween on the target.
		 *	@param	value	 The new (end) value the property will be tweened to.
		 *	@param	duration	 How long the tween will last in ms.
		 *	@param	ease	 What easing equation to use to tween.
		 *	
		 *	@see	#target
		 *	@see	#property
		 *	@see	#value
		 *	@see	#duration
		 *	@see	#ease
		 *	
		 */
		public function PrimitiveTween($target:Object, $property:String, $value:Number, $duration:int, $ease:Function = null) {
			super();
			id = _count++, target = $target, duration = $duration, ease = $ease || Linear.none, starttime = getTimer();
			if($property != null) {
				property = $property, value = $value, startvalue = $target[$property];
				difvalue = (startvalue > value) ? (value-startvalue) : -(startvalue-value);
			}
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {primitiveTween:this}));
			_sprite.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			Debug.output('motion', 50001, [id]);
		}
		
		/**
		 *	This ends and kills the tween immediately.
		 *	
		 *	@param	broadcast	 If false, this will not broadcast an ENDED event.
		 */
		public function end($broadcast:Boolean = true):void {
			Debug.output('motion', 50002, [id]);
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
			if($broadcast) dispatchEvent(new TweenEvent(TweenEvent.ENDED, {primitiveTween:this}));
			delete this;
		}
		
		/**
		 *	@private
		 */
		protected function update($u:Object):void {
			var tmr:int = getTimer() - starttime;
			if(tmr >= duration){
				target[property] = value;
				end();
			} else {
				target[property] = ease(tmr, startvalue, difvalue, duration);
				dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {primitiveTween:this}));
			}
		}
	
	}

}
