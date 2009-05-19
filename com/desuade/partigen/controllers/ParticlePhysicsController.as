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

	/**
	 *  This uses simple physics to control any particle's property over it's life.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  05.05.2009
	 */
	public class ParticlePhysicsController extends Object {
		
		/**
		 *	@private
		 */
		protected var _velocity:ParticleValueController;
		
		/**
		 *	@private
		 */
		protected var _acceleration:ParticleValueController;
		
		/**
		 *	@private
		 */
		protected var _friction:ParticleValueController;
		
		/**
		 *	@private
		 */
		protected var _duration:Number;
		
		/**
		 *	<p>The angle the BasicPhysics object will use to calculate initial velocity. Mostly used with position properties, such as x, y, z.</p>
		 *	<p>Note: the angle should be set from emitter.angle, not directly from this.</p>
		 *	@see com.desuade.motion.physics.BasicPhysics#angle
		 */
		public var angle:*;
		
		/**
		 *	The boolean flip (for cartesian reversal) value to be passed to the internal 'physics' object.
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public var flip:Boolean;
		
		/**
		 *	<p>Creates a new PhysicsValueController for the corresponding property to be used for each particle. This controls the value of all 3 physics properties for a single particle property.</p>
		 *	<p>This uses physics instead of tweens to change a particle's property, including those that aren't positional (x,y).</p>
		 *	<p>See the BasicPhysics documentation for more information on what each property does.</p>
		 *	
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens of the internal ValueControllers, since the position is dependent on the the duration. Set to <code>0</code> for the duration to be set to the particle's life (recommended).
		 *	@param	velocity	 The start velocity for the particle's property. This is affected by all the other properties.
		 *	@param	acceleration	 The start acceleration for the property.
		 *	@param	friction	 The start friction for the property.
		 *	@param	angle	 The angle the BasicPhysics object will use to calculate initial velocity. Mostly used with position properties, such as x, y, z. This gets assigned by the emitter, so leave this null.
		 *	@param	flip	 The boolean flip (for cartesian reversal) for properties such as y. 
		 *	
		 *	@see com.desuade.motion.controllers.ValueController
		 *	@see com.desuade.motion.controllers.PointsContainer
		 *	@see com.desuade.motion.physics.BasicPhysics#velocity
		 *	@see com.desuade.motion.physics.BasicPhysics#acceleration
		 *	@see com.desuade.motion.physics.BasicPhysics#friction
		 *	@see com.desuade.motion.physics.BasicPhysics#angle
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public function ParticlePhysicsController($duration:Number, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			_velocity = new ParticleValueController($duration, 2, $velocity);
			_acceleration = new ParticleValueController($duration, 3, $acceleration);
			_friction = new ParticleValueController($duration, 2, $friction);
			_duration = $duration;
			angle = $angle;
			flip = $flip;
		}
		
		/**
		 *	<p>Sets/gets the duration of all 3 controllers. This assumes all controllers are set at the same duration. Setting this to <code>0</code> will use the particle's life as the duration.</p>
		 *	<p>If the duration is changed independently, reading this value may be inaccurate, so get the individual ValueController.duration.</p>
		 */
		public function get duration():Number{
			return _duration;
		}
		
		/**
		 *	@private
		 */
		public function set duration($duration:Number):void {
			_velocity.duration = $duration;
			_acceleration.duration = $duration;
			_friction.duration = $duration;
			_duration = $duration;
		}
		
		/**
		 *	The velocity ValueController.
		 *	Shortcut: "v" - (PhysicsValueController.velocity == PhysicsValueController.v)
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics#velocity
		 *	@see com.desuade.motion.controllers.ValueController
		 */
		public function get velocity():ParticleValueController{
			return _velocity;
		}
		
		/**
		 *	The acceleration ValueController.
		 *	Shortcut: "a" - (PhysicsValueController.acceleration == PhysicsValueController.a)
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics#acceleration
		 *	@see com.desuade.motion.controllers.ValueController
		 */
		public function get acceleration():ParticleValueController{
			return _acceleration;
		}
		
		/**
		 *	The friction ValueController.
		 *	Shortcut: "f" - (PhysicsValueController.friction == PhysicsValueController.f)
		 *	
		 *	@see com.desuade.motion.physics.BasicPhysics#friction
		 *	@see com.desuade.motion.controllers.ValueController
		 */
		public function get friction():ParticleValueController{
			return _friction;
		}
		
		/**
		 *	@private
		 */
		public function get v():ParticleValueController{
			return velocity;
		}
		
		/**
		 *	@private
		 */
		public function get a():ParticleValueController{
			return acceleration;
		}
		
		/**
		 *	@private
		 */
		public function get f():ParticleValueController{
			return friction;
		}
		
	}

}
