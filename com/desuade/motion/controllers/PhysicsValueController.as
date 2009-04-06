package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.motion.physics.*

	public class PhysicsValueController extends Object {
		
		protected var _physics:BasicPhysics;
		
		protected var _duration:Number;
		protected var _velocity:ValueController;
		protected var _acceleration:ValueController;
		protected var _friction:ValueController;
	
		public function PhysicsValueController($target:Object, $prop:String, $duration:Number, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			_physics = new BasicPhysics($target, $prop, $velocity, $acceleration, $friction, $angle, $flip);
			_velocity = new ValueController(_physics, 'velocity', $duration, 2);
			_acceleration = new ValueController(_physics, 'acceleration', $duration, 3);
			_friction = new ValueController(_physics, 'friction', $duration, 2);
			_duration = $duration;
		};
		
		public function get physics():BasicPhysics{
			return _physics;
		}
		
		public function get velocity():ValueController{
			return _velocity;
		}
		
		public function get acceleration():ValueController{
			return _acceleration;
		}
		
		public function get friction():ValueController{
			return _friction;
		}
		
		public function get duration():Number{
			return _duration;
		}
		
		public function set duration($duration:Number):void {
			_velocity.duration = $duration;
			_acceleration.duration = $duration;
			_friction.duration = $duration;
			_duration = $duration;
		}
		
		public function start():void {
			physics.enable();
			startControllers();
		}
		
		public function stop():void {
			physics.disable();
			stopControllers();
		}
		
		public function startControllers():void {
			velocity.start();
			acceleration.start();
			friction.start();
		}
		
		public function stopControllers():void {
			velocity.stop();
			acceleration.stop();
			friction.stop();
		}
		
		////shorcuts
		
		public function get v():ValueController{
			return velocity;
		}
		public function get a():ValueController{
			return acceleration;
		}
		public function get f():ValueController{
			return friction;
		}
	
	}

}
