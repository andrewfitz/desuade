/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

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

package com.desuade.partigen.controllers {
	
	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.partigen.emitters.*;
	
	import flash.utils.*;
	
	/**
	 *  This controls the configuration for controllers that effect the actual emitter.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class EmitterController extends Object {
		
		/**
		 *	The default tween class to use for emitter controllers
		 */
		public static var tweenClass:Class = BasicTween;
		
		/**
		 *	@private
		 */
		protected var _emitter:Emitter;
	
		/**
		 *	<p>This creates a new EmitterController. This shouldn't be called, as it's created by the emitter automatically.</p>
		 *	
		 *	<p>All the controllers (by default) get started whenever the emitter starts.</p>
		 *	
		 *	@param	emitter	 The emitter to control
		 */
		public function EmitterController($emitter:Emitter) {
			super();
			_emitter = $emitter;
		}
		
		/**
		 *	<p>This sets the initial value of the given property. If the property exists as a EmitterTweenController already, it will modify the current 'begin' keyframe. If it doesn't, this creates a new EmitterTweenController and sets its 'begin' keyframe.</p>
		 *	
		 *	<p>Note: this only sets EmitterTweenControllers, NOT EmitterPhysicsControllers.</p>
		 *	
		 *	@param	property	 The emitter's property to be set.
		 *	@param	value	 The property's value.
		 *	@param	spread	 The spread of the value. If this is anything besides '0', a random value will be generated using the value and spread.
		 *	@param	precision	 The amount of decimal points used when creating a spread value
		 *	@param	extras	 An 'extras' object to be passed to the tween engine for that keyframe.
		 */
		public function addBeginValue($property:String, $value:*, $spread:* = '0', $precision:int = 0, $extras:Object = null):EmitterTweenController {
			if(this[$property] == undefined) this[$property] = new EmitterTweenController(_emitter, $property, 0);
			this[$property].keyframes.begin.value = $value;
			this[$property].keyframes.begin.spread = $spread;
			this[$property].keyframes.precision = $precision;
			if($extras != null) this[$property].keyframes.begin.extras = $extras;
			return this[$property];
		}
		
		/**
		 *	This creates an EmitterTweenController for the given property. This actually inherits a real MotionController.
		 *	
		 *	@param	property	 The emitter's property to be set.
		 *	@param	duration	 The entire duration for the controller. Since the emitter always exists, there must be a set duration.
		 */
		public function addTween($property:String, $duration:Number):EmitterTweenController {
			return this[$property] = new EmitterTweenController(_emitter, $property, $duration);
		}
		
		/**
		 *	This creates a EmitterPhysicsController (which inherits PhysicsMultiController) that has 3 EmitterTweenControllers for each physics property: velocity, acceleration, and friction.
		 *	
		 *	@param	property	 The emitter's property to be set.
		 *	@param	duration	 The entire duration for the controller. Since the emitter always exists, there must be a set duration.
		 *	@param	flip	 To set the physics's object flip value. This is useful for some properties like 'y'.
		 */
		public function addPhysics($property:String, $duration:Number, $flip:Boolean = false):EmitterPhysicsController {
			this[$property] = new EmitterPhysicsController(_emitter, $property, $duration);
			this[$property].physics.flip = $flip;
			return this[$property];
		}
		
		/**
		 *	This starts all the emitter MotionControllers at once.
		 */
		public function start():void {
			for (var p:String in this) {
				this[p].start();
			}
		}
		
		/**
		 *	This stops all the emitter MotionControllers at once.
		 */
		public function stop():void {
			for (var p:String in this) {
				this[p].stop();
			}
		}
		
		/**
		 *	Creates an XML object containing configuration for the EmitterController
		 *	
		 *	@return		An XML object representing the EmitterController
		 */
		public function toXML():XML {
			var txml:XML = <EmitterController />;
			for (var p:String in this){
				txml.appendChild(this[p].toXML());
			}
			return txml;
		}
		
		/**
		 *	This configures the EmitterController from XML and creates all child controllers.
		 *	
		 *	@param	xml	 The XML object used to configure the EmitterController.
		 *	
		 *	@return		The EmitterController object (for chaining)
		 */
		public function fromXML($xml:XML):EmitterController {
			var cd:XMLList = $xml.children();
			for (var i:int = 0; i < cd.length(); i++) {
				var contclass:Class = getDefinitionByName("com.desuade.partigen.controllers::" + cd[i].localName()) as Class;
				this[cd[i].@property] = new contclass(_emitter, cd[i].@property, 0).fromXML(cd[i]);
			}
			return this;
		}
		
	}

}
