package com.desuade.motion.tweens {
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ColorTween extends MultiTween {
		
		protected var _colorholder:Object;
	
		public function ColorTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		//Static tween function
		public static function tween($target:Object, $value:*, $duration:int, $ease:Function = null, $delay:Number = 0, $type:String = 'tint', $amount:Number = 1, $position:Number = 0):ColorTween {
			var st:ColorTween = new ColorTween({target:$target, value:$value, duration:$duration, ease:$ease, delay:$delay, type:$type, amount:$amount, position:$position});
			st.start();
			return st;
		}
		
		protected function colorupdater($o:Object):void {
			_tweenconfig.target.transform.colorTransform = new ColorTransform(_colorholder.redMultiplier, _colorholder.greenMultiplier, _colorholder.blueMultiplier, _tweenconfig.target.alpha, _colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
		
		protected override function createTween($to:Object):int {
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				var pt:PrimitiveMultiTween;
				_colorholder = $to.target.transform.colorTransform;
				var cpo:Object = ColorHelper.getColorObject($to.type || 'tint', $to.amount || 1, $to.value, _colorholder);
				if(_newvals.length == 0){
					for (var p:String in cpo) {
						_newvals.push(cpo[p]);
					}	
				}
				pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween(_colorholder, cpo, $to.duration*1000, $to.ease);
				pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
				pt.addEventListener(TweenEvent.UPDATED, colorupdater, false, 0, true);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(_newvals.length > 0) {
						pt.arrayObject.startvalues = _startvalues;
						pt.arrayObject.difvalues = _difvalues;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATED, updateListener, false, 0, true);
				if($to.round) addEventListener(TweenEvent.UPDATED, roundTweenValue, false, 0, true);
				return pt.id;
			}
		}
		
		public override function clone():* {
			return new ColorTween(_tweenconfig);
		}
	
	}

}
