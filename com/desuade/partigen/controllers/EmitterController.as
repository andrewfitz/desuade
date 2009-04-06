package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.utils.*
	import com.desuade.partigen.emitters.*

	public dynamic class EmitterController extends Object {
		
		protected var _emitter:Emitter;
			
		public function EmitterController($emitter:Emitter) {
			super();
			_emitter = $emitter;
		}
		
		public function addBasic($prop:String, $start:*, $end:*, $ease:*, $duration:Number, $precision:int = 2):void {
			var tp:ValueController = this[$prop] = new ValueController(_emitter, $prop, $duration, $precision);
			tp.points.begin.value = $start;
			tp.points.end.value = $end;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		public function startAll():void {
			for (var p:String in this) {
				this[p].start();
			}
		}
		
		public function stopAll():void {
			for (var p:String in this) {
				this[p].stop();
			}
		}
	
	}

}
