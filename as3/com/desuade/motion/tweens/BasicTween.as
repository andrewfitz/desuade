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

	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import com.desuade.utils.XMLHelper;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.*;
	import com.desuade.motion.eases.*;
	import com.desuade.motion.bases.*;
	
	/**
	 *  A very basic tween that allows you to tween a given value on any object to a new value.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicTween extends BaseBasic {
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the configObject:</p>
		 *	<ul>
		 *	<li>property:String – the property to tween</li>
		 *	<li>value:* – the new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code></li>
		 *	<li>ease:String – the easing to use. Default is 'linear'. Can pass a Function, but will not work with XML.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	<li>update:Boolean – enable broadcasting of UPDATED event (can lower performance)</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicTween = new BasicTween(myobj, {property:'x', value:.5, duration:2, ease:'easeInBounce'})</code></p>
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
		public function BasicTween($target:Object, $configObject:Object = null) {
			super($target, $configObject);
			_eventClass = TweenEvent;
			Debug.output('motion', 40001);
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
			var newval:Number = (typeof $value == 'string') ? $target[$property] + Number($value) : $value;
			var pt:PrimitiveTween = BaseTicker.addItem(PrimitiveTween);
			pt.init($target, $property, newval, $duration*1000, makeEase($ease));
			pt.endFunc = function():void {
				if($endfunc != null) $endfunc();
				BaseTicker.removeItem(pt.id);
			}
			if($position > 0) {
				pt.starttime -= ($position*$duration)*1000;
				Debug.output('motion', 40007, [$position]);
			}
			BaseTicker.start();
			return pt.id;
			//if the target object isn't found, we should kill the tween... catch?
		}
		
		/**
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			var newval:Number = (typeof $to.value == 'string') ? target[$to.property] + Number($to.value) : $to.value;
			var pt:PrimitiveTween = BaseTicker.addItem(PrimitiveTween);
			pt.init(target, $to.property, newval, $to.duration*1000, makeEase($to.ease));
			pt.endFunc = endFunc;
			pt.updateFunc = updateListener;
			if($to.position > 0) {
				pt.starttime -= ($to.position*$to.duration)*1000;
				Debug.output('motion', 40007, [$to.position]);
			}
			return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected static function makeEase($ease:*):Function {
			if(typeof $ease == 'string') return Easing[$ease];
			else if(typeof $ease == 'function') return $ease;
			else return Easing.linear;
		}

	}

}
