package com.desuade.motion.controllers {

	import com.desuade.debugging.*
	import com.desuade.motion.tweens.*
	import com.desuade.motion.eases.*
	import com.desuade.utils.*
	
	import flash.geom.ColorTransform;
	
	public dynamic class ColorKeyframeContainer extends KeyframeContainer {
	
		public function ColorKeyframeContainer() {
			super();
			this['begin'].extras = {type:null, amount:null};
			this['end'].extras = {type:null, amount:null};
			_tweenclass = BasicColorTween;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function generateStartValue($target:Object, $property:String):* {
			var nv:*;
			var nt:String = this['begin'].extras.type;
			if(this['begin'].value != null && this['begin'].value != 'none'){
				nv = (this['begin'].spread != '0') ? RandomColor.fromRange(this['begin'].value, this['begin'].spread) : this['begin'].value;	
			} else nt = 'clear';
			return ColorHelper.getColorObject(nt || 'tint', this['begin'].extras.amount || 1, nv, ($property == null) ? $target.transform.colorTransform : null);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function setStartValue($target:Object, $property:String):void {
			var nvo:Object = generateStartValue($target, $property);
			if($property == null){
				$target.transform.colorTransform = new ColorTransform(nvo.redMultiplier, nvo.greenMultiplier, nvo.blueMultiplier, $target.alpha, nvo.redOffset, nvo.greenOffset, nvo.blueOffset);
				trace($target.transform.colorTransform.color);
			} else {
				$target[$property] = ColorHelper.RGBToHex(nvo.redOffset, nvo.greenOffset, nvo.blueOffset);
			}
		}
		
		/**
		 *	Creates a new copy of the ColorKeyframeContainer, identical to the current one.
		 *	
		 *	@return		A new ColorKeyframeContainer that has the same keyframes as the current one.
		 */
		public override function clone():KeyframeContainer {
			var npc:ColorKeyframeContainer = new ColorKeyframeContainer();
			npc.precision = _precision;
			npc.tweenclass = _tweenclass;
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 1; i < sa.length-1; i++) {
				var p:Object = this[sa[i]];
				npc.add(new Keyframe(p.position, p.value, p.ease, p.spread, p.extras), sa[i]);
			}
			npc.begin.value = this['begin'].value;
			npc.begin.spread = this['begin'].spread;
			npc.begin.extras = this['begin'].extras;
			npc.end.value = this['end'].value;
			npc.end.spread = this['end'].spread;
			npc.end.ease = this['end'].ease;
			npc.end.extras = this['end'].extras;
			return npc;
		}
		
		/**
		 *	@private
		 */
		internal override function createTweens($target:Object, $property:String, $duration:Number):Array {
			var pa:Array = getOrderedLabels();
			var ta:Array = [];
			//skip begin point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = this[pa[i]];
				var nv:*;
				if(np.value == 'none' && np.extras.type == 'tint'){
					np.extras.type = 'clear';
				} else {
					var nuv:*;
					if(np.value == null){
						if($property == null){
							var tc:* = $target.transform.colorTransform.color;
							if(tc == 0){
								nuv = null;
								np.extras.type = 'clear';
							} else {
								nuv = tc;
							}
						} else {
							nuv = $target[$property];
						}
					} else nuv = np.value;
					nv = (np.spread != '0') ? RandomColor.fromRange(nuv, np.spread) : nuv;
				}
				var tmo:Object = {target:$target, property:$property, value:nv, ease:np.ease, duration:calculateDuration($duration, this[pa[i-1]].position, np.position), delay:0};
				for (var h:String in np.extras) {
					tmo[h] = np.extras[h];
				}
				ta.push(tmo);
			}
			return ta;
		}
		
	}

}