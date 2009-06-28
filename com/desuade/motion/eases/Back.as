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

package com.desuade.motion.eases {
	
	/**
	 *  Easing equations for "Back".
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Back extends Ease {
		
		/**
		* Generates tween where target backtracks slightly, then reverses direction and moves to position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param s		(optional) controls amount of overshoot, with higher value yielding greater overshoot.
		* @return		position
		*/
		public static function easeIn (t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return c*(t/=d)*t*((s+1)*t - s) + b;
		}
		
		/**
		* Generates tween where target moves and overshoots final position, then reverse direction to reach final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param s		(optional) controls amount of overshoot, with higher value yielding greater overshoot.
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
		}
		/**
		* Generates tween where target backtracks slightly, then reverses direction towards final position, overshoots final position, then ultimately reverses direction to reach final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param s		(optional) controls amount of overshoot, with higher value yielding greater overshoot.
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
			return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
		}
		
		/**
		* Generates tween where target moves towards and overshoots final position, then ultimately reverses direction to reach its beginning position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param s		(optional) controls amount of overshoot, with higher value yielding greater overshoot.
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			if ((t /= d/2)<1) return c/2*(--t*t*(((s *= (1.525))+1)*t+s)+1)+b;
			return c/2*(--t*t*(((s *= (1.525))+1)*t-s)+1)+b;
		}
	}
}
