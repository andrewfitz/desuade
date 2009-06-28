package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.sequencers.*
	import com.desuade.motion.tweens.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class MotionController extends EventDispatcher {
		
		/**
		 *	The target object that will have it's property controlled.
		 */
		public var target:Object;
		
		/**
		 *	The property that's being controlled and tweened.
		 */
		public var property:String;
		
		/**
		 *	The duration of the entire sequence to last for in seconds. This affects length of the tweens, since the position is dependent on the the duration.
		 */
		public var duration:Number;
		
		/**
		 *	The KeyframeContainer class to use to determine the kind of tween.
		 */
		public var containerclass:Class = KeyframeContainer;
		
		/**
		 *	This is what's used to store and manage keyframes. To add, remove, and work with keyframes, see the documentation on KeyframeContainers.
		 *	@see KeyframeContainer
		 */
		public var keyframes:KeyframeContainer;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _sequence:*;
		
		/**
		 *	Creates a new MotionController.
		 *	
		 *	@param	target	 The target object that will have it's property controlled.
		 *	@param	property	 The property that's being controlled and tweened.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens, since the position is dependent on the the duration.
		 *	@param	containerclass	 The class of keyframe container to use
		 *	
		 *	@see #target
		 *	@see #property
		 *	@see #duration
		 *	@see #containerclass
		 */
	
		public function MotionController($target:Object, $property:String, $duration:Number, $containerclass:Class = null) {
			super();
			target = $target;
			property = $property;
			duration = $duration;
			containerclass = ($containerclass == null) ? KeyframeContainer : $containerclass;
			keyframes = new containerclass();
		}
		
		/**
		 *	If the controller is currently running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Starts the controller. This will internally create a sequence of tweens that will be ran to match the points in the controller's PointsContainer, running from 'begin' to 'end' points.
		 *	
		 *	@param	keyframe	 The label of the keyframe to start at.
		 */
		public function start($keyframe:String = null):void {
			keyframes.setStartValue(target, property);
			var ta:Array = keyframes.createTweens(target, property, duration);
			_active = true;
			_sequence = new Sequence(keyframes.tweenclass);
			_sequence.pushArray(ta);
			_sequence.addEventListener(SequenceEvent.ENDED, tweenEnd, false, 0, true);
			_sequence.addEventListener(SequenceEvent.ADVANCED, advance, false, 0, true);
			if($keyframe != null) _sequence.start(keyframes.getOrderedLabels().indexOf($keyframe));
			else _sequence.start();
			dispatchEvent(new ControllerEvent(ControllerEvent.STARTED, {controller:this}));
		}
		
		/**
		 *	This stops the controller, and all internal tweens associated to it.
		 */
		public function stop():void {
			if(_active) _sequence.stop();
			else Debug.output('motion', 10003);
		}
		
		//private methods
		
		/**
		 *	@private
		 */
		public function tweenEnd(... args):void {
			_active = false;
			dispatchEvent(new ControllerEvent(ControllerEvent.ENDED, {controller:this}));
			_sequence.removeEventListener(SequenceEvent.ENDED, tweenEnd);
			_sequence.removeEventListener(SequenceEvent.ADVANCED, advance);
			Debug.output('motion', 10002, [property]);
		}
		
		/**
		 *	@private
		 */
		protected function advance($o:Object):void {
			//var pos:String = points.getOrderedLabels()[$o.data.sequence.position]; //possible bottleneck here, performance over small convenience
			dispatchEvent(new ControllerEvent(ControllerEvent.ADVANCED, {position:$o.data.sequence.position, controller:this}));
		}
		
	
	}

}
