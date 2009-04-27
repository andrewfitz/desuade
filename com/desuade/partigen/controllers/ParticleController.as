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
		
		public function addStartValue($property:String, $value:*, $spread:* = '0', $precision:int = 2):void {
			var tp:ParticleValueController = this[$property] = new ParticleValueController(0, $precision);
			tp.points.begin.value = $value;
			tp.points.begin.spread = $spread;
			tp.points.end.value = null;
			tp.points.end.spread = '0';
		}
		
		public function addBasicTween($property:String, $start:*, $startSpread:*, $end:*, $endSpread:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ParticleValueController = this[$property] = new ParticleValueController($duration, $precision);
			tp.points.begin.value = $start;
			tp.points.end.value = $end;
			tp.points.begin.spread = $startSpread;
			tp.points.end.spread = $endSpread;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		public function addBasicPhysics($property:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false, $duration:Number = 0):void {
			this[$property] = new ParticlePhysicsController($duration, $velocity, $acceleration, $friction, $angle, $flip);
		}
		
		protected function randomLife():Number{
			return (_life.spread !== '0') ? Random.fromRange(_life.value, _life.value + _life.spread, 2) : _life.value;
		}
		
		protected function attachController($particle:Particle, $property:String, $emitter:Emitter = null):void {
			if(this[$property] is ParticlePhysicsController){
				$particle.controllers[$property] = new PhysicsValueController($particle, $property, this[$property].duration, this[$property].velocity.points.begin.value, this[$property].acceleration.points.begin.value, this[$property].friction.points.begin.value, (this[$property].angle == null) ? $emitter.angle : this[$property].angle, this[$property].flip);
				$particle.controllers[$property].velocity.points = this[$property].velocity.points;
				$particle.controllers[$property].acceleration.points = this[$property].acceleration.points;
				$particle.controllers[$property].friction.points = this[$property].friction.points;
				$particle.controllers[$property].velocity.duration = (this[$property].velocity.duration == 0) ? $particle.life : this[$property].velocity.duration;
				$particle.controllers[$property].acceleration.duration = (this[$property].acceleration.duration == 0) ? $particle.life : this[$property].acceleration.duration;
				$particle.controllers[$property].friction.duration = (this[$property].friction.duration == 0) ? $particle.life : this[$property].friction.duration;
			} else {
				$particle.controllers[$property] = new ValueController($particle, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration, this[$property].precision);
				$particle.controllers[$property].points = this[$property].points;
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
