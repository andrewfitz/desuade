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

package com.desuade.motion.bases {
	
	import flash.display.*;
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import com.desuade.debugging.*;
	import com.desuade.utils.*;
	
	/**
	 *  Handles primitive update cycles for render()
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.07.2009
	 */
	public class BaseTicker {
		
		/**
		 *	This is the MultiPool that stores all the object pools for the Primitive classes.
		 */
		public static var classPool:MultiPool = new MultiPool(null);
		
		/**
		 *	@private
		 */
		protected static var _dispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 *	@private
		 */
		internal static var _sprite:Sprite = new Sprite();
		
		/**
		 *	@private
		 */
		internal static var _inited:Boolean = false;
		
		/**
		 *	@private
		 */
		protected static var _holder:Object = {};
		
		/**
		 *	@private
		 */
		protected static var _emptyTimer:Timer;
		
		/**
		 *	@private
		 */
		protected static var _emptied:Boolean = false;
		
		/**
		 *	@private
		 */
		public static var _count:int = 0;
		
		/**
		 *	<p>The default rate for physics as default interval for BasicPhysics.startAtTime().</p>
		 *	<p>It is recomended to set this to your SWF's global stage.frameRate for more accurate rendering.</p>
		 */
		public static var physicsRate:Number = 30;
		
		/**
		 *	True if the ticker has been initialized.
		 */
		public static function get inited():Boolean { 
			return _inited;
		}
		
		/**
		 *	Initializes the Ticker.
		 */
		public static function start():void {
			if(!_inited){
				_sprite.addEventListener(Event.ENTER_FRAME, update, false, 0, false);
				_inited = true;
				dispatchEvent(new MotionEvent(MotionEvent.STARTED));
				_emptyTimer = new Timer(2000);
				_emptyTimer.addEventListener(TimerEvent.TIMER, emptyCheck, false, 0, false);
				_emptyTimer.start();
			}
		}
		
		/**
		 *	De-initializes the Ticker.
		 */
		public static function stop():void {
			if(_inited){
				_sprite.removeEventListener(Event.ENTER_FRAME, update);
				_inited = false;
				dispatchEvent(new MotionEvent(MotionEvent.ENDED));
				_emptyTimer.removeEventListener(TimerEvent.TIMER, emptyCheck);
				_emptyTimer.stop();
				_emptyTimer = null;
			}
		}
		
		/**
		 *	Gets a new id for a primitive item.
		 */
		public static function aquireID():int {
			return ++_count;
		}
		
		/**
		 *	Returns the item based on the id.
		 *	
		 *	@param	id	 The id of the Motion Item
		 *	
		 *	@return		The requested item.
		 */
		public static function getItem($id:int):* {
			return _holder[$id];
		}
		
		/**
		 *	Adds an item to the ticker.
		 *	
		 *	@param	class	The class of the item to add (Primitives)
		 *	@return		The item in the ticker
		 */
		public static function addItem($class:Class):* {
			var item:* = BaseTicker.classPool.checkOutClass($class);
			return _holder[item.id] = item;
		}
		
		/**
		 *	Removes the item for the ticker.
		 *	
		 *	@param	id	 The id of the item
		 */
		public static function removeItem($id:int):void {
			BaseTicker.classPool.checkInClass(Object(_holder[$id]).constructor, _holder[$id]);
			delete _holder[$id];
		}
		
		/**
		 *	@private
		 */
		protected static function update($u:Object):void {
			//var times:int = getTimer();
			//var ir:int = 0;
			for each (var item:BasePrimitive in _holder) {
				item.render(getTimer());
				//ir++;
			}
			//trace("Loop time: " + String(getTimer()-times) + " Items: " + ir);
			dispatchEvent(new MotionEvent(MotionEvent.UPDATED));
		}
		
		/**
		 *	@private
		 */
		protected static function emptyCheck($o:Object):void {
			var ir:int = 0;
			for each (var item:BasePrimitive in _holder) ir++;
			if(ir == 0){
				if(!_emptied){
					classPool.purgeAllClasses();
					_emptied = true;	
				}
			} else _emptied = false;
		}
		
		/**
		 *	@private
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			start();
		}

		/**
		 *	@private
		 */
		public static function dispatchEvent(evt:Event):Boolean{
			return _dispatcher.dispatchEvent(evt);
		}
		
		/**
		 *	@private
		 */
		public static function hasEventListener(type:String):Boolean{
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 *	@private
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 *	@private
		 */
		public static function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
	
	}

}

////value ticker, frame ticker (this), event ticker, interval ticker