package com.desuade.partigen.emitters {
	
	import flash.display.Sprite;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	import com.desuade.debugging.Debug;
	import com.desuade.utils.*;
	import com.desuade.partigen.renderers.*;
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.events.*;
	import com.desuade.partigen.pools.*;

	public dynamic class BasicEmitter extends Sprite {
		
		protected static var _count:int = 0;
		
		public var renderer:Renderer;
		public var pool:Pool;
		public var burst:int = 1;
		public var particle:Class;
		public var group:Class = BasicGroupParticle;
		
		public var groupAmount:int = 1;
		public var groupProximity:int;
		
		protected var _id:int;
		protected var _eps:int;
		protected var _active:Boolean;
		protected var _updatetimer:Timer;
	
		public function BasicEmitter() {
			super();
			_id = ++BasicEmitter._count;
			renderer = new NullRenderer();
			pool = new NullPool();
			Debug.output('partigen', 20001, [id]);
		}
		
		//getters setters
				
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
		
		//public functions
		
		//runcontrollers does nothing here, but needed for override
		public function start($runcontrollers:Boolean = true):void {
			_active = true;
			setTimer(true);
		}
		
		public function stop($runcontrollers:Boolean = true):void {
			_active = false;
			setTimer(false);
		}
		
		public function emit($burst:int):void {
			for (var i:int = 0; i < $burst; i++) {
				var np = pool.addParticle(particle, group, this);
				np.init(this);
				np.x = this.x;
				np.y = this.y;
				np.z = this.z;
				dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:np}));
				np.addEventListener(ParticleEvent.DIED, dispatchDeath, false, 0, true);
				renderer.addParticle(np);
			}
		}
		
		//protected functions
		
		protected function dispatchDeath(o:Object):void {
			o.info.particle.removeEventListener(ParticleEvent.DIED, dispatchDeath);
			dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:o.info.particle}));
		}
		
		protected function setTimer($set:Boolean):void {
			if($set){
				if(_updatetimer != null) setTimer(false);
				_updatetimer = new Timer(1000/_eps);
				_updatetimer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
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
