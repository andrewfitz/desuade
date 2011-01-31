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

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import com.desuade.utils.XMLHelper;
	import com.desuade.motion.bases.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.*;

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
		 *	<li>ease:String – the easing to use. Default is 'linear'. Can pass a Function, but may not be fully compatable.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>update:Boolean – enable broadcasting of UPDATED event (can lower performance)</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicMultiTween = new BasicMultiTween(myobj, {properties:{x:200, y:'50', alpha:0.5}, duration:2, ease:'easeInBounce'})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	configObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function BasicMultiTween($target:Object, $configObject:Object = null) {
			super($target, $configObject);
		}
		
		/**
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			var npo:Object = {};
			for (var p:String in $to.properties) {
				npo[p] = (typeof $to.properties[p] == 'string') ? target[p] + Number($to.properties[p]) : $to.properties[p];
			}
			var pt:PrimitiveMultiTween = BaseTicker.addItem(PrimitiveMultiTween);
			pt.init(target, npo, $to.duration*1000, makeEase($to.ease));
			pt.endFunc = endFunc;
			pt.updateFunc = updateListener;
			if($to.position > 0) {
				pt.starttime -= ($to.position*$to.duration)*1000;
				Debug.output('motion', 40007, [$to.position]);
			}
			return pt.id;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function toXML():XML {
			var txml:XML = super.toXML();
			delete txml.@properties;
			for (var r:String in _config.properties) {
				txml.prependChild(<property />);
				txml.property[0].@name = r;
				txml.property[0].@value = XMLHelper.xmlize(_config.properties[r]);
			}
			return txml;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function fromXML($xml:XML):* {
			super.fromXML($xml);
			var cd:XMLList = $xml.children();
			var po:Object = {};
			for (var i:int = 0; i < cd.length(); i++) {
				po[cd[i].@name] = XMLHelper.dexmlize(cd[i].@value);
			}
			_config.properties = po;
			return this;
		}

	}

}
