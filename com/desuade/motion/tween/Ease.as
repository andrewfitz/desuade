
/*
* Easings - From the Fuse Kit, written by Robert Penner
* http://www.mosessupposes.com/Fuse/
* http://www.robertpenner.com/easing_terms_of_use.html | license.txt
* 
*/

package com.desuade.motion.tween {
	
	public class Ease {

		/**
		* Generates linear tween with constant velocity and no acceleration.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function linear(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*t/d+b;
		}

		/**
		* Generates quadratic, or "normal" easing in tween where equation for motion is based on a squared variable.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInQuad(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*(t /= d)*t+b;
		}

		/**
		* Generates quadratic, or "normal" easing out tween where equation for motion is based on a squared variable.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutQuad(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return -c*(t /= d)*(t-2)+b;
		}

		/**
		* Generates quadratic, or "normal" easing in-out tween (two half tweens fused together) where equation for motion is based on a squared variable.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutQuad(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*t*t+b;
			}
			return -c/2*((--t)*(t-2)-1)+b;
		}

		/**
		* Generates exponential (sharp curve) easing in tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInExpo(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return (t == 0) ? b : c*Math.pow(2, 10*(t/d-1))+b;
		}

		/**
		* Generates exponential (sharp curve) easing out tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutExpo(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return (t == d) ? b+c : c*(-Math.pow(2, -10*t/d)+1)+b;
		}

		/**
		* Generates exponential (sharp curve) easing in-out tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutExpo(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if (t == 0) {
				return b;
			}
			if (t == d) {
				return b+c;
			}
			if ((t /= d/2)<1) {
				return c/2*Math.pow(2, 10*(t-1))+b;
			}
			return c/2*(-Math.pow(2, -10*--t)+2)+b;
		}

		/**
		* Generates exponential (sharp curve) easing out-in tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInExpo(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if (t == 0) {
				return b;
			}
			if (t == d) {
				return b+c;
			}
			if ((t /= d/2)<1) {
				return c/2*(-Math.pow(2, -10*t)+1)+b;
			}
			return c/2*(Math.pow(2, 10*(t-2))+1)+b;
		}

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
		public static function easeInElastic(t:Number, b:Number, c:Number, d:Number, a:Number, p:Number, ... extras):Number {
			var s:Number;
			if (t == 0) {
				return b;
			}
			if ((t /= d) == 1) {
				return b+c;
			}
			if (!p) {
				p = d*.3;
			}
			if (!a || a<Math.abs(c)) {
				a = c;
				s = p/4;
			} else {
				s = p/(2*Math.PI)*Math.asin(c/a);
			}
			return -(a*Math.pow(2, 10*(t -= 1))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;
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
		public static function easeOutElastic(t:Number, b:Number, c:Number, d:Number, a:Number, p:Number, ... extras):Number {
			var s:Number;
			if (t == 0) {
				return b;
			}
			if ((t /= d) == 1) {
				return b+c;
			}
			if (!p) {
				p = d*.3;
			}
			if (!a || a<Math.abs(c)) {
				a = c;
				s = p/4;
			} else {
				s = p/(2*Math.PI)*Math.asin(c/a);
			}
			return (a*Math.pow(2, -10*t)*Math.sin((t*d-s)*(2*Math.PI)/p)+c+b);
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
		public static function easeInOutElastic(t:Number, b:Number, c:Number, d:Number, a:Number, p:Number, ... extras):Number {
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
				return -.5*(a*Math.pow(2, 10*(t -= 1))*Math.sin((t*d-s)*(2*Math.PI)/p))+b;
			}
			return a*Math.pow(2, -10*(t -= 1))*Math.sin((t*d-s)*(2*Math.PI)/p)*.5+c+b;
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
		public static function easeOutInElastic(t:Number, b:Number, c:Number, d:Number, a:Number, p:Number, ... extras):Number {
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

		/**
		* Generates tween where target backtracks slightly, then reverses direction and moves to position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @param s		(optional) controls amount of overshoot, with higher value yielding greater overshoot.
		* @return		position
		*/
		public static function easeInBack(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158, ... extras):Number {
			return c*(t /= d)*t*((s+1)*t-s)+b;
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
		public static function easeOutBack(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158, ... extras):Number {
			return c*((t=t/d-1)*t*((s+1)*t+s)+1)+b;
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
		public static function easeInOutBack(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*(t*t*(((s *= (1.525))+1)*t-s))+b;
			}
			return c/2*((t -= 2)*t*(((s *= (1.525))+1)*t+s)+2)+b;
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
		public static function easeOutInBack(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*(--t*t*(((s *= (1.525))+1)*t+s)+1)+b;
			}
			return c/2*(--t*t*(((s *= (1.525))+1)*t-s)+1)+b;
		}

		/**
		* Generates easing out tween where target bounces before reaching final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutBounce(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d)<(1/2.75)) {
				return c*(7.5625*t*t)+b;
			} else if (t<(2/2.75)) {
				return c*(7.5625*(t -= (1.5/2.75))*t+.75)+b;
			} else if (t<(2.5/2.75)) {
				return c*(7.5625*(t -= (2.25/2.75))*t+.9375)+b;
			} else {
				return c*(7.5625*(t -= (2.625/2.75))*t+.984375)+b;
			}
		}

		/**
		* Generates easing in tween where target bounces upon entering the animation and then accelarates towards its final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInBounce(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c-easeOutBounce(d-t, 0, c, d)+b;
		}

		/**
		* Generates easing in-out tween where target bounces upon entering the animation and then accelarates towards its final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutBounce(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if (t<d/2) {
				return easeInBounce(t*2, 0, c, d)*.5+b;
			} else {
				return easeOutBounce(t*2-d, 0, c, d)*.5+c*.5+b;
			}
		}

		/**
		* Generates easing out-in tween where target bounces upon entering the animation and then accelarates towards its final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInBounce(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if (t<d/2) {
				return easeOutBounce(t*2, 0, c, d)*.5+b;
			}
			return easeInBounce(t*2-d, 0, c, d)*.5+c*.5+b;
		}

		/**
		* Generates cubic easing in tween where equation for motion is based on the power of three and is a bit more curved than a quadratic ease.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInCubic(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*(t /= d)*t*t+b;
		}

		/**
		* Generates cubic easing out tween where equation for motion is based on the power of three and is a bit more curved than a quadratic ease.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutCubic(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*((t=t/d-1)*t*t+1)+b;
		}

		/**
		* Generates cubic easing in-out tween where equation for motion is based on the power of three and is a bit more curved than a quadratic ease.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutCubic(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*t*t*t+b;
			}
			return c/2*((t -= 2)*t*t+2)+b;
		}

		/**
		* Generates cubic easing out-in tween where equation for motion is based on the power of three and is a bit more curved than a quadratic ease.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInCubic(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			t /= d/2;
			return c/2*(--t*t*t+1)+b;
		}

		/**
		* Generates quartic easing in tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInQuart(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*(t /= d)*t*t*t+b;
		}

		/**
		* Generates quartic easing out tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutQuart(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return -c*((t=t/d-1)*t*t*t-1)+b;
		}

		/**
		* Generates quartic easing in-out tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutQuart(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*t*t*t*t+b;
			}
			return -c/2*((t -= 2)*t*t*t-2)+b;
		}

		/**
		* Generates quartic easing out-in tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInQuart(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return -c/2*(--t*t*t*t-1)+b;
			}
			return c/2*(--t*t*t*t+1)+b;
		}

		/**
		* Generates quartic easing in tween where equation for motion is based on the power of five and motion starts slow and becomes quite fast in what appears to be a fairly pronounced curve.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInQuint(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*(t /= d)*t*t*t*t+b;
		}

		/**
		* Generates quartic easing out tween where equation for motion is based on the power of five and motion starts slow and becomes quite fast in what appears to be a fairly pronounced curve.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutQuint(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*((t=t/d-1)*t*t*t*t+1)+b;
		}

		/**
		* Generates quartic easing in-out tween where equation for motion is based on the power of five and motion starts slow and becomes quite fast in what appears to be a fairly pronounced curve.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutQuint(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*t*t*t*t*t+b;
			}
			return c/2*((t -= 2)*t*t*t*t+2)+b;
		}

		/**
		* Generates quartic easing out-in tween where equation for motion is based on the power of five and motion starts slow and becomes quite fast in what appears to be a fairly pronounced curve.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInQuint(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			t /= d/2;
			return c/2*(--t*t*t*t*t+1)+b;
		}

		/**
		* Generates sinusoidal easing in tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInSine(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return -c*Math.cos(t/d*(Math.PI/2))+c+b;
		}

		/**
		* Generates sinusoidal easing out tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutSine(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*Math.sin(t/d*(Math.PI/2))+b;
		}

		/**
		* Generates sinusoidal easing in-out tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutSine(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return -c/2*(Math.cos(Math.PI*t/d)-1)+b;
		}

		/**
		* Generates sinusoidal easing out-in tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInSine(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*(Math.sin(Math.PI*t/2))+b;
			}
			return -c/2*(Math.cos(Math.PI*--t/2)-2)+b;
		}

		/**
		* Generates circular easing in tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInCirc(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return -c*(Math.sqrt(1-(t /= d)*t)-1)+b;
		}

		/**
		* Generates circular easing out tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutCirc(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			return c*Math.sqrt(1-(t=t/d-1)*t)+b;
		}

		/**
		* Generates circular easing in-out tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOutCirc(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return -c/2*(Math.sqrt(1-t*t)-1)+b;
			}
			return c/2*(Math.sqrt(1-(t -= 2)*t)+1)+b;
		}

		/**
		* Generates circular easing out-in tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutInCirc(t:Number, b:Number, c:Number, d:Number, ... extras):Number {
			if ((t /= d/2)<1) {
				return c/2*Math.sqrt(1- --t*t)+b;
			}
			return c/2*(2-Math.sqrt(1- --t*t))+b;
		}
	}
	 
}