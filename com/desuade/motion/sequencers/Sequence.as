/*
This software is distributed under the MIT License.

Copyright (c) 2009 Desuade (http://desuade.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.desuade.motion.sequencers {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import com.desuade.debugging.*;
	import com.desuade.motion.events.*;
	import com.desuade.motion.tweens.BasicTween;

	/**
	 *  <p>A Sequence is an object that contains an ordered group of tweens that get called right after another, in the order given.</p>
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.04.2009
	 */
	public dynamic class Sequence extends Array implements IEventDispatcher {
		
		/**
		 *	@private
		 */
		protected var _position:int = 0;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _tween:*;
		
		/**
		 *	@private
		 */
		protected var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 *	@private
		 */
		protected var _tweenclass:Class;
		
		/**
		 *	@private
		 */
		protected var _overrides:Object;
		
		/**
		 *	@private
		 */
		protected var _allowOverrides:Boolean = true;
		
		/**
		 *	<p>Creates a new Sequence.</p>
		 *	<p>A sequence is a subclass of Array, so you can manipulate items in a sequence just like an array.</p>
		 *	<p>You can pass actual tweens into the Sequence that bypass the tweenclass and overrides, or regular objects that will be created into new tweens based on the tweenclass provided.</p>
		 *	<p>Each sequence creates tweens from objects passed, based on the given tweenclass, so the objects that are pushed into the sequence vary depending on the required parameters of the specified tweening class.</p>
		 *	<p>By passing an Array into the sequence, all tween objects inside will be grouped together and played at the same time. The sequence will only advance once the tween with the longest duration is finished.</p>
		 *	<p>Sequences can also be nested, and another sequence is a valid object to push into a sequence. Sequences can NOT be nested inside Arrays.</p>
		 *	
		 *	@param	tweenclass	 This is the class of tweens to use in the sequence.
		 *	@param	args	 After passing the tweenclass, all following items passed into the contructor will be pushed into the sequence like an array.
		 *	@see	#tweenclass
		 *	
		 */
		public function Sequence($tweenclass:Class, ... args) {
			super();
			_tweenclass = $tweenclass;
			pushArray(args);
			Debug.output('motion', 40003);
		}
		
		/**
		 *	The current position of the Seqeuence.
		 */
		public function get position():int{
			return _position;
		}
		
		/**
		 *	If the Seqeuence is currently running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	<p>This is the class of tweens to use in the sequence.</p>
		 *	<p>Each Seqeuence will create only one kind of tween - ie: BasicTween, Tween, MultiTween, etc. To create a Seqeuence that contains multiple tween classes, create a new Seqeuence and then push that into the Array.</p>
		 */
		public function get tweenclass():Class{
			return _tweenclass;
		}
		
		/**
		 *	@private
		 */
		public function set tweenclass($value:Class):void {
			_tweenclass = $value;
		}
		
		/**
		 *	<p>An Object that represents a normal Sequence object, that contains properties to be applied to every object in the Sequence.</p>
		 *	
		 *	<p>For example: <code>seq.overrides = {target:my_obj, ease:Linear.none}</code> will assign all the tweens in the sequence their 'target' and 'ease' values to the given values in the overrides object, unless the object has <code>{allowOverrides:false}</code></p>
		 *	
		 */
		public function get overrides():Object{
			return _overrides;
		}
		
		/**
		 *	@private
		 */
		public function set overrides($value:Object):void {
			_overrides = $value;
		}
		
		/**
		 *	Does the Seqeuence allow it's objects to be replaced with override values.
		 */
		public function get allowOverrides():Boolean{
			return _allowOverrides;
		}
		
		/**
		 *	@private
		 */
		public function set allowOverrides($value:Boolean):void {
			_allowOverrides = $value;
		}
		
		/**
		 *	Starts the Seqeuence from the specified position, or the beginning if no position is specified.
		 *	@param	position	 Which object to start from in the Sequence (Array), starting from 0.
		 */
		public function start($position:int = 0):void {
			if(!active && this.length != 0){
				_active = true;
				Debug.output('motion', 40008);
				_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.STARTED, {sequence:this}));
				play($position);	
			} else {
				Debug.output('motion', 10006);
			}
		}
		
		/**
		 *	Stops the Sequence.
		 */
		public function stop():void {
			if(active){
				_tween.removeEventListener(TweenEvent.ENDED, advance);
				_tween.stop();
				end();
			} else {
				Debug.output('motion', 10007);
			}
		}
		
		/**
		 *	Takes all the items in an Array and pushes them into the Sequence.
		 *	@param	array	 An Array with Sequenceable Objects.
		 */
		public function pushArray($array:Array):void {
			for (var i:int = 0; i < $array.length; i++) {
				this.push($array[i]);
			}
		}
		
		/**
		 *	Creates a duplicate Sequence from the current one.
		 *	@return		A copy of the sequence.
		 */
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
		
		/**
		 *	Removes all the items in the Sequence.
		 *	@return		An array of all the items emptied from the sequence.
		 */
		public function empty():Array {
			return splice(0);
		}
		
		/**
		 *	@private
		 */
		protected function play($position:int):void {
			Debug.output('motion', 40004, [$position]);
			_position = $position;
			var tp:Object = this[_position];
			if(tp is Sequence){
				if(tp.allowOverrides != false) {
					for (var e:String in _overrides) {
						tp.overrides[e] = _overrides[e];
					}
				}
				tp.addEventListener(SequenceEvent.ENDED, advance, false, 0, true);
				tp.start();
			} else if(tp is Array){
				_tween = [];
				var longdur:Array = [-1, _tween];
				for (var i:int = 0; i < tp.length; i++) {
					if(tp[i] is BasicTween){
						_tween[i] = tp[i];
					} else {
						_tween[i] = new _tweenclass(tp[i]);
						if(tp[i].allowOverrides != false){
							for (var r:String in _overrides) {
								_tween[i].config[r] = _overrides[r];
							}
						}
					}
					if(_tween[i].config.duration > longdur[0]) longdur = [_tween[i].config.duration, _tween[i]];
					_tween[i].start();
				}
				longdur[1].addEventListener(TweenEvent.ENDED, advance, false, 0, true);
			} else {
				if(tp is BasicTween){
					_tween = tp;
				} else {
					_tween = new _tweenclass(tp);
					if(tp.allowOverrides != false){
						for (var p:String in _overrides) {
							_tween.config[p] = _overrides[p];
						}
					}
				}
				_tween.addEventListener(TweenEvent.ENDED, advance, false, 0, true);
				_tween.start();
			}
		}
		
		/**
		 *	@private
		 */
		protected function end():void {
			_tween = null;
			_active = false;
			_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.ENDED, {sequence:this}));
			Debug.output('motion', 40005);
		}
		
		/**
		 *	@private
		 */
		protected function advance($i:Object):void {
			if($i is SequenceEvent) $i.data.sequence.removeEventListener(SequenceEvent.ENDED, advance);
			else $i.data.tween.removeEventListener(TweenEvent.ENDED, advance);
			if(_position < length-1){
				play(++_position);
				_dispatcher.dispatchEvent(new SequenceEvent(SequenceEvent.ADVANCED, {position:_position, sequence:this}));
			} else {
				end();
			}
		}
		
		/**
		 *	@private
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 *	@private
		 */
		public function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}
		
		/**
		 *	@private
		 */
		public function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 *	@private
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 *	@private
		 */
		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
		
	}

}

