/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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

package com.desuade.motion.sequences {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import com.desuade.debugging.*;
	import com.desuade.motion.events.*;

	/**
	 *  <p>A Sequence is an Array that contains an ordered group of motion objects that get called right after another, in the order given.</p>
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
		protected var _current:Object;
		
		/**
		 *	@private
		 */
		protected var _manualAdvance:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 *	<p>Creates a new Sequence.</p>
		 *	<p>A sequence is a subclass of Array, so you can manipulate items in a sequence just like an array.</p>
		 *	<p>Any motion class that broadbasts an MotionEvent.ENDED can be sequenced.</p>
		 *	<p>By passing an Array into the sequence, all tween objects inside will be grouped together and played at the same time. The sequence will only advance once the tween with the longest duration is finished.</p>
		 *	<p>Sequences can also be nested, and another sequence is a valid object to push into a sequence. Sequences can NOT be nested inside Arrays.</p>
		 *	
		 *	@param	args	 All the items passed into the constructor will be pushed into the sequence like an array.
		 *	
		 */
		public function Sequence(... args) {
			super();
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
		 *	The current motion object that's running.
		 */
		public function get current():Object{
			return _current;
		}
		
		/**
		 *	If set to true, the sequence will not add a listener, and will not advance the sequence until advance() is called.
		 */
		public function get manualAdvance():Boolean{
			return _manualAdvance;
		}
		
		/**
		 *	@private
		 */
		public function set manualAdvance($value:Boolean):void {
			_manualAdvance = $value;
		}
		
		/**
		 *	Starts the Seqeuence from the specified position, or the beginning if no position is specified.
		 *	@param	position	 Which object to start from in the Sequence (Array), starting from 0.
		 *	
		 *	@return		The sequence (for chaining)
		 */
		public function start($position:int = 0):* {
			if(!active && this.length != 0){
				_active = true;
				Debug.output('motion', 40008);
				dispatchEvent(new SequenceEvent(SequenceEvent.STARTED, {sequence:this}));
				play($position);
			} else {
				Debug.output('motion', 10006);
			}
			return this
		}
		
		/**
		 *	Stops the Sequence.
		 */
		public function stop():void {
			if(active){
				current.removeEventListener(MotionEvent.ENDED, advance);
				current.stop();
				end();
			} else {
				Debug.output('motion', 10007);
			}
		}
		
		/**
		 *	Takes all the items in an Array and pushes them into the Sequence.
		 *	@param	array	 An Array with Sequenceable Objects.
		 *	@return		Returns the Sequence (for chaining)
		 */
		public function pushArray($array:Array):Sequence {
			for (var i:int = 0; i < $array.length; i++) {
				this.push($array[i]);
			}
			return this;
		}
		
		/**
		 *	<p>This advances the currently playing sequence.</p>
		 *	<p>This happens automatically unless manualAdvance = true</p>
		 */
		public function advance($i:Object = null):void {
			if(active){
				if(!_manualAdvance) current.removeEventListener(MotionEvent.ENDED, advance);
				if(_position < length-1){
					play(++_position);
					dispatchEvent(new SequenceEvent(SequenceEvent.ADVANCED, {position:_position, sequence:this}));
				} else {
					end();
				}
			} else {
				Debug.output('motion', 10007);
			}
		}
		
		/**
		 *	@private
		 */
		protected function play($position:int):void {
			Debug.output('motion', 40004, [$position]);
			_position = $position;
			_current = itemCheck(this[_position]);
			if(!_manualAdvance) current.addEventListener(MotionEvent.ENDED, advance, false, 0, false);
			if(_current is SequenceGroup) current.start(this);
			else current.start();
		}
		
		/**
		 *	@private
		 */
		internal function itemCheck($o:*):* {
			if($o is SequenceGroup) {
				return $o;
			} else if($o is Sequence){
				return $o;
			} else if($o is Array) {
				return new SequenceGroup().pushArray($o);
			} else {
				return $o;
			}
		}
		
		/**
		 *	@private
		 */
		protected function end():void {
			_current = null;
			_active = false;
			dispatchEvent(new SequenceEvent(SequenceEvent.ENDED, {sequence:this}));
			Debug.output('motion', 40005);
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
