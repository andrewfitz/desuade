package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*

	public dynamic class BasePointsContainer extends Object {
	
		protected var _pointcount:Number = 0;
	
		public function BasePointsContainer($value:* = '0'){
			super();
		}
		
		public function remove($label:String):void {
			if($label != 'begin' && $label != 'end') delete this[$label];
		}
		
		public function getOrderedLabels():Array {
			var pa:Array = this.toArray();
			var sa:Array = [];
			pa.sort(sortOnPosition);
			for (var i:int = 0; i < pa.length; i++) {
				sa.push(pa[i].label);
			}
			return sa;
		}
		
		public function empty():Object {
			var no:Object = {};
			for (var p:String in this) {
				if(p != 'begin' && p != 'end'){
					no[p] = this[p];
					this[p] = null;
					delete this[p];
				}
			}
			return no;
		}
		
		//private static methods
		internal static function sortOnPosition(a:Object, b:Object):Number {
		    var aPos:Number = a.position;
		    var bPos:Number = b.position;
		    if(aPos > bPos) {
		        return 1;
		    } else if(aPos < bPos) {
		        return -1;
		    } else {
		        return 0;
		    }
		}
		
		public static function linear(t:Number, b:Number, c:Number, d:Number, ... args):Number {
			return c*t/d+b;
		}
		
	}

}
