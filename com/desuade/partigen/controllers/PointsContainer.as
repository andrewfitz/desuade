package com.desuade.partigen.controllers {

	public class PointsContainer extends Object {
	
		private var _pointcount:Number = 0;
		public var beginning:Object;
		public var end:Object;
	
		public function PointsContainer(){
			super();
		}
		
		public function addPoint(value:Number, spread:Number, position:Number, ease:*, label:String):Object {
			label = (label == 'point') ? 'point' + _pointcount : label;
			this[label] = {value:value, spread:spread, position:position, ease:ease};
		}
		
		public function removePoint(label:String):void {
			if(label != 'beginning' && label != 'end') delete this[label];
		}
	
	}

}

