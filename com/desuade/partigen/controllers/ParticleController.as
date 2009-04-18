package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.utils.*
	import com.desuade.partigen.particles.*
	import com.desuade.partigen.emitters.*

	public dynamic class ParticleController extends Object {
		
		protected var _life:Object = {value:0, spread:0};
		protected var _color:ParticleColorController = null;
	
		public function ParticleController() {
			super();
		}
		
		public function get life():Object{
			return _life;
		}
		
		public function get color():ParticleColorController{
			return _color;
		}
		
		public function set color($value:ParticleColorController):void {
			_color = $value;
		}
		
		public function addStartValue($prop:String, $value:*, $spread:* = '0', $precision:int = 2):void {
			var tp:ParticleValueController = this[$prop] = new ParticleValueController(0, $precision);
			tp.points.begin.value = $value;
			tp.points.begin.spread = $spread;
			tp.points.end.value = null;
			tp.points.end.spread = '0';
		}
		
		public function addBasicTween($prop:String, $start:*, $startSpread:*, $end:*, $endSpread:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ParticleValueController = this[$prop] = new ParticleValueController($duration, $precision);
			tp.points.begin.value = $start;
			tp.points.end.value = $end;
			tp.points.begin.spread = $startSpread;
			tp.points.end.spread = $endSpread;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		public function addBasicPhysics($prop:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false, $duration:Number = 0):void {
			this[$prop] = new ParticlePhysicsController($duration, $velocity, $acceleration, $friction, $angle, $flip);
		}
		
		protected function randomLife():Number{
			return (_life.spread !== '0') ? Random.fromRange(_life.value, _life.value + _life.spread, 2) : _life.value;
		}
		
		protected function attachController($particle:Particle, $prop:String, $emitter:Emitter = null):void {
			if(this[$prop] is ParticlePhysicsController){
				$particle.controllers[$prop] = new PhysicsValueController($particle, $prop, this[$prop].duration, this[$prop].velocity.points.begin.value, this[$prop].acceleration.points.begin.value, this[$prop].friction.points.begin.value, (this[$prop].angle == null) ? $emitter.angle : this[$prop].angle, this[$prop].flip);
				$particle.controllers[$prop].velocity.points = this[$prop].velocity.points;
				$particle.controllers[$prop].acceleration.points = this[$prop].acceleration.points;
				$particle.controllers[$prop].friction.points = this[$prop].friction.points;
				$particle.controllers[$prop].velocity.duration = (this[$prop].velocity.duration == 0) ? $particle.life : this[$prop].velocity.duration;
				$particle.controllers[$prop].acceleration.duration = (this[$prop].acceleration.duration == 0) ? $particle.life : this[$prop].acceleration.duration;
				$particle.controllers[$prop].friction.duration = (this[$prop].friction.duration == 0) ? $particle.life : this[$prop].friction.duration;
			} else {
				$particle.controllers[$prop] = new ValueController($particle, $prop, (this[$prop].duration == 0) ? $particle.life : this[$prop].duration, this[$prop].precision);
				$particle.controllers[$prop].points = this[$prop].points;
			}
		}
		
		protected function attachColorController($particle:Particle, $emitter:Emitter = null):void {
			$particle.controllers.color = new ColorValueController($particle, (_color.duration == 0) ? $particle.life : _color.duration);
			$particle.controllers.color.points = _color.points;
		}
		
		public function attachAll($particle:Particle, $emitter:Emitter = null):void {
			if(_life.value > 0) $particle.addLife(randomLife());
			for (var p:String in this) {
				attachController($particle, p, $emitter);
			}
			if(_color != null) attachColorController($particle, $emitter);
		}
	
	}

}
