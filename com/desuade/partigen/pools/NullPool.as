package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.debugging.*;

	public class NullPool extends Pool {
	
		public function NullPool() {
			super();
		}
		
		public override function addParticle($particleClass:Class, $groupClass:Class, $emitter:BasicEmitter):BasicParticle {
			super.addParticle($particleClass, $groupClass, $emitter);
			if($emitter.groupAmount > 1){
				return _particles[BasicParticle.count] = new $groupClass($particleClass, $emitter.groupAmount, $emitter.groupProximity);
			} else {
				return _particles[BasicParticle.count] = new $particleClass();
			}
		}
		
		public override function removeParticle($particleID:int):void {
			delete _particles[$particleID];
			super.removeParticle($particleID);
		}
	
	}

}
