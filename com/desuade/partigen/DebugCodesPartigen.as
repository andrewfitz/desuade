package com.desuade.partigen {

	import com.desuade.debugging.*

	public class DebugCodesPartigen extends CodeSet {
		
		public function DebugCodesPartigen() {
			super();
			
			setname = 'partigen';
			codes = {
				10000: "Partigen debug codes for aiding in development.",
				10001: "Test code for $ and $",
				
				//
				20001: "[Emitter] new emitter created",
				20002: "[Renderer] new renderer created",
				
				//
				40001: "[Emitter] running update on emitter: $ at: $",
				40002: "[Renderer] particle (id:$) was added to the renderer",
				
				
				//particle events
				50001: "[Particle] a new particle was born (id:$)",
				50002: "[Particle] a particle died (id:$)"
			}
			
		}
	
	}

}
