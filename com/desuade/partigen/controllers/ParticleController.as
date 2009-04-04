package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.utils.*
	import com.desuade.partigen.particles.*

	public dynamic class ParticleController extends Object {
		
		protected var _life:Object = {value:0, spread:0};
	
		public function ParticleController() {
			super();
		}
		
		public function get life():Object{
			return _life;
		}
		
		public function addBasic($prop:String, $start:*, $end:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ParticleValueController = this[$prop] = new ParticleValueController($duration, $precision);
			tp.points.beginning.value = $start;
			tp.points.end.value = $end;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		protected function randomLife():Number{
			return (_life.spread != 0) ? Random.fromRange(_life.value, _life.spread, 2) : _life.value;
		}
		
		protected function attachController($particle:Particle, $prop:String):void {
			$particle.controllers[$prop] = new ValueController($particle, $prop, (this[$prop].duration == 0) ? $particle.life : this[$prop].duration, this[$prop].precision);
			$particle.controllers[$prop].points = this[$prop].points;
		}
		
		public function attachAll($particle:Particle):void {
			if(_life.value > 0) $particle.addLife(randomLife());
			for (var p:String in this) {
				attachController($particle, p);
			}
		}
	
	}

}
