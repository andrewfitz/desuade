package com.desuade.motion.tween {

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
		
		public function start():void {
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
			_tweenID = createTween(_tweenconfig).id;
		}
		
		public function stop():void {
			if(_tweenID != 0) _tweenholder[_tweenID].end();
		}
		
		//BasicTween converts the duration from ms to seconds
		protected function createTween($to:Object):PrimitiveTween {
	      var ftv = $to.target[$to.prop];
	      var newval:Number = (typeof $to.value == 'string') ? ftv + Number($to.value) : $to.value;
	      var pt:PrimitiveTween = _tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.prop, newval, $to.duration*1000, $to.ease);
	      pt.addEventListener(TweenEvent.ENDED, endFunc);
	      return pt;
		}
		
		protected function endFunc($o:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this, primitiveTween:_tweenholder[_tweenID]}));
			delete _tweenholder[_tweenID];
			_tweenID = 0;
		}

	}

}
