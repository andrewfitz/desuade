package com.desuade.partigen.controllers {

	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;

	public dynamic class ParticleController extends Object {
	
		public function ParticleController() {
			super();
		}
		
		public function addTween($property:String, $duration:Number = 0):void {
			this[$property] = new ParticleTweenController($duration, KeyframeContainer, Partigen.tweenClass);
		}
		
		public function addColorTween($duration:Number = 0):void {
			this['color'] = new ParticleTweenController($duration, ColorKeyframeContainer, Partigen.colorTweenClass);
		}
		
		public function addPhysics($property:String, $duration:Number = 0, $flip:Boolean = false):void {
			this[$property] = new ParticleTweenController($duration, KeyframeContainer, Partigen.physicsClass);
			this[$property].flip = $flip;
		}
		
		//privates
		
		/**
		 *	@private
		 */
		protected function attachController($particle:Particle, $property:String, $emitter:Emitter = null):void {
			if(this[$property] is ParticlePhysicsController){
				$particle.controllers[$property] = new PhysicsMultiController($property, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration);
				$particle.controllers[$property].physics.angle = $emitter.angle;
				$particle.controllers[$property].physics.flip = this[$property].flip;
				$particle.controllers[$property].velocity.keyframes = this[$property].velocity.keyframes;
				$particle.controllers[$property].acceleration.keyframes = this[$property].acceleration.keyframes;
				$particle.controllers[$property].friction.keyframes = this[$property].friction.keyframes;
			} else {
				$particle.controllers[$property] = new MotionController($particle, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration);
				$particle.controllers[$property].keyframes = this[$property].keyframes;
			}
		}
		
		/**
		 *	@private
		 */
		public function attachAll($particle:Particle, $emitter:Emitter = null):void {
			for (var p:String in this) {
				attachController($particle, p, $emitter);
			}
		}
			
	}

}
