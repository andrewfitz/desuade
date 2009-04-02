package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*

	public class ParticleValueController extends Object {
		
		public var points:PointsContainer;
		public var duration:Number;
		public var precision:int;
	
		public function ParticleValueController($duration:Number, $precision:int) {
			super();
			duration = $duration;
			precision = $precision;
			points = new PointsContainer();
		}
		
		public function getPoints():Array {
			return points.getSortedPoints();
		}
	
	}

}
