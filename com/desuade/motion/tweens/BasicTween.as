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
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			var newval:Number = (typeof $to.value == 'string') ? target[$to.property] + Number($to.value) : $to.value;
			var pt:PrimitiveTween = BaseTicker.addItem(new PrimitiveTween(target, $to.property, newval, $to.duration*1000, makeEase($to.ease)));
			pt.endFunc = endFunc;
			pt.updateFunc = updateListener;
			return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected function makeEase($ease:*):Function {
			if(typeof $ease == 'string') return Easing[$ease];
			else if(typeof $ease == 'function') return $ease;
			else return Easing.linear;
		}

	}

}
