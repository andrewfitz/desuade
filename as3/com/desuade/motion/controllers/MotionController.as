/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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
	import com.desuade.motion.sequences.*
	import com.desuade.motion.tweens.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.*;
	
	/**
	 *  Virtual motion editor that creates tweens similar to that of a timeline with keyframes.
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
		protected var _sequence:* = null;
		
		/**
		 *	<p>Creates a new MotionController for the given target and property.</p>
		 *	
		 *	<p>MotionControllers are basically pragmatic motion editors, like those found in Flash CS4 and After Effects.</p>
		 *	
		 *	<p>They use 'keyframes' just like the timeline or motion editor to mark a position where there's a change of value.</p>
		 *	
		 *	<p>Note: DMP Keyframes are not "real" Flash keyframes, and all animation are time-based in the package, rather than frame-based)</p>
		 *	
		 *	<p>Keyframes are managed by a 'KeyframeContainer' which provides methods for adding, configuring, and working with keyframes.</p>
		 *	
		 *	<p>MotionControllers basically "take control" over a property and manage it's value over time. It acts a sequence that tweens properties to the value indicated by 'keyframes', from the 'begin' keyframe to the 'end' keyframe, and any custom keyframes in between.</p>
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
		public function MotionController($target:Object, $property:String = null, $duration:Number = 0, $containerClass:Class = null, $tweenClass:Class = null) {
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
		 *	The internal sequence created from the keyframes.
		 */
		public function get sequence():Sequence { 
			return _sequence; 
		}
		
		/**
		 *	Starts the controller. This will internally create a Sequence (of tweens) that will be ran to match the points in the controller's PointsContainer, running from 'begin' to 'end' points.
		 *	
		 *	@param	keyframe	 The label of the keyframe to start at.
		 *	@param	startTime	This is like keyframe, but instead uses actual time to start at, as if it's already been running. This overrides the keyframe param.
		 *	@param	rebuild		 Forces a rebuild of the internal sequence on start.
		 *	@return		The MotionController (for chaining)
		 */
		public function start($keyframe:String = 'begin', $startTime:Number = 0, $rebuild:Boolean = false):* {
			$keyframe = ($keyframe == null) ? 'begin' : $keyframe;
			if($keyframe == 'end'){
				_sequence = null;
				dispatchEvent(new ControllerEvent(ControllerEvent.STARTED, {controller:this}));
				setStartValue($keyframe);
				dispatchEvent(new ControllerEvent(ControllerEvent.ENDED, {controller:this}));
			} else {
				_active = true;
				if(_sequence == null || $rebuild) rebuild();
				_sequence.addEventListener(SequenceEvent.ENDED, tweenEnd, false, 0, false);
				_sequence.addEventListener(SequenceEvent.ADVANCED, advance, false, 0, false);
				setStartValue($keyframe);
				if($keyframe != 'begin') _sequence.start(keyframes.getOrderedLabels().indexOf($keyframe));
				else if($startTime > 0) _sequence.startAtTime($startTime);
				else _sequence.start();
				dispatchEvent(new ControllerEvent(ControllerEvent.STARTED, {controller:this}));
			}
			return this;
		}
		
		/**
		 *	This stops the controller, and all internal tweens associated to it.
		 */
		public function stop():void {
			if(_active) _sequence.stop();
			else Debug.output('motion', 10003);
		}
		
		/**
		 *	This rebuilds the internal sequence.
		 */
		public function rebuild():void {
			_sequence = buildSequence(target, property, duration);
		}
		
		/**
		 *	This creates the actual sequence object used to go through each tween. This is done automatically internally.
		 *	
		 *	@param	target	 The target object to use.
		 *	@param	propert	 The property to use.
		 *	@param	duration The duration of the sequence.
		 *	
		 *	@return		ClassSequence
		 */
		public function buildSequence($target:Object, $property:String, $duration:Number):ClassSequence {
			var ns:ClassSequence = new ClassSequence(keyframes.tweenClass);
			ns.overrides = {target:$target};
			ns.pushArray(keyframes.createTweens($target, $property, $duration));
			return ns;
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
		 *	
		 *	@return		The MotionController
		 */
		public function setSingleTween($begin:*, $beginSpread:*='0', $end:*='0', $endSpread:*='0', $ease:* = null, $extras:Object = null):MotionController {
			keyframes.begin.value = $begin;
			keyframes.begin.spread = $beginSpread;
			keyframes.end.value = $end;
			keyframes.end.spread = $endSpread;
			keyframes.end.ease = $ease;
			keyframes.end.extras = $extras || {};
			return this;
		}
		
		/**
		 *	This sets the initial start value of the target. This normally doesn't need to be called, as it is internally called everytime start() is.
		 *	
		 *	@param	keyframe	 This is the label of the keyframe to generate a starting value from.
		 */
		public function setStartValue($keyframe:String = 'begin'):void {
			keyframes.setStartValue(target, property, $keyframe, _sequence);
		}
		
		/**
		 *	Create an XML object that contains the MotionController config, KeyframeContainer, and all child Keyframes.
		 *	
		 *	@return		An XML object representing the MotionController
		 */
		public function toXML():XML {
			var txml:XML = <MotionController />;
			txml.setLocalName(XMLHelper.getSimpleClassName(this));
			txml.@duration = duration;
			txml.@property = property;
			txml.appendChild(keyframes.toXML());
			return txml;
		}
		
		/**
		 *	Configures the MotionController from the XML object and sets the keyframes to the child KeyframeContainer XML and it's child Keyframes.
		 *	
		 *	@param	xml	 The XML object containing the config for the MotionController
		 *	@param	useproperty	 If this is true, the current MotionController's property will change. If false, it will stay the same.
		 *	@param	useduration	 If this is true, the current MotionController's duration will change. If false, it will stay the same.
		 *	
		 *	@return		The MotionController object (for chaining)
		 */
		public function fromXML($xml:XML, $useproperty:Boolean = true, $useduration:Boolean = true):MotionController {
			if($useproperty) property = String($xml.@property);
			if($useduration) duration = Number($xml.@duration);
			var kfclass:Class = getDefinitionByName("com.desuade.motion.controllers::" + $xml.children()[0].localName()) as Class;
			keyframes = new kfclass().fromXML($xml.children()[0]);
			return this;
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
