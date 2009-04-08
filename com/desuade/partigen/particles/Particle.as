package com.desuade.partigen.particles {
	
	import flash.display.Sprite;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import com.desuade.debugging.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.events.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.motion.controllers.*;

	public dynamic class Particle extends BasicParticle {
		
		protected static var _count:int = BasicParticle._count;
		
		public var controllers:Object = {};
		public var life:Number;
		
		protected var _lifeTimer:Timer;
	
		public function Particle() {
			super();
		}
		
		//setters getters
		
		public static function get count():int { 
			return _count; 
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
				if(controllers[p] is ValueController && controllers[p].points.isFlat()){
					controllers[p].setStartValue();
				} else {
					controllers[p].start();
				}
			}
		}
		
		public function stopControllers():void {
			for (var p:String in controllers) {
				if(controllers[p].active){
					controllers[p].stop();
				}
			}
		}
		
		public override function kill(... args):void {
			stopControllers();
			_lifeTimer.stop();
			_lifeTimer = null;
			super.kill(args);
		}
	
	}

}
