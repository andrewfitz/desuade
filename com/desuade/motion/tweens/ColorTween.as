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
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
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
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>target:Object – an object to have it's property tweened</li>
		 *	<li>type:String – the type of color transformation to apply. Defaults to 'tint', see ColorHelper for more types.</li>
		 *	<li>amount:int – The amount of transform to apply. Depends on 'type'</li>
		 *	<li>value:* – the new (end) color. A string or hex is accepted - ie: <code>{value: '#ff0038}</code> or <code>{value:0xff883a}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>delay:Number – how long in seconds to delay starting the tween</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:ColorTween = new ColorTween({target:myobj, value:0xff77d5, amount:0.8, duration:2, ease:Bounce.easeIn, delay:2, position:0})</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	BasicColorTween
		 *	@see	com.desuade.utils.ColorHelper#getColorObject()
		 *	
		 */
		public function ColorTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		/**
		 *	<p>This is a static method that creates and starts a tween with a strict syntax.</p>
		 *	
		 *	@param	target	an object to have it's property tweened
		 *	@param	value	 the new (end) color. A string or hex is accepted - ie: <code>{value: '#ff0038}</code> or <code>{value:0xff883a}</code>
		 *	@param	duration	how long in seconds for the tween to last
		 *	@param	ease	the easing function to use. Default is Linear.none.
		 *	@param	delay	how long in seconds to delay starting the tween
		 *	@param	type	 the type of color transformation to apply. Defaults to 'tint', see ColorHelper for more types.
		 *	@param	amount	 The amount of transform to apply. Depends on 'type'.
		 *	@param	position	what position to start the tween at 0-1
		 *	
		 *	<p>example: ColorTween.tween(myobj, '#ff0055', 2.5, null, 0, 'tint', 1, 0)</p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	BasicColorTween
		 *	@see	com.desuade.utils.ColorHelper#getColorObject()
		 *	
		 */
		public static function tween($target:Object, $value:*, $duration:Number, $ease:Function = null, $delay:Number = 0, $type:String = 'tint', $amount:Number = 1, $position:Number = 0):ColorTween {
			var st:ColorTween = new ColorTween({target:$target, value:$value, duration:$duration, ease:$ease, delay:$delay, type:$type, amount:$amount, position:$position});
			st.start();
			return st;
		}
		
		/**
		 *	@private
		 */
		protected function colorupdater($o:Object):void {
			_tweenconfig.target.transform.colorTransform = new ColorTransform(_colorholder.redMultiplier, _colorholder.greenMultiplier, _colorholder.blueMultiplier, _tweenconfig.target.alpha, _colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
		
		/**
		 *	@private
		 */
		protected override function createTween($to:Object):int {
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				var pt:PrimitiveMultiTween;
				_colorholder = $to.target.transform.colorTransform;
				var cpo:Object = ColorHelper.getColorObject($to.type || 'tint', $to.amount || 1, $to.value, _colorholder);
				if(_newvals.length == 0){
					for (var p:String in cpo) {
						var ntval:*;
						if(cpo[p] is RandomColor) ntval = cpo[p].randomValue;
						else ntval = cpo[p];
						_newvals.push(ntval);
					}	
				}
				pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween(_colorholder, cpo, $to.duration*1000, $to.ease);
				pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
				pt.addEventListener(TweenEvent.UPDATED, colorupdater, false, 0, true);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(_newvals.length > 0) {
						pt.arrayObject.startvalues = _startvalues;
						pt.arrayObject.difvalues = _difvalues;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATED, updateListener, false, 0, true);
				if($to.round) addEventListener(TweenEvent.UPDATED, roundTweenValue, false, 0, true);
				return pt.id;
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():* {
			return new ColorTween(duplicateConfig());
		}
	
	}

}
