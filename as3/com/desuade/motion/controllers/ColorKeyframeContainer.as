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

package com.desuade.motion.controllers {

	import com.desuade.debugging.*
	import com.desuade.motion.tweens.*
	import com.desuade.motion.eases.*
	import com.desuade.utils.*
	
	import flash.geom.ColorTransform;
	
	/**
	 *  Manages and hold keyframes specifically for color-tweening.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class ColorKeyframeContainer extends KeyframeContainer {
		
		/**
		 *	<p>Creates a new ColorKeyframeContainer. This is the core of a MotionController, as it holds, configures, and manages all keyframes, and generates the tween objects.</p>
		 *	
		 *	<p>This works the same as a regular KeyframeContainer, except it's internals are specific for color-tweening.</p>
		 *	
		 *	<p>This can be created independently of a controller and shared among multiple ones.</p>
		 *	
		 *	@param	tweenClass	 The class of tweening engine to use for color. Null will use the default colorTweenClass from the MotionController static class.
		 */
		public function ColorKeyframeContainer($tweenClass:Class = null) {
			super(($tweenClass != null) ? $tweenClass : MotionController.colorTweenClass);
			this['begin'].extras = {type:null, amount:null};
			this['end'].extras = {type:null, amount:null};
			this['begin'].value = 'none';
			this['end'].value = 'none';
		}
		
		/**
		 *	@private
		 */
		internal override function generateStartValue($target:Object, $property:String, $keyframe:String):* {
			var nv:*;
			var bkf:Keyframe = this[$keyframe];
			var nt:String = bkf.extras.type;
			if(bkf.value != null && bkf.value != 'none'){
				nv = (bkf.spread != '0') ? RandomColor.fromRange(bkf.value, bkf.spread) : bkf.value;	
			} else nt = 'clear';
			return ColorHelper.getColorObject(nt || 'tint', bkf.extras.amount || 1, nv, ($property == null) ? $target.transform.colorTransform : null);
		}
		
		/**
		 *	@private
		 */
		internal override function setStartValue($target:Object, $property:String, $keyframe:String, $sequence:Array = null):void {
			var nvo:Object = generateStartValue($target, $property, $keyframe);
			if($property == null){
				$target.transform.colorTransform = new ColorTransform(nvo.redMultiplier, nvo.greenMultiplier, nvo.blueMultiplier, $target.alpha, nvo.redOffset, nvo.greenOffset, nvo.blueOffset);
			} else {
				$target[$property] = ColorHelper.RGBToHex(nvo.redOffset, nvo.greenOffset, nvo.blueOffset);
			}
		}
		
		/**
		 *	@private
		 */
		internal override function createTweens($target:Object, $property:String, $duration:Number):Array {
			var pa:Array = getOrderedLabels();
			var ta:Array = [];
			//skip begin point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = this[pa[i]];
				var nv:*;
				if(np.value == 'none' && np.extras.type == 'tint'){
					np.extras.type = 'clear';
				} else {
					var nuv:*;
					if(np.value == null){
						if($property == null){
							var tc:* = $target.transform.colorTransform.color;
							if(tc == 0){
								nuv = null;
								np.extras.type = 'clear';
							} else {
								nuv = tc;
							}
						} else {
							nuv = $target[$property];
						}
					} else nuv = np.value;
					nv = (np.spread != '0') ? RandomColor.fromRange(nuv, np.spread) : nuv;
				}
				var tmo:Object = {target:$target, property:$property, value:nv, ease:np.ease, duration:calculateDuration($duration, this[pa[i-1]].position, np.position), delay:0};
				for (var h:String in np.extras) {
					tmo[h] = np.extras[h];
				}
				ta.push(tmo);
			}
			return ta;
		}
		
	}

}