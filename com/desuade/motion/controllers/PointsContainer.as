package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*

	public dynamic class PointsContainer extends BasePointsContainer {
	
		public function PointsContainer($value:* = '0'){
			super();
			this.begin = {value:$value, spread:'0', position:0};
			this.end = {value:$value, spread:'0', position:1, ease:BasePointsContainer.linear};
		}
		
		public function add($value:*, $spread:*, $position:Number, $ease:* = null, $label:String = null):Object {
			$label = ($label == null) ? 'point' + ++_pointcount : $label;
			Debug.output('motion', 10001, [$label, $position]);
			return this[$label] = {value:$value, spread:$spread, position:$position, ease: $ease || BasePointsContainer.linear};
		}
		
		public function toArray():Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, label:p});
			}
			return pa;
		}
		
		public function flatten($value:*):void {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = BasePointsContainer.linear;
				p.value = $value;
				p.spread = '0';
			}
			delete this.begin.ease;
		}
		
		public function isFlat():Boolean {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				if(pa[i].value != this.begin.value && pa[i].value != null) return false;
			}
			return true;
		}
		
		public function clone():PointsContainer {
			var npc:PointsContainer = new PointsContainer();
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 1; i < sa.length-1; i++) {
				var p:Object = this[sa[i]];
				npc.add(p.value, p.spread, p.position, p.ease, sa[i]);
			}
			npc.begin = {value:this.begin.value, spread:this.begin.spread, position:0};
			npc.end = {value:this.end.value, spread:this.end.spread, position:1, ease:this.end.ease};
			return npc;
		}
				
	}

}
