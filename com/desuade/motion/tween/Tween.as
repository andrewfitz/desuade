package com.desuade.motion.tween {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	
	public class Tween extends BasicTween {
		
		protected var _delayTimer:Timer;
		protected var _completed:Boolean = false;
		
		//Static tween function
		public static function tween($tweenObject:Object):void {
			var staticTween = new Tween($tweenObject);
			staticTween.start();
		}
		
		//overriding methods
		public override function Tween($tweenObject:Object) {
			super($tweenObject);
		}
		
		public override function start():void {
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
			_completed = false;
			if(_tweenconfig.delay > 0) delayedTween(_tweenconfig.delay);
			else _tweenID = createTween(_tweenconfig);
		}
		
		public override function stop():void {
			if(_tweenID != 0){
				_tweenholder[_tweenID].end();
			} else {
				_delayTimer.stop();
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
			}
		}
		
		protected override function createTween($to:Object):int {
			if($to.round){
				addEventListener(TweenEvent.UPDATE, roundTweenValue);
			}
			delete $to.round;
			
			return super.createTween($to);
		}
		
		protected override function endFunc($o:Object):void {
			super.endFunc($o);
			_completed = true;
		}
		
		////new methods
		
		public function get position():Number {
			if(_tweenID != 0){
				var pt:PrimitiveTween = _tweenholder[_tweenID];
				var pos:Number = (pt.target[pt.prop]-pt.startvalue)/(pt.value-pt.startvalue);
				return pos;
			} else if(_completed) return 1;
			else return 0;
		}
		
		public function get completed():Boolean{
			return _completed;
		}
		
		protected function delayedTween($delay:int):void {
			Debug.output('motion', 40002, [$delay]);
			_delayTimer = new Timer($delay*1000);
			_delayTimer.addEventListener(TimerEvent.TIMER, dtFunc);
			_delayTimer.start();
		}
		
		protected function dtFunc($i:Object):void {
			_delayTimer.stop();
			_delayTimer = null;
			_tweenID = createTween(_tweenconfig);
		}
		
		protected function roundTweenValue($i:Object):void {
			trace("ROUNDING");
			$i.info.tween.target[$i.info.tween.prop] = int($i.info.tween.target[$i.info.tween.prop]);
		}
	
	}

}

