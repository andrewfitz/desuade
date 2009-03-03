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

	final public class PrimitiveTween extends EventDispatcher {
		
		public static var _count:int = 1000000;
		internal static var _sprite:Sprite = new Sprite();
		
		public var id:int;
		public var target:Object;
		public var prop:String;
		public var value:Number;
		public var duration:int;
		public var ease:Function;
		internal var startvalue:Number;
		internal var starttime:int;
		private var difvalue:Number;
		
		public function PrimitiveTween($target:Object, $prop:String, $value:Number, $duration:int, $ease:Function = null) {
			super();
			id = _count++, target = $target, prop = $prop, value = $value, duration = $duration, ease = $ease || linear, startvalue = target[prop], starttime = getTimer();
			difvalue = (startvalue > value) ? (value-startvalue) : -(startvalue-value);
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {primitiveTween:this}));
			_sprite.addEventListener(Event.ENTER_FRAME, update);
			Debug.output('motion', 50001, [id]);
		}
		
		private function update(u:Object):void {
			var tmr:int = getTimer() - starttime;
			target[prop] = ease(tmr, startvalue, difvalue, duration);
			dispatchEvent(new TweenEvent(TweenEvent.UPDATE, {primitiveTween:this}));
			if(tmr >= duration){
				target[prop] = value;
				end();
			}
		}
		
		public function end($broadcast:Boolean = true):void {
			Debug.output('motion', 50002, [id]);
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
			if($broadcast) dispatchEvent(new TweenEvent(TweenEvent.ENDED, {primitiveTween:this}));
			delete this;
		}
		
		private static function linear(t:Number, b:Number, c:Number, d:Number):Number {
			return c*t/d+b;
		}
	
	}

}
