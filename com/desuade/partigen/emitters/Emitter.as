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

	public class Emitter extends Sprite {
		
		protected static var _count:int = 0;
		
		public var renderer:Renderer = new NullRenderer();
		public var burst:int = 1;
		public var particles:Object;
		public var ordering:String = 'top, bottom, random';
		public var particle:Class;
		public var controllers:Object;
		
		protected var _id:int;
		protected var _eps:int;
		protected var _active:Boolean;
		protected var _updatetimer:Timer;
	
		public function Emitter() {
			super();
			_id = ++Emitter._count;
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
		
		public function start():void {
			_active = true;
			setTimer(true);
		}
		
		public function stop():void {
			_active = false;
			setTimer(false);
		}
		
		public function emit($burst:int):void {
			for (var i:int = 0; i < $burst; i++) {
				var np:Particle = new particle();
				np._emitter = this;
				np.x = Random.fromRange(this.x-1, this.x+1);
				np.y = Random.fromRange(this.y-1, this.y+1);
				renderer.addParticle(np);
			}
		}
		
		public function addParticleController():void {
			
		}
		
		protected function setTimer($set:Boolean):void {
			if($set){
				_updatetimer = new Timer(1000/_eps);
				_updatetimer.addEventListener(TimerEvent.TIMER, update);
				if(_active) _updatetimer.start();
			} else {
				_updatetimer.stop();
				_updatetimer.removeEventListener(TimerEvent.TIMER, update);
				_updatetimer = null;
			}
		}
		
		protected function update($evt):void {
			emit(burst);
			Debug.output('partigen', 40001, [id, getTimer()]);
		}
		
	}

}

