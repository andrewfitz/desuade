package com.desuade.partigen.controllers {

	public class ValueController extends Object {
	
		public var points:PointsContainer;
		public var target:Object;
		public var property:String;
		public var duration:Number;
	
		public function ValueController(target:Object, property:String, duration:Number){
			super();
			this.target = target;
			this.property = property;
			this.duration = duration;
			points = new PointContainer();
		}
		
		public function addPoint(value:Number, spread:Number, position:Number, ease:* = 'linear', label:String = 'point'):Object {
			return points.addPoint(value, spread, position, ease, label);
		}
	
	}

}

