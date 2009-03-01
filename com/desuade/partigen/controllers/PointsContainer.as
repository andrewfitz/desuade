package com.desuade.partigen.controllers {
	
	import com.desuade.partigen.debug.*

	public dynamic class PointsContainer extends Object {
	
		private var _pointcount:Number = 0;
	
		public function PointsContainer(value:Number = 0){
			super();
			this.beginning = {value:value, spread:0, position:0};
			this.end = {value:value, spread:0, position:1, ease:'linear'};
		}
		
		public function addPoint(value:Number, spread:Number, position:Number, ease:*, label:String):Object {
			label = (label == 'point') ? 'point' + _pointcount : label;
			Debug.output('develop', 1002, [label, position]);
			return this[label] = {value:value, spread:spread, position:position, ease:ease};
		}
		
		public function removePoint(label:String):void {
			if(label != 'beginning' && label != 'end') delete this[label];
		}
	
	}

}

