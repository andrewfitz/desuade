package com.desuade.motion.tweens {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BasicMultiTween extends BasicTween {
		
		protected static var _tweenholder:Object = BasicTween._tweenholder;
			
		public function BasicMultiTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		//BasicTween converts the duration from ms to seconds
		protected override function createTween($to:Object):int {
			for (var p:String in $to.properties) {
				$to.properties[p] = (typeof $to.properties[p] == 'string') ? $to.target[p] + Number($to.properties[p]) : $to.properties[p];
			}
			var pt:PrimitiveMultiTween = _tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween($to.target, $to.properties, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc);
			return pt.id;
		}

	}

}
