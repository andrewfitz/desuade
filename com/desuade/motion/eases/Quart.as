package com.desuade.motion.eases {
	
	/**
	 *  Easing equations using a "quartic" formula using power of 4.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Quart {
		
		/**
		* Generates quartic easing in tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t*t + b;
		}
		
		/**
		* Generates quartic easing out tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * ((t=t/d-1)*t*t*t - 1) + b;
		}
		
		/**
		* Generates quartic easing in-out tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
			return -c/2 * ((t-=2)*t*t*t - 2) + b;
		}
		
		/**
		* Generates quartic easing out-in tween where equation for motion is based on the power of four and feels a bit "other-worldly" as the acceleration becomes more exaggerated.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d/2)<1) {
				return -c/2*(--t*t*t*t-1)+b;
			}
			return c/2*(--t*t*t*t+1)+b;
		}
	}
}