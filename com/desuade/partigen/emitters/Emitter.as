package com.desuade.partigen.emitters {
	
	import flash.display.*;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	import com.desuade.debugging.*;
	import com.desuade.utils.*;
	import com.desuade.partigen.renderers.*;
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.events.*;
	import com.desuade.partigen.pools.*;
	import com.desuade.partigen.controllers.*;

	public dynamic class Emitter extends BasicEmitter {
		
		protected static var _count:int = BasicEmitter._count;
		
		public var controllers:Object = {};
		
		protected var _angle:Random = new Random(0, 0, 1);
	
		public function Emitter() {
			super();
			group = GroupParticle;
			controllers.particle = new ParticleController();
			controllers.emitter = new EmitterController(this);
		}
		
		//getters setters
		
		public function get angle():Number{
			return _angle.randomValue;
		}
		
		public function set angle($value:Number):void {
			_angle.min = _angle.max = $value;
		}
		
		public function get angle_min():Number{
			return _angle.min;
		}
		
		public function get angle_max():Number{
			return _angle.max;
		}
		
		public function set angle_min($value:Number):void {
			_angle.min = $value;
		}
		
		public function set angle_max($value:Number):void {
			_angle.max = $value;
		}
		
		//public functions
		
		public override function start($runcontrollers:Boolean = true):void {
			super.start();
			if($runcontrollers){
				controllers.emitter.startAll();
			}
		}
		
		public override function stop($runcontrollers:Boolean = true):void {
			super.stop();
			if($runcontrollers){
				controllers.emitter.stopAll();
			}
		}
		
		public override function emit($burst:int):void {
			for (var i:int = 0; i < $burst; i++) {
				var np:BasicParticle = pool.addParticle(particle, group, this);
				np.init(this);
				np.x = this.x;
				np.y = this.y;
				np.z = this.z;
				dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:np}));
				np.addEventListener(ParticleEvent.DIED, dispatchDeath);
				controllers.particle.attachAll(np, this);
				np.startControllers();
				renderer.addParticle(np);
			}
		}

	}

}
