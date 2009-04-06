package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.motion.physics.*

	public class PhysicsValueController extends Object {
		
		protected var _physics:BasicPhysics;
		
		public var velocity:ValueController;
		public var acceleration:ValueController;
		public var friction:ValueController;
	
		public function PhysicsValueController($target:Object, $prop:String, $duration:Number, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			_physics = new BasicPhysics($target, $prop, $velocity, $acceleration, $friction, $angle, $flip);
			velocity = new ValueController(_physics, 'velocity', $duration, 2);
			acceleration = new ValueController(_physics, 'acceleration', $duration, 3);
			friction = new ValueController(_physics, 'friction', $duration, 2);
		};
		
		public function get physics():BasicPhysics{
			return _physics;
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
	
	}

}
