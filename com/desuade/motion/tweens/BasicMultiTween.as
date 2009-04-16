package com.desuade.motion.tweens {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BasicMultiTween extends BasicTween {
					
		public function BasicMultiTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		//BasicTween converts the duration from ms to seconds
		protected override function createTween($to:Object):int {
			for (var p:String in $to.properties) {
				$to.properties[p] = (typeof $to.properties[p] == 'string') ? $to.target[p] + Number($to.properties[p]) : $to.properties[p];
			}
			var pt:PrimitiveMultiTween = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween($to.target, $to.properties, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
			return pt.id;
		}
		
		public override function clone():* {
			return new BasicMultiTween(_tweenconfig);
		}

	}

}
