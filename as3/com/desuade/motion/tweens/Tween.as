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

package com.desuade.motion.tweens {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	import com.desuade.motion.bases.*;
	
	/**
	 *  Changes a property's value over time by 'tweening'. The standard tweening class to use.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.05.2009
	 */
	public class Tween extends BasicTween {
		
		/**
		 *	@private
		 */
		protected var _delayTimer:Timer;
		
		/**
		 *	@private
		 */
		protected var _completed:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _pausepos:Number;
		
		/**
		 *	@private
		 */
		protected var _newval:Number;
		
		/**
		 *	@private
		 */
		protected var _startvalue:Number;
		
		/**
		 *	@private
		 */
		protected var _difvalue:Number;

		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>property:String – the property to tween</li>
		 *	<li>value:* – the new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code></li>
		 *	<li>ease:String – the easing to use. Default is 'linear'. Can pass a Function, but may not be fully compatable.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>delay:Number – how long in seconds to delay starting the tween</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	<li>bezier:Array – an array of bezier curve points</li>
		 *	<li>round:Boolean – round the values on update (to an int)</li>
		 *	<li>update:Boolean – enable broadcasting of UPDATED event (can lower performance)</li>
		 *	<li>relative:Boolean – this overrides the number/string check on the value to set the value relative to the current value</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:Tween = new Tween(myobj, {property:'x', value:50, duration:2, ease:'easeInBounce', delay:2, position:0, round:false, relative:true, bezier:[60, '200, -10]})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	configObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function Tween($target:Object, $configObject:Object = null) {
			super($target, $configObject);
		}
		
		/**
		 *	<p>This let's you run a tween that's unmanaged and bypasses events, using just a callback function on end.</p>
		 *	<p>The syntax is just a strict function call, so there's no configObject.</p>
		 *	<p>While there's little speed improvement with this over creating an tween object, it does use about half the memory.</p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	property	The property to tween
		 *	@param	value	The new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code>
		 *	@param	duration	How long in seconds for the tween to last
		 *	@param	ease	The easing to use. Default is 'linear'. Can pass a Function, but will not work with XML
		 *	@param	position	The position to start the tween at. Defaults 0.
		 *	@param	endfunc	A function to call when the tween ends
		 *	
		 *	@return		The id of the PrimitiveTween
		 *	 
		 */
		public static function run($target:Object, $property:String, $value:*, $duration:Number, $ease:* = 'linear', $position:Number = 0, $endfunc:Function = null):int {
			return BasicTween.run($target, $property, $value, $duration, $ease, $position, $endfunc);
		}
		
		/**
		 *	This starts the tween. If the tween was previously stopped, this will resume it.
		 *	
		 *	@param	delay	 Overrides the tween's delay and uses the passed one.
		 *	@param	position	 Starts the tween at a given position 0-1.
		 *	
		 *	@return		The tween object (for chaining)
		 *	
		 */
		public override function start($delay:Number = -1, $position:Number = -1):* {
			if(!_completed && !active){
				_config.delay = ($delay == -1) ? _config.delay : $delay;
				if($position == -1){
					if(!isNaN(_pausepos)) _config.position = _pausepos;
				} else {
					_config.position = $position;
				}
				_config.position = ($position == -1) ? _config.position : $position;
				_active = true;
				dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
				if(_config.delay > 0) delayedTween(_config.delay);
				else _primitiveID = createPrimitive(_config);
				return this;
			} else {
				Debug.output('motion', 10005);
				return this;
			}
		}
		
		/**
		 *	This stops the currently playing tween at it's current position. Starting the tween will resume it.
		 *	
		 *	@return		True if could be stopped, false if the tween is not active or has ended.
		 */
		public override function stop():Boolean {
			if(!_completed){
				if(_primitiveID != 0){
					if(!_completed){
						setPauses();
					}
					BaseTicker.getItem(_primitiveID).end();
				} else {
					_delayTimer.stop();
					dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				}
				return true;
			} else {
				Debug.output('motion', 10004);
				return false;
			}
		}
		
		/**
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			var pt:PrimitiveTween;
			var ftv:Object = target[$to.property];
			var ntval:*;
			if(isNaN(_newval)){
				ntval = $to.value;
				if($to.relative === true) _newval = ftv + Number(ntval);
				else if($to.relative === false) _newval = Number(ntval);
				else _newval = (typeof ntval == 'string') ? ftv + Number(ntval) : ntval;
			}
			if($to.bezier == undefined || $to.bezier == null){
				pt = BaseTicker.addItem(PrimitiveTween);
				pt.init(target, $to.property, _newval, $to.duration*1000, makeEase($to.ease));
			} else {
				var newbez:Array = [];
				for (var i:int = 0; i < $to.bezier.length; i++) {
					newbez.push((typeof $to.bezier[i] == 'string') ? ftv + Number($to.bezier[i]) : $to.bezier[i]);
				}
				pt = BaseTicker.addItem(PrimitiveBezierTween);
				pt.init(target, $to.property, _newval, $to.duration*1000, newbez, makeEase($to.ease));
			}
			pt.endFunc = endFunc;
			if($to.position > 0) {
				pt.starttime -= ($to.position*$to.duration)*1000;
				if(!isNaN(_newval)) {
					if(!isNaN(_startvalue)) pt.startvalue = _startvalue;
					if(!isNaN(_difvalue)) pt.difvalue = _difvalue;
				}
				Debug.output('motion', 40007, [$to.position]);
			}
			pt.updateFunc = updateListener;
			return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected override function endFunc($o:Object):void {
			if($o.property != undefined){
				if($o.target[$o.property] == $o.value){
					_completed = true;
				}
			}
			super.endFunc($o);
		}
		
		/**
		 *	Resets the tween back to the beginning.
		 */
		public function reset():void {
			_pausepos = undefined;
			_newval = undefined;
			_difvalue = undefined;
			_startvalue = undefined;
			_completed = false;
			_config.position = 0;
		}
		
		/**
		 *	Gets the current position 0-1 of the tween. Does not include delay.
		 */
		public function get position():Number {
			if(_primitiveID != 0){
				var pt:PrimitiveTween = BaseTicker.getItem(_primitiveID);
				//var pos:Number = (pt.target[pt.property]-pt.startvalue)/(pt.value-pt.startvalue); //this is for ease pos
				var pos:Number = (getTimer()-pt.starttime)/pt.duration;
				return pos;
			} else if(_completed) return 1;
			else return 0;
		}
		
		/**
		 *	If the tween finished or not.
		 */
		public function get completed():Boolean{
			return _completed;
		}
		
		/**
		 *	@private
		 */
		protected function delayedTween($delay:Number):void {
			Debug.output('motion', 40002, [$delay]);
			_delayTimer = new Timer($delay*1000);
			_delayTimer.addEventListener(TimerEvent.TIMER, dtFunc, false, 0, false);
			_delayTimer.start();
		}
		
		/**
		 *	@private
		 */
		protected function dtFunc($i:Object):void {
			_delayTimer.removeEventListener(TimerEvent.TIMER, dtFunc);
			_delayTimer.stop();
			_delayTimer = null;
			_primitiveID = createPrimitive(_config);
		}
		
		/**
		 *	@private
		 */
		protected override function updateListener($i:Object):void {
			super.updateListener($i);
			if(_config.round) roundTweenValue($i);
		}
		
		/**
		 *	@private
		 */
		protected function roundTweenValue($i:Object):void {
			$i.target[$i.property] = int($i.target[$i.property]);
		}
		
		/**
		 *	@private
		 */
		protected function setPauses():void {
			_pausepos = position;
			_startvalue = BaseTicker.getItem(_primitiveID).startvalue;
			_difvalue = BaseTicker.getItem(_primitiveID).difvalue;
		}
	
	}

}
