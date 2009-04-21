package com.desuade.motion.controllers {
	
	import com.desuade.utils.*
	import com.desuade.motion.tweens.*
	
	import flash.geom.ColorTransform;

	public class ColorValueController extends ValueController {
		
		public function ColorValueController($target:Object, $duration:Number){
			super($target, null, $duration, 0, false);
			tweenclass = BasicColorTween;
			points = null;
			points = new ColorPointsContainer();
		}
		
		public override function setStartValue():Number {
			var nv:*;
			var nt:String = points.begin.type;
			if(points.begin.value != null && points.begin.value != 'none'){
				nv = (points.begin.spread != null) ? RandomColor.fromRange(points.begin.value, points.begin.spread) : points.begin.value;	
			} else nt = 'reset';
			var nvo:Object = ColorHelper.getColorObject(nt, points.begin.amount, nv, target.transform.colorTransform);
			target.transform.colorTransform = new ColorTransform(nvo.redMultiplier, nvo.greenMultiplier, nvo.blueMultiplier, target.alpha, nvo.redOffset, nvo.greenOffset, nvo.blueOffset);
			return target.transform.colorTransform.color;
		}
		
		protected override function createTweens():Array {
			var pa:Array = points.getOrderedLabels();
			var ta:Array = [];
			//skip begin point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = points[pa[i]];
				var nv:*;
				if(np.value == 'none' && np.type == 'tint'){
					np.type = 'reset';
				} else {
					var nuv:*;
					if(np.value == null){
						nuv = target.transform.colorTransform.color;
					} else {
						nuv = np.value;
					}
					nv = (np.spread != null) ? RandomColor.fromRange(nuv, np.spread) : nuv;
				}
				var tmo:Object = {target:target, value:nv, type:np.type, amount:np.amount, ease:np.ease, duration:calculateDuration(points[pa[i-1]].position, np.position), delay:0};
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}
