package com.desuade.partigen.controllers {

	public class PointsContainer extends Object {
	
		private var _pointcount:Number = 0;
		public var beginning:Object;
		public var end:Object;
	
		public function PointsContainer(value:Number = 0){
			super();
			beginning = {value:value, spread:0, position:0};
			end = {value:value, spread:0, position:1, ease:'linear'};
			//remove private vars from loops
			setPropertyIsEnumerable(_pointcount, false);
		}
		
		public function addPoint(value:Number, spread:Number, position:Number, ease:*, label:String):Object {
			label = (label == 'point') ? 'point' + _pointcount : label;
			return this[label] = {value:value, spread:spread, position:position, ease:ease};
		}
		
		public function removePoint(label:String):void {
			if(label != 'beginning' && label != 'end') delete this[label];
		}
	
	}

}

