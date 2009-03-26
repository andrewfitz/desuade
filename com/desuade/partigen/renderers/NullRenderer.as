package com.desuade.partigen.renderers {

	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;

	public class NullRenderer extends Renderer {
	
		public function NullRenderer() {
			super();
		}
		
		public override function addParticle($p:Particle):void {
			super.addParticle($p);
		}
		
		public override function removeParticle($p:Particle):void {
			super.removeParticle($p);
		}
	
	}

}
