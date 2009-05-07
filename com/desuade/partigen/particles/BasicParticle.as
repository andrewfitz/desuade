package com.desuade.partigen.particles {
	
	import flash.display.Sprite;
	
	import com.desuade.debugging.Debug;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.partigen.events.ParticleEvent;

	public dynamic class BasicParticle extends Sprite {
		
		protected static var _count:int = 0;
		
		protected var _emitter:BasicEmitter;
		protected var _id:int;
	
		public function BasicParticle() {
			super();
		}
		
		public function init($emitter:BasicEmitter):void {
			_emitter = $emitter;
			_id = BasicParticle._count++;
			name = "particle_"+_id;
			Debug.output('partigen', 50001, [id]);
		}
		
		//setters getters
		
		public static function get count():int { 
			return _count; 
		}
		
		public function get id():int{
			return _id;
		}
		
		public function get emitter():BasicEmitter{
			return _emitter;
		}
		
		public function kill(... args):void {
			_emitter.dispatchDeath(this);
			Debug.output('partigen', 50002, [id]);
			_emitter.renderer.removeParticle(this);
			_emitter.pool.removeParticle(this.id);
		}
	
	}

}
