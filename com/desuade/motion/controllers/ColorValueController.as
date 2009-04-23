package com.desuade.motion.controllers {
	
	import com.desuade.utils.*
	import com.desuade.motion.tweens.*
	
	import flash.geom.ColorTransform;
	
	/**
	 *  This is a special version of a ValueController that is used to work with colors. See the ValueController documentation for more information on working with controllers.
	 *	
	 *	Note: 'prop' and 'precision' properties are irrelevant and do nothing. Also be aware of differences in color-based points.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  22.04.2009
	 */
	public class ColorValueController extends ValueController {
		
		/**
		 *	Creates a new ColorValueController. Note the difference in parameters compared to a standard ValueController.
		 *	
		 *	@param	target	 The target object that will have it's color controlled.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens, since the position is dependent on the the duration.
		 */
		public function ColorValueController($target:Object, $duration:Number){
			super($target, null, $duration, 0, false);
			tweenclass = BasicColorTween;
			points = null;
			points = new ColorPointsContainer();
		}
		
		/**
		 *	@inheritDoc
		 */
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
		
		/**
		 *	@private
		 */
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
