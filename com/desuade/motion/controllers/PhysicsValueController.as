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
	import com.desuade.motion.controllers.*
	import com.desuade.motion.physics.*

	/**
	 *  <p>This controls the physics propeties of a given target object's property.</p>
	 *	
	 *	<p>The PhysicsValueController is slightly different from the ValueController and the ColorValueController, as it isn't in itself a ValueController. It is actually a controller of controllers, that it has 3 ValueControllers it contains: velocity, acceleration, and friction.</p>
	 *	
	 *	<p>It creates it's own BasicPhysics object and the 3 ValueControllers upon creation, and provides methods to work with all controllers simultaneously.</p>
	 *	
	 *	<p>Note: if acceleration and/or friction controllers are used, they override the velocity controller as those directly affect the velocity.</p>
	 *	
	 *	<p>Note: while the controller must have a duration to use ValueControllers, once the controller is stopped, the velocity, acceleration, and friction values will stop being tweened, and the physics will be stopd. To keep the property being updated under the control of the 'physics' object (BasicPhysics), pass <code>false</code> to the stop() method.</p>
	 *	
	 *	<p>Note: physics used with the Desuade Motion Package is a variation of "tweening" used to change a value using physics formulas instead of standard motion tweening.</p>
	 *	
	 *	<p>For more information on how physics works within the DMP, view the documentation on the motion.physics.BasicPhysics class.</p>
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  22.04.2009
	 */
	public class PhysicsValueController extends Object {
		
		/**
		 *	@private
		 */
		protected var _physics:BasicPhysics;
		
		/**
		 *	@private
		 */
		protected var _duration:Number;
		
		/**
		 *	@private
		 */
		protected var _velocity:ValueController;
		
		/**
		 *	@private
		 */
		protected var _acceleration:ValueController;
		
		/**
		 *	@private
		 */
		protected var _friction:ValueController;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	Creates a new PhysicsValueController. See the BasicPhysics documentation for more information on what each property does.
		 *	
		 *	@param	target	 The target object that will have it's property controlled with physics.
		 *	@param	property	 The property to have it's value controlled by BasicPhysics.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens of the internal ValueControllers, since the position is dependent on the the duration.
		 *	@param	velocity	 The start velocity to be passed to the internal 'physics' object (BasicPhysics).
		 *	@param	acceleration	 The start acceleration to be passed to the internal 'physics' object.
		 *	@param	friction	 The start friction to be passed to the internal 'physics' object.
		 *	@param	angle	 The angle to be passed to the internal 'physics' object.
		 *	@param	flip	 The boolean flip (for cartesian reversal) value to be passed to the internal 'physics' object.
		 *	@see com.desuade.motion.physics.BasicPhysics#velocity
		 *	@see com.desuade.motion.physics.BasicPhysics#acceleration
		 *	@see com.desuade.motion.physics.BasicPhysics#friction
		 *	@see com.desuade.motion.physics.BasicPhysics#angle
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public function PhysicsValueController($target:Object, $property:String, $duration:Number, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			_physics = new BasicPhysics($target, $property, $velocity, $acceleration, $friction, $angle, $flip);
			_velocity = new ValueController(_physics, 'velocity', $duration, 2);
			_acceleration = new ValueController(_physics, 'acceleration', $duration, 3);
			_friction = new ValueController(_physics, 'friction', $duration, 2);
			_duration = $duration;
		};
		
		/**
		 *	True if any of the 3 ValueControllers are active.
		 */
		public function get active():Boolean{
			if(_velocity.active) return true;
			if(_acceleration.active) return true;
			if(_friction.active) return true;
			return false;
		}
		
		/**
		 *	The BasicPhysics object used to handle physics on a property.
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics
		 */
		public function get physics():BasicPhysics{
			return _physics;
		}
		
		/**
		 *	The velocity ValueController.
		 *	Shortcut: "v" - (PhysicsValueController.velocity == PhysicsValueController.v)
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics#velocity
		 *	@see ValueController
		 */
		public function get velocity():ValueController{
			return _velocity;
		}
		
		/**
		 *	The acceleration ValueController.
		 *	Shortcut: "a" - (PhysicsValueController.acceleration == PhysicsValueController.a)
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics#acceleration
		 *	@see ValueController
		 */
		public function get acceleration():ValueController{
			return _acceleration;
		}
		
		/**
		 *	The friction ValueController.
		 *	Shortcut: "f" - (PhysicsValueController.friction == PhysicsValueController.f)
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics#friction
		 *	@see ValueController
		 */
		public function get friction():ValueController{
			return _friction;
		}
		
		/**
		 *	Sets/gets the duration of all 3 controllers. This assumes all controllers are set at the same duration.
		 *	If the duration is changed independently, reading this value may be inaccurate, so get the individual ValueController.duration.
		 */
		public function get duration():Number{
			return _duration;
		}
		
		public function set duration($duration:Number):void {
			_velocity.duration = $duration;
			_acceleration.duration = $duration;
			_friction.duration = $duration;
			_duration = $duration;
		}
		
		/**
		 *	Starts up the PhysicsValueController.
		 *	
		 *	Starts all 3 controllers, and by default, starts the physics.
		 *	
		 *	@param	start	 Start the physics.
		 *	@see com.desuade.motion.physics.BasicPhysics#start()
		 */
		public function start($start:Boolean = true):void {
			startControllers();
			if($start) physics.start();
		}
		
		/**
		 *	Stops the PhysicsValueController.
		 *	
		 *	Stops all 3 controllers, and by default, stops the physics.
		 *	
		 *	@param	stop	 Disable the physics.
		 *	@see com.desuade.motion.physics.BasicPhysics#stop()
		 */
		public function stop($stop:Boolean = true):void {
			stopControllers();
			if($stop) physics.stop();
		}
		
		/**
		 *	@private
		 */
		protected function startControllers():void {
			if(velocity.points.isFlat()){
				velocity.setStartValue();
				if(acceleration.points.isFlat()) acceleration.setStartValue();
				else acceleration.start();
				if(friction.points.isFlat()) friction.setStartValue();
				else friction.start();
			} else {
				acceleration.setStartValue();
				friction.setStartValue();
				velocity.start();
			}
		}
		
		/**
		 *	@private
		 */
		protected function stopControllers():void {
			velocity.stop();
			acceleration.stop();
			friction.stop();
		}
		
		////shorcuts
		
		/**
		 *	@private
		 */
		public function get v():ValueController{
			return velocity;
		}
		
		/**
		 *	@private
		 */
		public function get a():ValueController{
			return acceleration;
		}
		
		/**
		 *	@private
		 */
		public function get f():ValueController{
			return friction;
		}
	
	}

}
