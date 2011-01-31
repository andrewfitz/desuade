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
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	import com.desuade.motion.bases.*;
	
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *  This creates a basic tween that changes a display object's color.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicColorTween extends BasicTween {
		
		/**
		 *	@private
		 */
		protected var _colorholder:Object;
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>type:String – the type of color transformation to apply. Defaults to 'tint', see ColorHelper for more types.</li>
		 *	<li>amount:int – The amount of transform to apply. Depends on 'type'</li>
		 *	<li>value:* – the new (end) color. A string or hex is accepted - ie: <code>{value: '#ff0038}</code> or <code>{value:0xff883a}</code></li>
		 *	<li>ease:String – the easing to use. Default is 'linear'. Can pass a Function, but may not be fully compatable.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>update:Boolean – enable broadcasting of UPDATED event (can lower performance)</li>
		 *	<li>property:String – To tween a hex value instead of a DisplayObject, set this to the property</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicColorTween = new BasicColorTween(myobj, {value:0xff77d5, amount:0.8, duration:2})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	configObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	com.desuade.utils.ColorHelper#getColorObject()
		 *	
		 */
		public function BasicColorTween($target:Object, $configObject:Object = null) {
			super($target, $configObject);
		}
		
		/**
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			_colorholder = ($to.property != undefined && $to.property != null) ? ColorHelper.getColorObject('tint', 1, target[$to.property]) : target.transform.colorTransform;
			var cpo:Object = ColorHelper.getColorObject($to.type || 'tint', $to.amount || 1, $to.value, _colorholder);
			var pt:PrimitiveMultiTween = BaseTicker.addItem(PrimitiveMultiTween);
			pt.init(_colorholder, cpo, $to.duration*1000, makeEase($to.ease));
			pt.endFunc = endFunc;
			pt.updateFunc = ($to.property != undefined && $to.property != null) ? hexcolorupdater : docolorupdater;
			if($to.position > 0) {
				pt.starttime -= ($to.position*$to.duration)*1000;
				Debug.output('motion', 40007, [$to.position]);
			}
			return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected function docolorupdater($o:Object):void {
			target.transform.colorTransform = new ColorTransform(_colorholder.redMultiplier, _colorholder.greenMultiplier, _colorholder.blueMultiplier, target.alpha, _colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
		
		/**
		 *	@private
		 */
		protected function hexcolorupdater($o:Object):void {
			target[_config.property] = ColorHelper.RGBToHex(_colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
	
	}

}
