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
	
	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	/**
	 *  This is a PrimitiveTween that also has bezier points, used by the Tween class to create bezier tweens.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class PrimitiveBezierTween extends PrimitiveTween {
		
		/**
		 *	The array that contains all the bezier points for the tween.
		 */
		public var bezier:Array;
		
		/**
		 *	This creates a new, raw PrimitiveTween. Users should use the Tween class, instead of creating this directly.
		 */
		public function PrimitiveBezierTween() {
			super();
		}
		
		/**
		 *	This inits the PrimitiveBezierTween.
		 *	
		 *	@param	target	 The target object to perform the tween on.
		 *	@param	property	 The property to tween on the target.
		 *	@param	value	 The new (end) value the property will be tweened to.
		 *	@param	duration	 How long the tween will last in ms.
		 *	@param	bezier	 An array of points to create a bezier curve with.
		 *	@param	ease	 What easing equation to use to tween.
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#bezier
		 *	@see	PrimitiveTween#ease
		 */
		public override function init(... args):void {
			super.init(args[0], args[1], args[2], args[3], args[5]);
			bezier = args[4];
		}
		
		/**
		 *	This renders the tween. It calculates and sets the new value, and checks to see if the tween is finished.
		 *	
		 *	@param	time	 The current getTimer() time.
		 */
		public override function render($time:int):void {
			$time -= starttime;
			if($time >= duration){
				target[property] = value;
				updateFunc(this);
				end();
			} else {
				var nres:Number;
				var res:Number = ease($time, startvalue, difvalue, duration);
				var easeposition:Number = (res-startvalue)/(value-startvalue);
				if(bezier.length == 1) {
					nres = startvalue + (easeposition*(2*(1-easeposition)*(bezier[0]-startvalue)+(easeposition*difvalue)));
				} else {
					var b1:Number, b2:Number;
					var bpos:Number = int(easeposition*bezier.length);
					var ipos:Number = (easeposition-(bpos*(1/bezier.length)))*bezier.length;
					if (bpos == 0){
						b1 = startvalue;
						b2 = (bezier[0]+bezier[1])*.5;
					} else if (bpos == bezier.length-1){
						b1 = (bezier[bpos-1]+bezier[bpos])*.5;
						b2 = value;
					} else{
						b1 = (bezier[bpos-1]+bezier[bpos])*.5;
						b2 = (bezier[bpos]+bezier[bpos+1])*.5;
					}
					nres = b1+ipos*(2*(1-ipos)*(bezier[bpos]-b1) + ipos*(b2 - b1));
				}
				target[property] = nres;
				updateFunc(this);
				//dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {primitiveTween:this}));
			}
		}
	
	}

}
