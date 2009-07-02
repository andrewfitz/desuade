package com.desuade.partigen.controllers {

	public class ParticlePhysicsController extends Object {
		
		/**
		 *	The boolean flip (for cartesian reversal) value to be passed to the internal 'physics' object.
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public var flip:Boolean;
		
		protected var _duration:Number;
			
		public function ParticlePhysicsController($duration:Number, $containerclass:Class = null, $tweenclass:Class = null) {
			super();
			_duration = $duration;
			this.velocity = new ParticleTweenController($duration, $containerclass || KeyframeContainer, $tweenclass || Partigen.physicsClass);
			this.acceleration = new ParticleTweenController($duration, $containerclass || KeyframeContainer, $tweenclass || Partigen.physicsClass);
			this.friction = new ParticleTweenController($duration, $containerclass || KeyframeContainer, $tweenclass || Partigen.physicsClass);
			this.velocity.keyframes.precision = 3;
			this.acceleration.keyframes.precision = 3;
			this.friction.keyframes.precision = 3;
		}
		
		public function get duration():Number{
			return _duration;
		}
		
		public function set duration($value:Number):void {
			_duration = $value;
			for (var p:String in this) {
				this[p].duration = $value;
			}
		}
	
	}

}
