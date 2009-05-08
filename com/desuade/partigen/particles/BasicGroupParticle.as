package com.desuade.partigen.particles {
	
	import com.desuade.utils.*;

	/**
	 *  This is the basic ParticleGroup used with BasicParticles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public dynamic class BasicGroupParticle extends BasicParticle {
		
		/**
		 *	This holds the particles inside of the group.
		 */
		public var particles:Object = {};
	
		/**
		 *	This creates a new particle group for the BasicParticle class. This is handled internally and should not be called manually.
		 *	
		 *	@param	particle	 The particle class to use for new particles.
		 *	@param	amount	 The amount of particles to create inside the group.
		 *	@param	proximity	 This determines the maximum distance away from the center of the group to create new particles.
		 */
		public function BasicGroupParticle($particle:Class, $amount:int, $proximity:int) {
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
