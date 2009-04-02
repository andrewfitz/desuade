package com.desuade.partigen.particles {
	
	import com.desuade.utils.*;
	import com.desuade.partigen.particles.*;

	public dynamic class GroupParticle extends Particle {
		
		public var particles:Object = {};
	
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
