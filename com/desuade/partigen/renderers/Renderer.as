package com.desuade.partigen.renderers {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;

	public class Renderer extends Object {
	
		public function Renderer() {
			super();
		}
		
		public function addParticle($p:Particle):void {
			Debug.output('partigen', 40002, [$p.id]);
		}
	
	}

}

