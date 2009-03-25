package com.desuade.partigen {

	import com.desuade.debugging.*

	public class DebugCodesPartigen extends CodeSet {
		
		public function DebugCodesPartigen() {
			super();
			
			setname = 'partigen';
			codes = {
				10000: "Partigen debug codes for aiding in development.",
				10001: "Test code for $ and $",
				
				//particle events
				50001: "[Particle] a new particle was born (id:$)",
				50002: "[Particle] a particle died (id:$)"
			}
			
		}
	
	}

}
