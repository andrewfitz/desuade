package com.desuade.motion.eases {
	
	/**
	 *  Easing equations using an exponential formula.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Expo {
		
		/**
		* Generates exponential (sharp curve) easing in tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
		}
		
		/**
		* Generates exponential (sharp curve) easing out tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
		
		/**
		* Generates exponential (sharp curve) easing in-out tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
			return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		/**
		* Generates exponential (sharp curve) easing out-in tween where equation for motion is based on the number 2 raised to a multiple of 10.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number):Number {
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
	}
}