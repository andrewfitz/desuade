package com.desuade.partigen.particles {
	
	import flash.display.Sprite;
	
	import com.desuade.debugging.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.events.*;
	import com.desuade.motion.proxies.*;

	public dynamic class Particle extends Sprite {
		
		protected static var _count:int = 0;
		
		public var controllers:Object;
		public var _emitter:Emitter;
		
		protected var _id:int;
	
		public function Particle() {
			super();
			_id = Particle._count++;
			dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:this}));
			Debug.output('partigen', 50001, [id]);
			TweenProxy.tween({delay:2, func:kill});
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
		
		public function kill():void {
			dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:this}));
			Debug.output('partigen', 50002, [id]);
			_emitter.renderer.removeParticle(this);
			_emitter.pool.removeParticle(this.id);
		}
	
	}

}
