package com.desuade.motion.tween {

	import flash.display.*; 
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	//Easing functions can be included with import fl.motion.easing.*
	
	import com.desuade.debugging.*

	public class PrimitiveTween extends Object {
		
		private static var _count:int = 1000000;
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
		
		public function PrimitiveTween(target:Object, prop:String, value:Number, duration:int, ease:Function) {
			super();
			this.id = ++_count;
			this.target = target;
			this.prop = prop;
			this.value = value;
			this.duration = duration;
			this.ease = ease;
			this.startvalue = target[prop];
			this.starttime = getTimer();
			difvalue = (startvalue > value) ? (value-startvalue) : -(startvalue-value);
			_sprite.addEventListener(Event.ENTER_FRAME, this.update);
		}
		
		private function update(u:Object):void {
			var tmr:int = getTimer() - starttime;
			target[prop] = ease(tmr, startvalue, difvalue, duration);
			if(tmr >= duration){
				target[prop] = value;
				completed = true;
				kill();
			}
		}
		
		public function kill():void {
			Debug.output('motion', 20001, [id]);
			_sprite.removeEventListener(Event.ENTER_FRAME, this.update);
			delete this;
		}
	
	}

}
