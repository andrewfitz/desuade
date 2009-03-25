package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*

	internal dynamic class PointsContainer extends Object {
	
		protected var _pointcount:Number = 0;
	
		public function PointsContainer($value:Number = 0){
			super();
			this.beginning = {value:$value, position:0};
			this.end = {value:$value, position:1, ease:linear};
		}
		
		public function addPoint($value:*, $position:Number, $ease:*, $label:String):Object {
			$label = ($label == 'point') ? 'point' + ++_pointcount : $label;
			Debug.output('motion', 10001, [$label, $position]);
			return this[$label] = {value:$value, position:$position, ease:$ease};
		}
		
		public function removePoint($label:String):void {
			if($label != 'beginning' && $label != 'end') delete this[$label];
		}
		
		public function getSortedPoints():Array {
			var pa:Array = [];
			var sa:Array = [];
			for (var p:String in this) {
				pa.push({label:p, position:this[p]['position']});
			}
			pa.sort(sortOnPosition);
			for (var i:int = 0; i < pa.length; i++) {
				sa.push(pa[i].label);
			}
			return sa;
		}
		
		public function flatten($value:*):void {
			var pa:Array = this.getSortedPoints();
			for (var i:int = 1; i < pa.length-1; i++) {
				var p:Object = this[pa[i]];
				p.ease = linear;
				p.value = $value;
			}
			this.beginning.value = $value;
			this.end.value = $value;
			this.end.ease = linear;
		}
		
		//private static methods
		protected static function sortOnPosition(a:Object, b:Object):Number {
		    var aPos:Number = a['position'];
		    var bPos:Number = b['position'];
		    if(aPos > bPos) {
		        return 1;
		    } else if(aPos < bPos) {
		        return -1;
		    } else {
		        return 0;
		    }
		}
		
		internal static function linear(t:Number, b:Number, c:Number, d:Number, ... args):Number {
			return c*t/d+b;
		}
		
	}

}

