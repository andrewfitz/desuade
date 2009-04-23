package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*

	public class ParticleColorController extends Object {
		
		public var points:ColorPointsContainer;
		public var duration:Number;
		
		public function ParticleColorController($duration:Number) {
			super();
			duration = $duration;
			points = new ColorPointsContainer();
		}
	
	}

}
