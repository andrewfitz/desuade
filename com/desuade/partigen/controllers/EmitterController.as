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

package com.desuade.partigen.controllers {
	
	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.partigen.emitters.*;
	
	/**
	 *  This controls the configuration for controllers that effect the actual emitter
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
		 *	This creates a new EmitterController. This shouldn't be called, as it's created by the emitter automatically.
		 *	
		 *	All the controllers (by default) get started whenever the emitter starts.
		 *	
		 *	@param	emitter	 The emitter to control
		 */
		public function EmitterController($emitter:Emitter) {
			super();
			_emitter = $emitter;
		}
		
		/**
		 *	This creates an EmitterTweenController for the given property. This actually inherits a real MotionController.
		 *	
		 *	@param	property	 The emitter's property to be set.
		 *	@param	duration	 The entire duration for the controller. Since the emitter always exists, there must be a set duration.
		 */
		public function addTween($property:String, $duration:Number):void {
			this[$property] = new EmitterTweenController(_emitter, $property, $duration);
		}
		
		/**
		 *	This creates a ParticlePhysicsController (which inherits PhysicsMultiController) that has 3 ParticleTweenControllers for each physics property: velocity, acceleration, and friction.
		 *	
		 *	@param	property	 The emitter's property to be set.
		 *	@param	duration	 The entire duration for the controller. Since the emitter always exists, there must be a set duration.
		 *	@param	flip	 To set the physics's object flip value. This is useful for some properties like 'y'.
		 */
		public function addPhysics($property:String, $duration:Number, $flip:Boolean = false):void {
			this[$property] = new EmitterPhysicsController(_emitter, $property, $duration);
			this[$property].physics.flip = $flip;
		}
		
		/**
		 *	This starts all the MotionControllers at once.
		 */
		public function startAll():void {
			for (var p:String in this) {
				this[p].start();
			}
		}
		
		/**
		 *	This stops all the MotionControllers at once.
		 */
		public function stopAll():void {
			for (var p:String in this) {
				this[p].stop();
			}
		}
	
	}

}
