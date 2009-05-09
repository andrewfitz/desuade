package com.desuade.motion.eases {
	
	/**
	 *  Easing equations using a "quadratic" formula.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Quad {
		
		/**
		* Generates quadratic, or "normal" easing in tween where equation for motion is based on a squared variable.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t + b;
		}
		
		/**
		* Generates quadratic, or "normal" easing out tween where equation for motion is based on a squared variable.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return -c *(t/=d)*(t-2) + b;
		}
		
		/**
		* Generates quadratic, or "normal" easing in-out tween (two half tweens fused together) where equation for motion is based on a squared variable.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t + b;
			return -c/2 * ((--t)*(t-2) - 1) + b;
		}
	}
}