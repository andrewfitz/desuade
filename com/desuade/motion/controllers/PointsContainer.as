package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*

	public dynamic class PointsContainer extends Object {
	
		protected var _pointcount:Number = 0;
	
		public function PointsContainer($value:* = 0){
			super();
			this.begin = {value:$value, spread:0, position:0};
			this.end = {value:$value, spread:0, position:1, ease:linear};
		}
		
		public function add($value:*, $spread:Number, $position:Number, $ease:* = null, $label:String = null):Object {
			$label = ($label == null) ? 'point' + ++_pointcount : $label;
			Debug.output('motion', 10001, [$label, $position]);
			return this[$label] = {value:$value, spread:$spread, position:$position, ease: $ease || PointsContainer.linear};
		}
		
		public function remove($label:String):void {
			if($label != 'begin' && $label != 'end') delete this[$label];
		}
		
		public function toArray():Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, label:p});
			}
			return pa;
		}
		
		public function toSortedArray():Array {
			var pa:Array = this.toArray();
			var sa:Array = [];
			pa.sort(sortOnPosition);
			for (var i:int = 0; i < pa.length; i++) {
				sa.push(pa[i].label);
			}
			return sa;
		}
		
		public function flatten($value:*):void {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = linear;
				p.value = $value;
				p.spread = 0;
			}
			delete this.begin.ease;
		}
		
		public function isFlat():Boolean {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				//trace(pa[i].value + " -> " + this.begin.value);
				if(pa[i].value != this.begin.value) return false;
			}
			return true;
		}
		
		//private static methods
		protected static function sortOnPosition(a:Object, b:Object):Number {
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

