package com.desuade.motion.tweens {

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
		internal static var _sprite:Sprite = new Sprite();
		
		public var id:int;
		public var target:Object;
		public var property:String;
		public var value:Number;
		public var duration:int;
		public var ease:Function;
		internal var startvalue:Number;
		internal var starttime:int;
		internal var difvalue:Number;
		
		public function PrimitiveTween($target:Object, $property:String, $value:Number, $duration:int, $ease:Function = null) {
			super();
			id = _count++, target = $target, duration = $duration, ease = $ease || linear, starttime = getTimer();
			if($property != null) {
				property = $property, value = $value, startvalue = $target[$property];
				difvalue = (startvalue > value) ? (value-startvalue) : -(startvalue-value);
			}
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {primitiveTween:this}));
			_sprite.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			Debug.output('motion', 50001, [id]);
		}
		
		protected function update($u:Object):void {
			var tmr:int = getTimer() - starttime;
			if(tmr >= duration){
				target[property] = value;
				end();
			} else {
				target[property] = ease(tmr, startvalue, difvalue, duration);
				dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {primitiveTween:this}));
			}
		}
		
		public function end($broadcast:Boolean = true):void {
			Debug.output('motion', 50002, [id]);
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
			if($broadcast) dispatchEvent(new TweenEvent(TweenEvent.ENDED, {primitiveTween:this}));
			delete this;
		}
		
		protected static function linear(t:Number, b:Number, c:Number, d:Number):Number {
			return c*t/d+b;
		}
	
	}

}
