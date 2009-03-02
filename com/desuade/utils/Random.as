package com.desuade.utils {

	public class Random extends Object {
		
		public var min:Number;
		public var max:Number;
		public var precision:int;
		
		public function Random($min:Number, $max:Number, $precision:int = 0):void {
			min = $min;
			max = $max;
			precision = $precision;
		}
		
		public function get randomValue():Number{
			return fromRange(min, max, precision);
		}
		
		public static function fromRange($min:Number, $max:Number, $precision:int = 0):Number {
			var dp:Number = Math.pow(10, $precision);
			var rn:Number = ((Math.round((($min + (Math.random() * ($max - $min))) * dp))) / dp);
			return rn;
		}
	}
}