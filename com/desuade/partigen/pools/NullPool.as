package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;

	public class NullPool extends Pool {
	
		public function NullPool() {
			super();
		}
		
		public override function addParticle($particleClass:Class):Particle {
			var p:Particle = _particles[Particle.count] = new $particleClass();
			Debug.output('partigen', 40003);
			return p;
		}
		
		public override function removeParticle($particle:Particle):void {
			delete _particles[$particle.id];
			Debug.output('partigen', 40005);
		}
	
	}

}

