package com.desuade.motion.tween {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class BasicTween extends Object {
		
		private static var _tweenholder:Object = {};
		
		private var _tweenconfig:Object;
		private var _tweenID:int = 0;
		private var _delayTimer:Timer;
			
		public function BasicTween($tweenObject:Object) {
			super();
			_tweenconfig = $tweenObject;
		}
		
		//static
		
		public static function tween($tweenObject:Object):void {
			var staticTween = new BasicTween($tweenObject);
			staticTween.start();
		}
		
		///////
		
		public function start():void {
			if(_tweenconfig.delay != undefined) delayedTween(_tweenconfig.delay);
			else _tweenID = createTween(_tweenconfig);
		}
		
		public function stop():void {
			if(_tweenID != 0){
				_tweenholder[_tweenID].end();
			} else {
				_delayTimer.stop();
			}
		}
		
		//BasicTween converts the duration from ms to seconds
		private function createTween($to:Object):int {
			var pt:PrimitiveTween = _tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.prop, $to.value, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc);
			return pt.id;
		}
		
		private function endFunc($o:Object):void {
			delete _tweenholder[_tweenID];
		}
		
		private function delayedTween($delay:int):void {
			_delayTimer = new Timer($delay*1000);
			_delayTimer.addEventListener(TimerEvent.TIMER, dtFunc);
			_delayTimer.start();
		}
		private function dtFunc($i:Object):void {
			_delayTimer.stop();
			_delayTimer = null;
			_tweenID = createTween(_tweenconfig);
		}
	
	}

}

