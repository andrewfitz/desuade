package com.desuade.motion.sequencers {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import com.desuade.debugging.*;
	import com.desuade.motion.events.*;

	public dynamic class Sequence extends Array implements IEventDispatcher {
		
		protected var _position:int = 0;
		protected var _active:Boolean = false;
		protected var _tween;
		protected var _dispatcher = new EventDispatcher();
		protected var _tweenclass:Class;
		protected var _target:Object = null;
	
		public function Sequence($tweenclass:Class, ... args) {
			super();
			_tweenclass = $tweenclass;
			pushArray(args);
			Debug.output('motion', 40003);
		}
		
		public function get position():int{
			return _position;
		}
		public function get active():Boolean{
			return _active;
		}
		
		public function get tweenclass():Class{
			return _tweenclass;
		}
		
		public function set tweenclass($value:Class):void {
			_tweenclass = $value;
		}
		
		public function get target():Object{
			return _target;
		}
		
		public function set target($value:Object):void {
			_target = $value;
		}
		
		public function start($position:int = 0, $simulate:Boolean = false):void {
			if(!active && this.length != 0){
				_active = true;
				Debug.output('motion', 40008);
				_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.STARTED, {sequence:this}));
				if($position > 0 && $simulate){
					Debug.output('motion', 40006, [$position]);
					for (var i:int = 0; i < $position; i++) {
						var t:Object = this[i];
						t.target[t.prop] = (typeof t.value == 'string') ? t.target[t.prop] + Number(t.value) : t.value;
					}
				}
				play($position);	
			} else {
				Debug.output('motion', 10006);
			}
		}
		
		public function stop():void {
			if(active){
				_tween.removeEventListener(TweenEvent.ENDED, advance);
				_tween.stop();
				end();
			} else {
				Debug.output('motion', 10007);
			}
		}
		
		public function pushArray($array:Array):void {
			for (var i:int = 0; i < $array.length; i++) {
				this.push($array[i]);
			}
		}
		
		public function clone():Sequence {
			var ns:Sequence = new Sequence(_tweenclass);
			for (var i:int = 0; i < this.length; i++){
				var no:Object = {};
				for (var p:String in this[i]) {
					no[p] = this[i][p]
				}
				ns.push(no);
			}
			return ns;
		}
		
		public function empty():Array {
			return splice(0);
		}
		
		protected function play($position:int):void {
			Debug.output('motion', 40004, [$position]);
			_position = $position;
			_tween = new _tweenclass(this[_position]);
			if(_target != null) _tween.config.target = _target;
			_tween.addEventListener(TweenEvent.ENDED, advance, false, 0, true);
			_tween.start();
		}
		
		protected function end():void {
			_tween = null;
			_active = false;
			_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.ENDED, {sequence:this}));
			Debug.output('motion', 40005);
		}
		
		protected function advance($i:Object):void {
			if(_position < length-1){
				play(++_position);
				_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.ADVANCED, {position:_position, sequence:this}));
			} else {
				_tween.removeEventListener(TweenEvent.ENDED, advance);
				end();
			}
		}
		
		//for event-dispatching
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}

		public function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
		
	}

}

