package com.desuade.motion.tweens {
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BasicColorTween extends BasicTween {
		
		protected var _colorholder:Object;
	
		public function BasicColorTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		protected override function createTween($to:Object):int {
			_colorholder = $to.target.transform.colorTransform;
			var cpo:Object = ColorHelper.getColorObject($to.type || 'tint', $to.amount || 1, $to.value, _colorholder);
			var pt:PrimitiveMultiTween = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween(_colorholder, cpo, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
			pt.addEventListener(TweenEvent.UPDATED, colorupdater, false, 0, true);
			return pt.id;
		}
		
		protected function colorupdater($o:Object):void {
			_tweenconfig.target.transform.colorTransform = new ColorTransform(_colorholder.redMultiplier, _colorholder.greenMultiplier, _colorholder.blueMultiplier, _tweenconfig.target.alpha, _colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
	
	}

}
