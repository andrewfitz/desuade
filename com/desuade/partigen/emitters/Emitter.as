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

	public dynamic class Emitter extends Sprite {
		
		protected static var _count:int = 0;
		
		public var renderer:Renderer;
		public var pool:Pool;
		public var burst:int = 1;
		public var particle:Class;
		public var controllers:Object = {};
		
		public var groupAmount:int = 1;
		public var groupProximity:int;
		
		protected var _angle:Random = new Random(0, 0, 1);
		
		protected var _id:int;
		protected var _eps:int;
		protected var _active:Boolean;
		protected var _updatetimer:Timer;
		protected var _particles:Object = {};
	
		public function Emitter() {
			super();
			_id = ++Emitter._count;
			controllers.particle = new ParticleController();
			controllers.emitter = new EmitterController(this);
			renderer = new NullRenderer();
			pool = new NullPool();
			Debug.output('partigen', 20001, [id]);
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
		
		public function get eps():int{
			return _eps;
		}
		public function set eps($value:int):void {
			_eps = $value;
			setTimer(true);
		}
		
		public function get active():Boolean{
			return _active;
		}
		
		public function get id():int{
			return _id;
		}
		
		public function get particles():Object{
			return _particles;
		}
		
		//public functions
		
		public function start($runcontrollers:Boolean = true):void {
			_active = true;
			setTimer(true);
			if($runcontrollers){
				controllers.emitter.startAll();
			}
		}
		
		public function stop($runcontrollers:Boolean = true):void {
			_active = false;
			setTimer(false);
			if($runcontrollers){
				controllers.emitter.stopAll();
			}
		}
		
		public function emit($burst:int):void {
			for (var i:int = 0; i < $burst; i++) {
				var np:Particle = pool.addParticle(particle, this);
				np.init(this);
				np.x = this.x;
				np.y = this.y;
				np.z = this.z;
				controllers.particle.attachAll(np, this);
				np.startControllers();
				renderer.addParticle(np);
			}
		}
		
		//protected functions
		
		protected function setTimer($set:Boolean):void {
			if($set){
				if(_updatetimer != null) setTimer(false);
				_updatetimer = new Timer(1000/_eps);
				_updatetimer.addEventListener(TimerEvent.TIMER, update);
				if(_active) _updatetimer.start();
			} else {
				_updatetimer.stop();
				_updatetimer.removeEventListener(TimerEvent.TIMER, update);
				_updatetimer = null;
			}
		}
		
		protected function update($o:Object):void {
			emit(burst);
			Debug.output('partigen', 40001, [id, getTimer()]);
		}

	}

}
