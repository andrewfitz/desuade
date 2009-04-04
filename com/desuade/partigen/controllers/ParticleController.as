package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.utils.*
	import com.desuade.partigen.particles.*

	public dynamic class ParticleController extends Object {
		
		protected var _life:Number = 0;
		protected var _lifeSpread:Number = 0;
	
		public function ParticleController() {
			super();
		}
		
		public function addBasic($prop:String, $start:*, $end:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ParticleValueController = this[$prop] = new ParticleValueController($duration, $precision);
			tp.points.beginning.value = $start;
			tp.points.end.value = $end;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		public function setLife($life:Number, $spread:Number = 0):void {
			_life = $life;
			_lifeSpread = $spread;
		}
		
		public function get life():Number{
			return (_lifeSpread != 0) ? Random.fromRange(_life, _lifeSpread, 2) : _life;
		}
		
		protected function attachController($particle:Particle, $prop:String):void {
			$particle.controllers[$prop] = new ValueController($particle, $prop, (this[$prop].duration == 0) ? $particle.life : this[$prop].duration, this[$prop].precision);
			$particle.controllers[$prop].points = this[$prop].points;
		}
		
		public function attachAll($particle:Particle):void {
			if(_life > 0) $particle.addLife(life);
			for (var p:String in this) {
				attachController($particle, p);
			}
		}
	
	}

}
