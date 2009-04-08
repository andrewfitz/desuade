package com.desuade.partigen.particles {
	
	import flash.display.Sprite;
	
	import com.desuade.debugging.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.events.*;

	public dynamic class BasicParticle extends Sprite {
		
		protected static var _count:int = 0;
		
		protected var _emitter:Emitter;
		protected var _id:int;
	
		public function BasicParticle() {
			super();
		}
		
		public function init($emitter:Emitter):void {
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
		
		public function get emitter():Emitter{
			return _emitter;
		}
		
		public function kill(... args):void {
			dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:this}));
			Debug.output('partigen', 50002, [id]);
			_emitter.renderer.removeParticle(this);
			_emitter.pool.removeParticle(this.id);
		}
	
	}

}
