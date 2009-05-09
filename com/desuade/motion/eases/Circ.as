package com.desuade.motion.eases {
	
	/**
	 *  Easing equations using a "circular" easing.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Circ {
		
		/**
		* Generates circular easing in tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
		}
		
		/**
		* Generates circular easing out tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
		}
		
		/**
		* Generates circular easing in-out tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
		}
		
		/**
		* Generates circular easing out-in tween where equation for motion is based on the equation for half of a circle, which uses a square root.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d/2)<1) {
				return c/2*Math.sqrt(1- --t*t)+b;
			}
			return c/2*(2-Math.sqrt(1- --t*t))+b;
		}
	}
}