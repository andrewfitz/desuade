package com.desuade.partigen.utils {
/**
 *  Random is a class used to create a random value in a range of numbers, with the ability to specify the umber of decimal places.
 *    
 *  @langversion ActionScript 3
 *  @playerversion Flash 9.0.0
 *
 *  @author Andrew Fitzgerald
 *  @since  28.02.2009
 */
	public class Random extends Object {
		
		public var min:Number;
		public var max:Number;
		public var precision:Number;
		
		public function Random(min:Number, max:Number, precision:Number = 0):void {
			this.min = min;
			this.max = max;
			this.precision = precision;
		}
		
		public function get randomValue():Number{
			return fromRange(min, max, precision);
		}
		
		public static function fromRange(min:Number, max:Number, precision:Number = 0):Number {
			var dp:Number = Math.pow(10, precision);
			var rn:Number = ((Math.round(((min + (Math.random() * (max - min))) * dp))) / dp);
			return rn;
		}
	}
}