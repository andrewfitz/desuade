package com.desuade.motion.tween {

	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	public class PrimitiveTween extends EventDispatcher {
		
		public static var _count:int = 1000000;
		private static var _sprite:Sprite = new Sprite();
		
		public var id:int;
		public var target:Object;
		public var prop:String;
		public var value:Number;
		public var duration:int;
		public var ease:Function;
		public var startvalue:Number;
		public var starttime:int;
		private var difvalue:Number;
		public var completed:Boolean = false;
		
		public function PrimitiveTween($target:Object, $prop:String, $value:Number, $duration:int, $ease:Function) {
			super();
			id = _count++, target = $target, prop = $prop, value = $value, duration = $duration, ease = $ease, startvalue = target[prop], starttime = getTimer();
			difvalue = (startvalue > value) ? (value-startvalue) : -(startvalue-value);
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {primitiveTween:this}));
			_sprite.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(u:Object):void {
			var tmr:int = getTimer() - starttime;
			target[prop] = ease(tmr, startvalue, difvalue, duration);
			dispatchEvent(new TweenEvent(TweenEvent.UPDATE, {primitiveTween:this}));
			if(tmr >= duration){
				target[prop] = value;
				completed = true;
				end();
			}
		}
		
		public function end():void {
			Debug.output('motion', 20001, [id]);
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
			dispatchEvent(new TweenEvent(TweenEvent.ENDED, {primitiveTween:this}));
			delete this;
		}
	
	}

}
