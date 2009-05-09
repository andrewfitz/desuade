package com.desuade.motion.eases {
	
	/**
	 *  This is a standard flat tween, with no easing.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public class Linear {
		
		/**
		* Generates linear tween with constant velocity and no acceleration.
		* @param t		time
		* @param b		beginning position
		* @param c		total change in position
		* @param d		duration of the tween
		* @return		position
		*/
		public static function none (t:Number, b:Number, c:Number, d:Number):Number {
			return c*t/d + b;
		}
	}
}