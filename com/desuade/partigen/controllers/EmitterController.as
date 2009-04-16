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
		
		public function addStartValue($prop:String, $value:*, $spread:* = '0', $precision:int = 2):void {
			var tp:ValueController = this[$prop] = new ValueController(_emitter, $prop, 0, $precision);
			tp.points.begin.value = $value;
			tp.points.begin.spread = $spread;
			tp.points.end.value = null;
			tp.points.end.spread = '0';
		}
		
		public function addBasicTween($prop:String, $start:*, $startSpread:*, $end:*, $endSpread:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ValueController = this[$prop] = new ValueController(_emitter, $prop, $duration, $precision);
			tp.points.begin.value = $start;
			tp.points.end.value = $end;
			tp.points.begin.spread = $startSpread;
			tp.points.end.spread = $endSpread;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		public function addBasicPhysics($prop:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false, $duration:Number = 0):void {
			this[$prop] = new PhysicsValueController(_emitter, $prop, $duration, $velocity, $acceleration, $friction, $angle, $flip);
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
