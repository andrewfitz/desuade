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

package com.desuade.utils {
	
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 *  Simple management of common key-based shortcuts
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  22.11.2009
	 */
	public class ShortcutManager {
		
		/**
		 *	The current keys (keyCodes) that are being pressed
		 */
		public var currentKeys:Object = {};
		
		/**
		 *	An Array of keyCodes that have been pressed
		 */
		public var pressedKeys:Array = [];
		
		/**
		 *	The object containing all the registered key combos
		 */
		public var keyCombos:Object = {};
		
		/**
		 *	The object containing all the registered key sequences
		 */
		public var keySequences:Object = {};
		
		/**
		 *	Traces the keyCode everytime a key is pressed. For debuging or learning the keyCode for keys
		 */
		public var traceKeys:Boolean = false;
		
		/**
		 *	Time in ms to wait to expire key presses for keySequences
		 */
		public var expireTime:int = 3000;
		
		/**
		 *	The current combo being pressed at the moment (null if no a combo isn't being pressed)
		 */
		public var currentCombo:Object = null;
		
		/**
		 *	@private
		 */
		protected var _ptimer:Timer = null;
		
		/**
		 *	@private
		 */
		protected var _ctimer:Timer = null;
		
		/**
		 *	This creates a new Shortcut object that will listen for keys pressed to perform a given method.
		 *	
		 *	@param	target	 The target to listen to key presses from, usually: stage
		 */
		public function ShortcutManager($target:Object){
			super();
			$target.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			$target.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
		}
		
		/**
		 *	This will add a shortcut that listens for keys that are being pressed at the same time, in no order.
		 *	
		 *	@param	label	 The name of the shortcut
		 *	@param	keys	 An Array of keyCodes to listen for
		 *	@param	method	 The function to call when the shortcut is fired
		 *	@param	hold	 How long to hold keys down before it's registered
		 */
		public function addKeyCombo($label:String, $keys:Array, $method:Function, $hold:int = 0):void {
			keyCombos[$label] = {keys:$keys, method:$method, hold:$hold};
		}
		
		/**
		 *	This will add a shortcut that listens for keys that have been pressed only in the given order.
		 *	
		 *	@param	label	 The name of the shortcut
		 *	@param	keys	 An Array of keyCodes to listen for in the order to listen for
		 *	@param	method	 The function to call when the shortcut is fired
		 */
		public function addKeySequence($label:String, $keys:Array, $method:Function):void {
			keySequences[$label] = {keys:$keys, method:$method};
		}
		
		/**
		 *	@private
		 */
		protected function keyDownHandler( e:KeyboardEvent ):void {
		    if( currentKeys[ e.keyCode ] ) return;
		    currentKeys[ e.keyCode ] = true;
			ArrayHelper.squeeze(pressedKeys, e.keyCode, 20);
			var spp:String = isComboPressed();
			if(spp != 'none') {
				if(keyCombos[spp].hold > 0) setComboHold(keyCombos[spp]);
				else keyCombos[spp].method();
				resetPK();
			} else {
				var spps:String = isSequencePressed();
				if(spps != 'none') {
					keySequences[spps].method();
					resetPK();
				}
			}
			if(traceKeys) trace("Pressed: " + e.keyCode);
		}
		
		/**
		 *	@private
		 */
		protected function keyUpHandler( e:KeyboardEvent ):void {
		    delete currentKeys[ e.keyCode ];
			if(traceKeys) trace("Released: " + e.keyCode);
			setPressExpire();
			resetCH();
		}
		
		/**
		 *	@private
		 */
		protected function isComboPressed():String {
			for (var p:String in keyCombos) {
				var ss:Object = keyCombos[p];
				var pc:int = 0;
				for (var i:int = 0; i < ss.keys.length; i++) {
					for (var c:String in currentKeys) {
						if(ss.keys[i] == Number(c)) pc++;
					}
				}
				if(pc == ss.keys.length) return p;
			}
			return 'none';
		}
		
		/**
		 *	@private
		 */
		protected function isSequencePressed():String {
			for (var p:String in keySequences) {
				var ss:Object = keySequences[p];
				var ks:String = ss.keys.join(':');
				var pk:String = pressedKeys.join(':');
				if(pk.search(ks) == 0) return p;
				else return 'none';
			}
			return 'none';
		}
		
		/**
		 *	@private
		 */
		protected function setPressExpire():void {
			if(_ptimer != null){
				_ptimer.removeEventListener(TimerEvent.TIMER, resetPK);
				_ptimer.stop();
			}
			_ptimer = new Timer(expireTime);
			_ptimer.addEventListener(TimerEvent.TIMER, resetPK);
			_ptimer.start();
		}
		
		/**
		 *	@private
		 */
		protected function resetPK(e:Object = null):void {
			pressedKeys = []; //reset the pressed keys so it doesn't fire another
			if(_ptimer != null) {
				_ptimer.removeEventListener(TimerEvent.TIMER, resetPK);
				_ptimer.stop();
				_ptimer = null;
			}
		}
		
		/**
		 *	@private
		 */
		protected function setComboHold($combo:Object):void {
			currentCombo = $combo;
			if(_ctimer != null) resetCH();
			_ctimer = new Timer(currentCombo.hold);
			_ctimer.addEventListener(TimerEvent.TIMER, goCH);
			_ctimer.start();
		}
		
		/**
		 *	@private
		 */
		protected function resetCH(e:Object = null):void {
			if(_ctimer != null) {
				_ctimer.removeEventListener(TimerEvent.TIMER, goCH);
				_ctimer.stop();
				_ctimer = null;
			}
			currentCombo = null;
		}
		
		protected function goCH(e:Object = null):void {
			currentCombo.method();
			resetCH();
		}
		
	}

}
