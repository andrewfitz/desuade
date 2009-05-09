package com.desuade.motion.eases {
	
	/**
	 *  Easing equations that simulate a "bounce".
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Bounce {
		
		/**
		* Generates easing out tween where target bounces before reaching final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d) < (1/2.75)) {
				return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
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
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c - easeOut(d-t, 0, c, d) + b;
		}
		
		/**
		* Generates easing in-out tween where target bounces upon entering the animation and then accelarates towards its final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeIn (t*2, 0, c, d) * .5 + b;
			else return easeOut (t*2-d, 0, c, d) * .5 + c*.5 + b;
		}
		
		/**
		* Generates easing out-in tween where target bounces upon entering the animation and then accelarates towards its final position.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number):Number {
			if (t<d/2) {
				return easeOut(t*2, 0, c, d)*.5+b;
			}
			return easeIn(t*2-d, 0, c, d)*.5+c*.5+b;
		}
	}
}