package com.desuade.motion.tween {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	
	public class Tween extends BasicTween {
		
		protected static var _tweenholder = BasicTween._tweenholder;
		
		protected var _delayTimer:Timer;
		protected var _completed:Boolean = false;
		
		public function Tween($tweenObject:Object) {
			super($tweenObject);
		}
		
		//Static tween function
		public static function tween($tweenObject:Object):void {
			var st:Tween = new Tween($tweenObject);
			st.start();
		}
		
		//overriding methods
		public override function start($delay:Number = -1, $position:Number = -1):void {
			_tweenconfig.delay = ($delay == -1) ? _tweenconfig.delay : $delay;
			_tweenconfig.position = ($position == -1) ? _tweenconfig.position : $position;
			_completed = false;
			dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
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
			var pt:PrimitiveTween;
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				var ftv = $to.target[$to.prop];
				var newval:Number = (typeof $to.value == 'string') ? ftv + Number($to.value) : $to.value;
				if($to.bezier == undefined){
					 pt = _tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.prop, newval, $to.duration*1000, $to.ease);
				} else {
					var newbez:Array = [];
					for (var i:int = 0; i < $to.bezier.length; i++) {
						newbez.push((typeof $to.bezier[i] == 'string') ? ftv + Number($to.bezier[i]) : $to.bezier[i]);
					}
					pt = _tweenholder[PrimitiveTween._count] = new PrimitiveBezierTween($to.target, $to.prop, newval, $to.duration*1000, newbez, $to.ease);
				}
				pt.addEventListener(TweenEvent.ENDED, endFunc);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATE, updateListener);
				if($to.round) addEventListener(TweenEvent.UPDATE, roundTweenValue);
				return pt.id;
			}
		}
		
		protected override function endFunc($o:Object):void {
			_completed = true;
			super.endFunc($o);
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
		
		protected function updateListener($i:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.UPDATE, {tween:this, primitiveTween:_tweenholder[_tweenID]}));
		}
		
		protected function roundTweenValue($i:Object):void {
			var pt:Object = $i.info.primitiveTween;
			pt.target[pt.prop] = int(pt.target[pt.prop]);
			Debug.output('motion', 50003, [pt.id, pt.target[pt.prop], int(pt.target[pt.prop])]);
		}
	
	}

}

