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
	 *  Items in here will be ran at the same time in a Sequence.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.07.2009
	 */
	public dynamic class SequenceGroup extends Array implements IEventDispatcher {
		
		/**
		 *	@private
		 */
		protected var _current:Array = [];
		
		/**
		 *	@private
		 */
		protected var _waiting:int;
		
		/**
		 *	@private
		 */
		protected var _manualServe:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 *	<p>This creates a "group" of motion items that will be started together (parallel), instead of sequentially.</p>
		 *	<p>This gets automatically created if the Sequence encounters an Array.</p>
		 */
		public function SequenceGroup(... args) {
			super();
			pushArray(args);
			Debug.output('motion', 40012);
		}
		
		/**
		 *	An array of the current items being ran.
		 */
		public function get current():Array{
			return _current;
		}
		
		/**
		 *	How many items are left to be completed.
		 */
		public function get waiting():int{
			return _waiting;
		}
		
		/**
		 *	If this is true, the SequenceGroup wont call serve() automatically.
		 */
		public function get manualServe():Boolean{
			return _manualServe;
		}
		
		/**
		 *	@private
		 */
		public function set manualServe($value:Boolean):void {
			_manualServe = $value;
		}
		
		/**
		 *	Takes all the items in an Array and pushes them into the Sequence.
		 *	@param	array	 An Array with Sequenceable Objects.
		 *	@return		Returns the Sequence (for chaining)
		 */
		public function pushArray($array:Array):SequenceGroup {
			for (var i:int = 0; i < $array.length; i++) {
				this.push($array[i]);
			}
			return this;
		}
		
		/**
		 *	@private
		 */
		internal function start($parent:Sequence):void {
			for (var i:int = 0; i < this.length; i++) {
				_current[i] = $parent.itemCheck(this[i]);
				if(!_manualServe) _current[i].addEventListener(MotionEvent.ENDED, serve, false, 0, false);
				_current[i].start((_current[i] is SequenceGroup) ? $parent : null);
			}
			_waiting = _current.length;
		}
		
		/**
		 *	@private
		 */
		internal function stop():void {
			for (var i:int = 0; i < _current.length; i++) {
				_current[i].stop();
			}
			end();
		}
		
		/**
		 *	<p>This tells the SequenceGroup that one of the items ended.</p>
		 */
		public function serve($o:Object = null):void {
			if(--_waiting == 0) end();
		}
		
		/**
		 *	This gets the total duration if the Class ONLY if the motionClass is a tween.
		 */
		public function get duration():Number {
			var totaldur:Number = 0;
			for (var i:int = 0; i < length; i++) {
				var ld:Number = (this[i].duration || 0) + (this[i].delay || 0);
				if(ld > totaldur){
					totaldur = ld;
				}
			}
			return totaldur;
		}
		
		/**
		 *	@private
		 */
		protected function end():void {
			if(!_manualServe){
				for (var i:int = 0; i < current.length; i++) {
					current[i].removeEventListener(MotionEvent.ENDED, serve);
				}
			}
			_current = null;
			dispatchEvent(new SequenceEvent(SequenceEvent.ENDED, {sequenceGroup:this}));
		}
		
		/////dispatches
		
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
