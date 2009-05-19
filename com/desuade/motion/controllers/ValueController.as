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
	 *  <p>Controls the value of a property over time using points to create a sequence of tweens.</p>
	 *	
	 *	<p>It allows for incredible control over the value of a property, in a very powerful and dynamic way. Controllers are the shining stars of the Desuade Motion Package.</p>
	 *	
	 *	<p>
	 *	When created, a ValueController is an object that literally controls the value of a property of a given target. It uses a "PointsContainer" to hold and manage 'points' - similar to the concept of keyframes.
	 *	These points hold information such as the property's value, the position, and easing. When the controller is started, a sequence of tweens is generated to change the property's actual value. It resembles a pragmatic version of Flash CS4's motion editor.
	 *	</p>
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  21.04.2009
	 */
	public class ValueController extends EventDispatcher {
	
		/**
		 *	This is what's used to store and manage points. To add, remove, and work with points, see the documentation on PointsContainers.
		 *	@see PointsContainer
		 */
		public var points:BasePointsContainer;
		
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
		 *	How many decimal points the random spread values have.
		 */
		public var precision:int;
		
		/**
		 *	Which tween class to use for creating the tweens. - ie: BasicTween, Tween, etc.
		 */
		public var tweenclass:Class = BasicTween;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _sequence:*;
		
		/**
		 *	Creates a new ValueController.
		 *	
		 *	@param	target	 The target object that will have it's property controlled.
		 *	@param	property	 The property that's being controlled and tweened.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens, since the position is dependent on the the duration.
		 *	@param	precision	 How many decimal points the random spread values have.
		 *	@param	setvalue	 If true, the begin and end values will be set to the property's current value.
		 *	
		 *	@see #target
		 *	@see #property
		 *	@see #duration
		 *	@see #precision
		 */
		public function ValueController($target:Object, $property:String, $duration:Number, $precision:int = 0, $setvalue:Boolean = true){
			super();
			target = $target;
			property = $property;
			duration = $duration;
			precision = $precision;
			points = new PointsContainer(($setvalue) ? $target[$property] : null);
		}
		
		/**
		 *	If the controller is currently running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Starts the controller. This will internally create a sequence of tweens that will be ran to match the points in the controller's PointsContainer, running from 'begin' to 'end' points.
		 */
		public function start():void {
			setStartValue();
			var ta:Array = createTweens();
			_active = true;
			_sequence = new Sequence(tweenclass);
			_sequence.pushArray(ta);
			_sequence.addEventListener(SequenceEvent.ENDED, tweenEnd, false, 0, true);
			_sequence.addEventListener(SequenceEvent.ADVANCED, advance, false, 0, true);
			_sequence.start();
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
		 *	This sets the property to the generated start value, based on the 'value' and 'spread' properties of the 'begin' point. This normally shouldn't be called, as it is internally called everytime start() is.
		 *	
		 *	@see #start()
		 */
		public function setStartValue():Number {
			var nv:Number = (typeof points.begin.value == 'string') ? target[property] + Number(points.begin.value) : points.begin.value;
			return target[property] = (points.begin.spread !== '0') ? Random.fromRange(nv, ((typeof points.begin.spread == 'string') ? nv + Number(points.begin.spread) : points.begin.spread), precision) : nv;
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
			Debug.output('motion', 10002, [target, property]);
		}
		
		/**
		 *	@private
		 */
		protected function advance($o:Object):void {
			//var pos:String = points.getOrderedLabels()[$o.data.sequence.position]; //possible bottleneck here, performance over small convenience
			dispatchEvent(new ControllerEvent(ControllerEvent.ADVANCED, {position:$o.data.sequence.position, controller:this}));
		}
		
		/**
		 *	@private
		 */
		protected function calculateDuration($previous:Number, $position:Number):Number {
			return duration*($position-$previous);
		}

		/**
		 *	@private
		 */
		protected function createTweens():Array {
			var pa:Array = points.getOrderedLabels();
			var ta:Array = [];
			//skip begin point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = points[pa[i]];
				var nuv:Number;
				if(np.value == null){
					nuv = target[property];
				} else {
					var nnnv:* = np.value;
					if(typeof nnnv == 'string'){
						var nfpv:Number = (ta.length == 0) ? target[property] : ta[ta.length-1].value;
						nuv = nfpv + Number(nnnv);
					} else {
						nuv = nnnv;
					}
				}
				var nv:Number = (np.spread !== '0') ? Random.fromRange(nuv, ((typeof np.spread == 'string') ? nuv + Number(np.spread) : np.spread), precision) : nuv;
				var tmo:Object = {target:target, property:property, value:nv, ease:np.ease, duration:calculateDuration(points[pa[i-1]].position, np.position), delay:0};
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}
