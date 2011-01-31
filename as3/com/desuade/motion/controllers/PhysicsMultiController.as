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
	
	import com.desuade.motion.physics.*;
	
	/**
	 *  An extension of a MultiController specifically for Physics objects.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class PhysicsMultiController extends MultiController {
		
		/**
		 *	@private
		 */
		protected var _physics:BasicPhysics;
		
		/**
	     *  The velocity MotionController.
	     *  
	     *  @see com.desuade.motion.physics.BasicPhysics#velocity
	     *  @see MotionController
	     */
	    //public var velocity:MotionController;

	    /**
	     *  The acceleration MotionController.
	     *  
	     *  @see com.desuade.motion.physics.BasicPhysics#acceleration
	     *  @see MotionController
	     */
	   // public var acceleration:MotionController;

	    /**
	     *  The friction MotionController.
	     *  
	     *  @see com.desuade.motion.physics.BasicPhysics#friction
	     *  @see MotionController
	     */
	    //public var friction:MotionController;
		
		
		/**
		 *	<p>This creates a new PhysicsMultiController. This controls the velocity, acceleration, and friction for a given target's property using a physics object.</p>
		 *	
		 *	<p>Like a regular MultiController, there are child MotionControllers. For this, there are only 3: velocity, acceleration, and friction - accessible as this.velocity, etc.</p>
		 *	
		 *	<p>If acceleration or friction controllers are used, the velocity controller will be disabled as acceleration and friction influence the target's velocity.</p>
		 *		
		 *	@param	target	 The target object to set for all child MotionControllers
		 *	@param	property	The single property to have physics applied to
		 *	@param	duration	 The length of time to set all child controllers
		 *	@param	physics	 The BasicPhysics object to use. If there is no existing one, set to null and an internal one will be created.
		 *	@param	containerClass	 The class of keyframe container to use for all MotionControllers
		 *	@param	tweenClass	 The class of tweens to pass to all the keyframe container
		 */
		public function PhysicsMultiController($target:Object, $property:String = null, $duration:Number = 0, $physics:BasicPhysics = null, $containerClass:Class = null, $tweenClass:Class = null) {
			super(null, $duration);
			if($physics == null){
				_physics = new BasicPhysics($target, {property:$property});
			} else {
				_physics = $physics;
				_physics.target = $target;
				_physics.config.property = $property;
			}
			this.velocity = new MotionController(_physics, 'velocity', $duration, $containerClass, $tweenClass);
			this.acceleration = new MotionController(_physics, 'acceleration', $duration, $containerClass, $tweenClass);
			this.friction = new MotionController(_physics, 'friction', $duration, $containerClass, $tweenClass);
			this.velocity.keyframes.precision = 1;
			this.acceleration.keyframes.precision = 2;
			this.friction.keyframes.precision = 2;
		}
		
		/**
		 *	The target for the physics to be applied to, since the internal controllers' target is the actual physics object.
		 */
		public override function get target():Object{
			return _physics.target;
		}

		public override function set target($value:Object):void {
			_physics.target = $value;
		}
		
		/**
		 *	This is the property of the target to apply the physics to. Unlike a regular MultiController, which uses each MotionController for each property.
		 */
		public function get property():String{
			return _physics.config.property;
		}
		
		/**
		 *	@private
		 */
		public function set property($value:String):void {
			_physics.config.property = $value;
		}
		
		/**
	     *  The BasicPhysics object used to handle physics on a property.
	     *  
	     *  @see com.desuade.motion.physics.BasicPhysics
	     */
	    public function get physics():BasicPhysics{
	      return _physics;
	    }
	
		/**
		 *	@inheritDoc
		 */
		public override function start($keyframe:String = 'begin', $startTime:Number = 0, $rebuild:Boolean = false):* {
			startPhysicsControllers($keyframe, $startTime, $rebuild);
		}
		
		/**
	     *  @private
	     */
	    protected function startPhysicsControllers($keyframe:String, $startTime:Number = 0, $rebuild:Boolean = false):void {
		  //$keyframe = (keyframes[$keyframe] == undefined) ? 'begin' : $keyframe;			
			if(this.velocity.keyframes.isFlat()){
				this.velocity.setStartValue($keyframe);
				if(this.acceleration.keyframes.isFlat()) this.acceleration.setStartValue($keyframe);
				else this.acceleration.start($keyframe, $startTime, $rebuild);
				if(this.friction.keyframes.isFlat()) this.friction.setStartValue($keyframe);
				else this.friction.start($keyframe, $startTime, $rebuild);
			} else {
				this.acceleration.setStartValue($keyframe);
				this.friction.setStartValue($keyframe);
				this.velocity.start($keyframe, $startTime, $rebuild);
			}
		}
	
	}

}
