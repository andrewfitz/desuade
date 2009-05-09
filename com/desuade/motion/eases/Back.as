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
	public class Back {
		
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
