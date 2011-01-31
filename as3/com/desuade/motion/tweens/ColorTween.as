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
	 *  Standard tween class to change the color of a DisplayObject.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.05.2009
	 */
	public class ColorTween extends MultiTween {
		
		/**
		 *	@private
		 */
		protected var _colorholder:Object;
		
		/**
		 *	@private
		 */
		protected var colorFunc:Function;
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>type:String – the type of color transformation to apply. Defaults to 'tint', see ColorHelper for more types.</li>
		 *	<li>amount:int – The amount of transform to apply. Depends on 'type'</li>
		 *	<li>value:* – the new (end) color. A string or hex is accepted - ie: <code>{value: '#ff0038}</code> or <code>{value:0xff883a}</code></li>
		 *	<li>ease:String – the easing to use. Default is 'linear'. Can pass a Function, but may not be fully compatable.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>delay:Number – how long in seconds to delay starting the tween</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	<li>update:Boolean – enable broadcasting of UPDATED event (can lower performance)</li>
		 *	<li>property:String – To tween a hex value instead of a DisplayObject, set this to the property</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:ColorTween = new ColorTween(myobj, {value:0xff77d5, amount:0.8, duration:2, ease:'easeInBounce', delay:2, position:0})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	configObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	BasicColorTween
		 *	@see	com.desuade.utils.ColorHelper#getColorObject()
		 *	
		 */
		public function ColorTween($target:Object, $configObject:Object = null) {
			super($target, $configObject);
		}
		
		/**
		 *	@private
		 */
		protected function docolorupdater():void {
			target.transform.colorTransform = new ColorTransform(_colorholder.redMultiplier, _colorholder.greenMultiplier, _colorholder.blueMultiplier, target.alpha, _colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
		
		/**
		 *	@private
		 */
		protected function hexcolorupdater():void {
			target[_config.property] = ColorHelper.RGBToHex(_colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
		
		/**
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			var pt:PrimitiveMultiTween;
			_colorholder = ($to.property != undefined && $to.property != null) ? ColorHelper.getColorObject('tint', 1, target[$to.property]) : target.transform.colorTransform;
			var cpo:Object = ColorHelper.getColorObject($to.type || 'tint', $to.amount || 1, $to.value, _colorholder);
			if(_newvals.length == 0){
				for (var p:String in cpo) {
					var ntval:*;
					ntval = cpo[p];
					_newvals.push(ntval);
				}	
			}
			pt = BaseTicker.addItem(PrimitiveMultiTween);
			pt.init(_colorholder, cpo, $to.duration*1000, makeEase($to.ease));
			pt.endFunc = endFunc;
			colorFunc = ($to.property != undefined && $to.property != null) ? hexcolorupdater : docolorupdater;
			if($to.position > 0) {
				pt.starttime -= ($to.position*$to.duration)*1000;
				if(_newvals.length > 0) {
					pt.arrayObject.startvalues = _startvalues;
					pt.arrayObject.difvalues = _difvalues;
				}
				Debug.output('motion', 40007, [$to.position]);
			}
			pt.updateFunc = updateListener;
			return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected override function updateListener($i:Object):void {
			super.updateListener($i);
			colorFunc();
		}
	
	}

}
