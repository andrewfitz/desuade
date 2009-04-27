package com.desuade.motion.tweens {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	public class Tween extends BasicTween {
				
		protected var _delayTimer:Timer;
		protected var _completed:Boolean = false;
		protected var _pausepos:Number;
		protected var _newval:Number;
		protected var _startvalue:Number;
		protected var _difvalue:Number;
		
		public function Tween($tweenObject:Object) {
			super($tweenObject);
		}
		
		//Static tween function
		public static function tween($target:Object, $property:String, $value:*, $duration:int, $ease:Function = null, $delay:Number = 0, $position:Number = 0, $bezier:Array = null):Tween {
			var st:Tween = new Tween({target:$target, value:$value, property:$property, duration:$duration, ease:$ease, delay:$delay, position:$position, bezier:$bezier});
			st.start();
			return st;
		}
		
		//overriding methods
		public override function start($delay:Number = -1, $position:Number = -1):void {
			if(!_completed && !active){
				_tweenconfig.delay = ($delay == -1) ? _tweenconfig.delay : $delay;
				if($position == -1){
					if(!isNaN(_pausepos)) _tweenconfig.position = _pausepos;
				} else {
					_tweenconfig.position = $position;
				}
				_tweenconfig.position = ($position == -1) ? _tweenconfig.position : $position;
				_active = true;
				dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
				if(_tweenconfig.delay > 0) delayedTween(_tweenconfig.delay);
				else _tweenID = createTween(_tweenconfig);
			} else {
				Debug.output('motion', 10005);
			}
		}
		
		public override function stop():void {
			if(!_completed){
				if(_tweenID != 0){
					if(!_completed){
						setpauses();
					}
					BasicTween._tweenholder[_tweenID].end();
				} else {
					_delayTimer.stop();
					dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				}
			} else {
				Debug.output('motion', 10004);
			}
		}
		
		protected override function createTween($to:Object):int {
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				var pt:PrimitiveTween;
				var ftv:Object = $to.target[$to.property];
				var ntval:*;
				if(isNaN(_newval)){
					if($to.value is Random) ntval = $to.value.randomValue;
					else ntval = $to.value;
					if($to.relative === true) _newval = ftv + Number(ntval);
					else if($to.relative === false) _newval = Number(ntval);
					else _newval = (typeof ntval == 'string') ? ftv + Number(ntval) : ntval;
				}
				if($to.bezier == undefined || $to.bezier == null){
					 pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.property, _newval, $to.duration*1000, $to.ease);
				} else {
					var newbez:Array = [];
					for (var i:int = 0; i < $to.bezier.length; i++) {
						newbez.push((typeof $to.bezier[i] == 'string') ? ftv + Number($to.bezier[i]) : $to.bezier[i]);
					}
					pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveBezierTween($to.target, $to.property, _newval, $to.duration*1000, newbez, $to.ease);
				}
				pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(!isNaN(_newval)) {
						pt.startvalue = _startvalue;
						pt.difvalue = _difvalue;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATED, updateListener, false, 0, true);
				if($to.round) addEventListener(TweenEvent.UPDATED, roundTweenValue, false, 0, true);
				return pt.id;
			}
		}
		
		protected override function endFunc($o:Object):void {
			if($o.info.primitiveTween.property != undefined){
				if($o.info.primitiveTween.target[$o.info.primitiveTween.property] == $o.info.primitiveTween.value){
					_completed = true;
				}
			}
			super.endFunc($o);
		}
		
		public override function clone():* {
			return new Tween(_tweenconfig);
		}
		
		////new methods
		
		public function reset():void {
			_pausepos = undefined;
			_newval = undefined;
			_difvalue = undefined;
			_startvalue = undefined;
			_completed = false;
			_tweenconfig.position = 0;
		}
		
		public function get position():Number {
			if(_tweenID != 0){
				var pt:PrimitiveTween = BasicTween._tweenholder[_tweenID];
				//var pos:Number = (pt.target[pt.property]-pt.startvalue)/(pt.value-pt.startvalue); //this is for ease pos
				var pos:Number = (getTimer()-pt.starttime)/pt.duration;
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
			_delayTimer.addEventListener(TimerEvent.TIMER, dtFunc, false, 0, true);
			_delayTimer.start();
		}
		
		protected function dtFunc($i:Object):void {
			_delayTimer.stop();
			_delayTimer = null;
			_tweenID = createTween(_tweenconfig);
		}
		
		protected function updateListener($i:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {tween:this, primitiveTween:BasicTween._tweenholder[_tweenID]}));
		}
		
		protected function roundTweenValue($i:Object):void {
			var pt:Object = $i.info.primitiveTween;
			pt.target[pt.property] = int(pt.target[pt.property]);
			Debug.output('motion', 50003, [pt.id, pt.target[pt.property], int(pt.target[pt.property])]);
		}
		
		protected function setpauses():void {
			_pausepos = position;
			_startvalue = BasicTween._tweenholder[_tweenID].startvalue;
			_difvalue = BasicTween._tweenholder[_tweenID].difvalue;
		}
	
	}

}
