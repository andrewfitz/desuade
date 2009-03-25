package com.desuade.partigen.renderers {

	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;

	public class NullRenderer extends Renderer {
	
		public function NullRenderer() {
			super();
			Debug.output('partigen', 20002);
		}
		
		public override function addParticle($p:Particle):void {
			super.addParticle($p);
		}
	
	}

}
