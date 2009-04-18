package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*

	public dynamic class ColorPointsContainer extends BasePointsContainer {
	
		public function ColorPointsContainer($value:* = 'none', $type:String = 'tint', $amount:Number = 1) {
			super();
			this.begin = {value:$value, spread:null, type:$type, amount:$amount, position:0};
			this.end = {value:$value, spread:null, type:$type, amount:$amount, position:1, ease:BasePointsContainer.linear};
		}
		
		public function add($value:*, $spread:*, $position:Number, $type:String = 'tint', $amount:Number = 1, $ease:* = null, $label:String = null):Object {
			$label = ($label == null) ? 'point' + ++_pointcount : $label;
			Debug.output('motion', 10001, [$label, $position]);
			return this[$label] = {value:$value, spread:$spread, position:$position, type:$type, amount:$amount, ease: $ease || BasePointsContainer.linear};
		}
		
		public function toArray():Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, type:this[p].type, amount:this[p].amount, label:p});
			}
			return pa;
		}
		
		public function flatten($value:*, $type:String = 'tint', $amount:Number = 1):void {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = BasePointsContainer.linear;
				p.value = $value;
				p.type = $type;
				p.amount = $amount;
				p.spread = '0';
			}
			delete this.begin.ease;
		}
		
		public function isFlat():Boolean {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				if(pa[i].value != this.begin.value && pa[i].amount != this.begin.amount && pa[i].value != null) return false;
			}
			return true;
		}
		
		public function clone():ColorPointsContainer {
			var npc:ColorPointsContainer = new ColorPointsContainer();
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 1; i < sa.length-1; i++) {
				var p:Object = this[sa[i]];
				npc.add(p.value, p.spread, p.position, p.type, p.amount, p.ease, sa[i]);
			}
			npc.begin = {value:this.begin.value, spread:this.begin.spread, type:this.begin.type, amount:this.begin.amount, position:0};
			npc.end = {value:this.end.value, spread:this.end.spread, type:this.end.type, amount:this.end.amount, position:1, ease:this.end.ease};
			return npc;
		}
		
	}

}
