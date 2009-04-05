package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.debugging.*;

	public class NullPool extends Pool {
	
		public function NullPool() {
			super();
		}
		
		public override function addParticle($particleClass:Class, $emitter:Emitter):Particle {
			super.addParticle($particleClass, $emitter);
			if($emitter.groupAmount > 1){
				return _particles[Particle.count] = new GroupParticle($particleClass, $emitter.groupAmount, $emitter.groupProximity);
			} else {
				return _particles[Particle.count] = new $particleClass();
			}
		}
		
		public override function removeParticle($particleID:int):void {
			delete _particles[$particleID];
			super.removeParticle($particleID);
		}
	
	}

}
