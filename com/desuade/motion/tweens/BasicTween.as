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

package com.desuade.motion.tweens {

	import flash.display.*; 
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	/**
	 *  A very basic tween that allows you to tween a given value on any object to a new value.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicTween extends EventDispatcher {
		
		/**
		 *	@private
		 */
		internal static var _inited:Boolean = false;
		
		/**
		 *	@private
		 */
		protected static var _tweenholder:Object = {};
		
		/**
		 *	@private
		 */
		internal static var _sprite:Sprite = new Sprite();
		
		/**
		 *	@private
		 */
		protected var _tweenconfig:Object;
		
		/**
		 *	@private
		 */
		protected var _tweenID:int = 0;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	The target object to perform the tween on.
		 */
		public var target:Object;
		
		/**
		 *	@private
		 */
		protected static function init():void {
			_sprite.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			_inited = true;
		}
		
		/**
		 *	@private
		 */
		protected static function update($u:Object):void {
			var times:int = getTimer();
			for each (var tween:PrimitiveTween in _tweenholder) {
				tween.render(times);
			}
		}
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tweenObject:</p>
		 *	<ul>
		 *	<li>property:String – the property to tween</li>
		 *	<li>value:* – the new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicTween = new BasicTween(myobj, {property:'x', value:.5, duration:2, ease:Bounce.easeIn})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	tweenObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function BasicTween($target:Object, $tweenObject:Object) {
			super();
			if(!_inited) init();
			target = $target;
			_tweenconfig = $tweenObject;
			Debug.output('motion', 40001);
		}
		
		//args need to be in here for overriding - delay and position
		
		/**
		 *	This starts the tween. Delay and position are used for Tween and passing them here will do nothing.
		 *	
		 *	@return		True all the time since the tween can always start.
		 */
		public function start($delay:Number = -1, $position:Number = -1):Boolean {
			if(!_active){
				_active = true;
				dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
				_tweenID = createTween(_tweenconfig);
			}
			return true;
		}
		
		/**
		 *	This stops the tween.
		 *	
		 *	@return		True if the tween could be stopped.
		 */
		public function stop():Boolean {
			if(_tweenID != 0) {
				_tweenholder[_tweenID].end();
				return true;
			} else return false;
		}
		
		/**
		 *	If the tween is currently active and running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Gets the tween config object that was passed in the constructor (property, value, ease, etc). The properties in this object can be modified.
		 */
		public function get config():Object{
			return _tweenconfig;
		}
		
		/**
		 *	The primitivetween's id
		 */
		public function get ptid():int{
			return _tweenID;
		}
		
		/**
		 *	This creates a new tween that is a duplicate clone of this.
		 *	
		 *	@param	target	 The new target object.
		 *	
		 *	@return		A new copy of the current tween.
		 */
		public function clone($target:Object):* {
			return new BasicTween($target, duplicateConfig());
		}
		
		/**
		 *	@private
		 */
		protected function duplicateConfig():Object {
			var ntc:Object = new Object();
			for (var p:String in _tweenconfig) {
				ntc[p] = _tweenconfig[p];
			}
			return ntc;
		}
		
		/**
		 *	@private
		 */
		protected function createTween($to:Object):int {
	      var newval:Number = (typeof $to.value == 'string') ? target[$to.property] + Number($to.value) : $to.value;
	      var pt:PrimitiveTween = _tweenholder[PrimitiveTween._count] = new PrimitiveTween(target, $to.property, newval, $to.duration*1000, $to.ease);
	      pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
	      return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected function endFunc($o:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this, primitiveTween:_tweenholder[_tweenID]}));
			_active = false;
			_tweenholder[_tweenID].removeEventListener(TweenEvent.ENDED, endFunc);
			_tweenholder[_tweenID] = null;
			delete _tweenholder[_tweenID];
			_tweenID = 0;
		}

	}

}
