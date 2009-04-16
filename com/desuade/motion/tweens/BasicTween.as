package com.desuade.motion.tweens {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BasicTween extends EventDispatcher {
		
		protected static var _tweenholder:Object = {};
		
		protected var _tweenconfig:Object;
		protected var _tweenID:int = 0;
			
		public function BasicTween($tweenObject:Object) {
			super();
			_tweenconfig = $tweenObject;
			Debug.output('motion', 40001);
		}
		
		//args need to be in here for overriding - delay and position
		public function start($delay:Number = -1, $position:Number = -1):void {
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
			_tweenID = createTween(_tweenconfig);
		}
		
		public function stop():void {
			if(_tweenID != 0) _tweenholder[_tweenID].end();
		}
		
		public function clone():* {
			return new BasicTween(_tweenconfig);
		}
		
		//BasicTween converts the duration from ms to seconds
		protected function createTween($to:Object):int {
	      var newval:Number = (typeof $to.value == 'string') ? $to.target[$to.prop] + Number($to.value) : $to.value;
	      var pt:PrimitiveTween = _tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.prop, newval, $to.duration*1000, $to.ease);
	      pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
	      return pt.id;
		}
		
		protected function endFunc($o:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this, primitiveTween:_tweenholder[_tweenID]}));
			_tweenholder[_tweenID] = null;
			delete _tweenholder[_tweenID];
			_tweenID = 0;
		}

	}

}
