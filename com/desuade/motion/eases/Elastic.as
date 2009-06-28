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
	 *  Easing equations that simulate an "elastic" motion.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Elastic extends Ease {
		
		/**
		 *	@private
		 */
		private static const _2PI:Number = Math.PI * 2;
		
		/**
		* Generates elastic easing in tween where equation for motion is based on Hooke's Law of <code>F = -kd</code>.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param a		(optional) amplitude, or magnitude of wave's oscillation
		* @param p		(optional) period
		* @return		position
		*/
		public static function easeIn (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (!a || a < Math.abs(c)) { a=c; s = p/4; }
			else s = p/_2PI * Math.asin (c/a);
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
		}
		
		/**
		* Generates elastic easing out tween where equation for motion is based on Hooke's Law of <code>F = -kd</code>.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param a		(optional) amplitude, or magnitude of wave's oscillation
		* @param p		(optional) period
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (!a || a < Math.abs(c)) { a=c; s = p/4; }
			else s = p/_2PI * Math.asin (c/a);
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*_2PI/p ) + c + b);
		}
		
		/**
		* Generates elastic easing in-out tween where equation for motion is based on Hooke's Law of <code>F = -kd</code>.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param a		(optional) amplitude, or magnitude of wave's oscillation
		* @param p		(optional) period
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
			if (!a || a < Math.abs(c)) { a=c; s = p/4; }
			else s = p/_2PI * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )*.5 + c + b;
		}
		
		/**
		* Generates elastic easing out-in tween where equation for motion is based on Hooke's Law of <code>F = -kd</code>.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param a		(optional) amplitude, or magnitude of wave's oscillation
		* @param p		(optional) period
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (t == 0) {
				return b;
			}
			if ((t /= d/2) == 2) {
				return b+c;
			}
			if (!p) {
				p = d*(.3*1.5);
			}
			if (!a || a<Math.abs(c)) {
				a = c;
				s = p/4;
			} else {
				s = p/(2*Math.PI)*Math.asin(c/a);
			}
			if (t<1) {
				return .5*(a*Math.pow(2, -10*t)*Math.sin((t*d-s)*(2*Math.PI)/p))+c/2+b;
			}
			return c/2+.5*(a*Math.pow(2, 10*(t-2))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;
		}
	}
}