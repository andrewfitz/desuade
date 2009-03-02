package com.desuade.motion.tween {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	public class BasicTween extends Object {
		
		private static var _tweenholder:Object = {};
		
		private var _tweenconfig:Object;
		private var _tweenID:int;
			
		public function BasicTween($tweenObject:Object) {
			super();
			_tweenconfig = $tweenObject;
		}
		
		public static function tween($tweenObject:Object):PrimitiveTween {
			return _tweenholder[createTween($tweenObject)];
		}
		
		public function start():void {
			_tweenID = createTween(_tweenconfig);
		}
		
		public function stop():void {
			_tweenholder[_tweenID].end();
		}
		
		//BasicTween converts the duration from ms to seconds
		private static function createTween($to:Object):int {
			var pt:PrimitiveTween = _tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.prop, $to.value, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, BasicTween.endFunc);
			return pt.id;
		}
		
		private static function endFunc($o:Object):void {
			delete _tweenholder[$o.info.primitiveTween.id];
		}
	
	}

}

