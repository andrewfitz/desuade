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
	
	import com.desuade.motion.physics.*;

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
		
		public function PhysicsMultiController($target:Object, $property:String, $duration:Number, $physics:BasicPhysics = null, $containerclass:Class = null, $tweenclass:Class = null) {
			super(null, [], $duration);
			if($physics == null){
				_physics = new BasicPhysics({target:$target, property:$property});
			} else {
				_physics = $physics;
				_physics.target = $target;
				_physics.property = $property;
			}
			this.velocity = new MotionController(_physics, 'velocity', $duration, $containerclass, $tweenclass);
			this.acceleration = new MotionController(_physics, 'acceleration', $duration, $containerclass, $tweenclass);
			this.friction = new MotionController(_physics, 'friction', $duration, $containerclass, $tweenclass);
			this.velocity.keyframes.precision = 3;
			this.acceleration.keyframes.precision = 3;
			this.friction.keyframes.precision = 3;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function get target():Object{
			return _physics.target;
		}

		public override function set target($value:Object):void {
			_physics.target = $value;
		}
		
		public function get property():String{
			return _physics.property;
		}
		
		public function set property($value:String):void {
			_physics.property = $value;
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
		public override function start($keyframe:String = null):void {
			startPhysicsControllers($keyframe);
		}
		
		/**
	     *  @private
	     */
	    protected function startPhysicsControllers($keyframe:String = null):void {
	      if(this.velocity.keyframes.isFlat()){
	        this.velocity.keyframes.setStartValue(target, property);
	        if(this.acceleration.keyframes.isFlat()) this.acceleration.keyframes.setStartValue(target, property);
	        else this.acceleration.start($keyframe);
	        if(this.friction.keyframes.isFlat()) this.friction.keyframes.setStartValue(target, property);
	        else this.friction.start($keyframe);
	      } else {
	        this.acceleration.keyframes.setStartValue(target, property);
	        this.friction.keyframes.setStartValue(target, property);
	        this.velocity.start($keyframe);
	      }
	    }
	
	}

}
