package com.desuade.partigen.particles {
	
	import com.desuade.partigen.emitters.*
	import flash.display.Sprite

	public class Particle extends Sprite {
		
		protected static var _count:int = 0;
		
		public var controllers:Object;
		
		protected var _emitter:Emitter;
		protected var _id:int;
	
		public function Particle($emitter:Emitter) {
			super();
			_id = ++Particle._count;
			_emitter = $emitter;
			dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:this}));
			Debug.output('partigen', 50001, [id]);
		}
		
		//setters getters
		
		public function get id():int{
			return _id;
		}
		
		public function get emitter():Emitter{
			return _emitter;
		}
		
		public function kill():void {
			dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:this}));
			Debug.output('partigen', 50002, [id]);
		}
	
	}

}

