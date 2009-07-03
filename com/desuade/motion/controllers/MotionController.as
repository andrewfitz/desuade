/*
This software is distributed under the MIT License.

Copyright (c) 2009 Desuade (http://desuade.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.sequencers.*
	import com.desuade.motion.tweens.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *  Virtual motion editor that creates tweens similar to that of a timeline with keyframes
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public class MotionController extends EventDispatcher {
		/**
		 *	The default tween class to use for emitter controllers
		 */
		public static var tweenClass:Class = BasicTween;
		
		/**
		 *	The default colortween class to use for emitter controllers
		 */
		public static var colorTweenClass:Class = BasicColorTween;
		
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
		 *	@param	containerClass	 The class of keyframe container to use
		 *	@param	tweenClass	 The class of tweens to pass to the keyframe container
		 *	
		 *	@see #target
		 *	@see #property
		 *	@see #duration
		 */
		public function MotionController($target:Object, $property:String, $duration:Number, $containerClass:Class = null, $tweenClass:Class = null) {
			super();
			target = $target;
			property = $property;
			duration = $duration;
			var containerClass:Class = ($containerClass == null) ? KeyframeContainer : $containerClass;
			keyframes = new containerClass($tweenClass);
		}
		
		/**
		 *	If the controller is currently running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Starts the controller. This will internally create a Sequence (of tweens) that will be ran to match the points in the controller's PointsContainer, running from 'begin' to 'end' points.
		 *	
		 *	@param	keyframe	 The label of the keyframe to start at.
		 */
		public function start($keyframe:String = null):void {
			setStartValue();
			var ta:Array = keyframes.createTweens(target, property, duration);
			_active = true;
			_sequence = new Sequence(keyframes.tweenClass);
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
		
		/**
		 *	This easily sets the 'begin' and 'end' keyframes of the controller to create a standard "one-shot" tween.
		 *	
		 *	@param	begin	 The beginning value.
		 *	@param	beginSpread	 The beginning spread value.
		 *	@param	end	 The end value for the tween.
		 *	@param	endSpread	 The end spread value.
		 *	@param	ease	 The ease to use for the tween on the end keyframe.
		 *	@param	extras	 The extras object for the end keyframe.
		 */
		public function setSingleTween($begin:*, $beginSpread:*, $end:*, $endSpread:*, $ease:* = null, $extras:Object = null):void {
			keyframes.begin.value = $begin;
			keyframes.begin.spread = $beginSpread;
			keyframes.end.value = $end;
			keyframes.end.spread = $endSpread;
			keyframes.end.ease = $ease;
			keyframes.end.extras = $extras || {};
		}
		
		/**
		 *	This sets the initial start value of the target. This normally doesn't need to be called, as it is internally called everytime start() is.
		 */
		public function setStartValue():void {
			keyframes.setStartValue(target, property);
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
