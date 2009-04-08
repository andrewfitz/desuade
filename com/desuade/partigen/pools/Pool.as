package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.debugging.*;

	public class Pool extends Object {
		
		protected var _particles:Object = {};
	
		public function Pool() {
			super();
			Debug.output('partigen', 20003);
		}
		
		public function get particles():Object{
			return _particles;
		}
		
		public function addParticle($particleClass:Class, $emitter:BasicEmitter):BasicParticle {
			Debug.output('partigen', 40003);
			return null;
		}
		
		public function removeParticle($particleID:int):void {
			Debug.output('partigen', 40005);
		}
	
	}

}
