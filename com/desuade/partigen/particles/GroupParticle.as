package com.desuade.partigen.particles {
	
	import com.desuade.utils.*;

	public dynamic class GroupParticle extends Particle {
		
		/**
		 *	This holds the particles inside of the group.
		 */
		public var particles:Object = {};
	
		/**
		 *	This creates a new particle group for the Particle class. This is handled internally and should not be called manually.
		 *	
		 *	@param	particle	 The particle class to use for new particles.
		 *	@param	amount	 The amount of particles to create inside the group.
		 *	@param	proximity	 This determines the maximum distance away from the center of the group to create new particles.
		 */
		public function GroupParticle($particle:Class, $amount:int, $proximity:int) {
			super();
			for (var i:int = 0; i < $amount; i++) {
				particles[i] = new $particle();
				particles[i].x = Random.fromRange(-$proximity, $proximity, 0);
				particles[i].y = Random.fromRange(-$proximity, $proximity, 0);
				this.addChild(particles[i]);
			}
		}
		
	}

}
