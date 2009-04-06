package com.desuade.partigen.controllers {

	public class ParticlePhysicsController extends Object {
		
		protected var _velocity:ParticleValueController;
		protected var _acceleration:ParticleValueController;
		protected var _friction:ParticleValueController;
		protected var _duration:Number;
		
		public var angle:*;
		public var flip:Boolean;
	
		public function ParticlePhysicsController($duration:Number, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			_velocity = new ParticleValueController($duration, 2, $velocity);
			_acceleration = new ParticleValueController($duration, 3, $acceleration);
			_friction = new ParticleValueController($duration, 2, $friction);
			_duration = $duration;
			angle = $angle;
			flip = $flip;
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
		
		public function get velocity():ParticleValueController{
			return _velocity;
		}
		
		public function get acceleration():ParticleValueController{
			return _acceleration;
		}
		
		public function get friction():ParticleValueController{
			return _friction;
		}
		
		////shorcuts
		
		public function get v():ParticleValueController{
			return velocity;
		}
		public function get a():ParticleValueController{
			return acceleration;
		}
		public function get f():ParticleValueController{
			return friction;
		}
		
	}

}
