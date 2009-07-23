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

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *  This creates a BasicTween, but accepts a parameters object that can contain many properties and values.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicMultiTween extends BasicTween {
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>properties:Object – an object of properties and values to tween. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{x:100}</code> or <code>{y:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicMultiTween = new BasicMultiTween(myobj, {properties:{x:200, y:'50', alpha:0.5}, duration:2, ease:Bounce.easeIn})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	tweenObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function BasicMultiTween($target:Object, $tweenObject:Object) {
			super($target, $tweenObject);
		}
		
		/**
		 *	@private
		 */
		protected override function createTween($to:Object):int {
			for (var p:String in $to.properties) {
				$to.properties[p] = (typeof $to.properties[p] == 'string') ? target[p] + Number($to.properties[p]) : $to.properties[p];
			}
			var pt:PrimitiveMultiTween = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween(target, $to.properties, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
			return pt.id;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone($target:Object):* {
			return new BasicMultiTween($target, duplicateConfig());
		}

	}

}
