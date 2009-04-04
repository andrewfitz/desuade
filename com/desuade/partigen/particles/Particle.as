package com.desuade.partigen.particles {
	
	import flash.display.Sprite;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import com.desuade.debugging.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.events.*;
	import com.desuade.motion.tweens.*;

	public dynamic class Particle extends Sprite {
		
		protected static var _count:int = 0;
		
		public var controllers:Object = {};
		public var life:Number;
		
		protected var _emitter:Emitter;
		protected var _id:int;
		
		protected var _lifeTimer:Timer;
	
		public function Particle() {
			super();
		}
		
		public function init($emitter:Emitter):void {
			_emitter = $emitter;
			_id = Particle._count++;
			name = "particle_"+_id;
			dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:this}));
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
		
		public function set scale($value:Number):void {
			scaleX = scaleY = $value;
		}
		public function get scale():Number{
			return scaleX;
		}
		
		public function addLife($life:Number):void {
			life = $life;
			_lifeTimer = new Timer($life*1000);
			_lifeTimer.addEventListener(TimerEvent.TIMER, kill);
			_lifeTimer.start();
		}
		
		public function startControllers():void {
			for (var p:String in controllers) {
				controllers[p].start();
			}
		}
		
		public function kill(... args):void {
			dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:this}));
			Debug.output('partigen', 50002, [id]);
			_lifeTimer.stop();
			_lifeTimer = null;
			_emitter.renderer.removeParticle(this);
			_emitter.pool.removeParticle(this.id);
		}
	
	}

}
