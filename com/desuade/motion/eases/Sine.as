package com.desuade.motion.eases {
	
	/**
	 *  Easing equations using a "sine" easing.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Sine {
		
		/**
		 *	@private
		 */
		private static const _HALF_PI:Number = Math.PI / 2;
		
		/**
		* Generates sinusoidal easing in tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * Math.cos(t/d * _HALF_PI) + c + b;
		}
		
		/**
		* Generates sinusoidal easing out tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sin(t/d * _HALF_PI) + b;
		}
		
		/**
		* Generates sinusoidal easing in-out tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		}
		
		/**
		* Generates sinusoidal easing out-in tween where equation for motion is based on a sine or cosine function.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function easeOutIn(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d/2)<1) {
				return c/2*(Math.sin(Math.PI*t/2))+b;
			}
			return -c/2*(Math.cos(Math.PI*--t/2)-2)+b;
		}
	}
}