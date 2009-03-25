package com.desuade.partigen.emitters {
	
	import com.desuade.partigen.renderers.*
	import com.desuade.partigen.particles.*

	public class Emitter extends Object {
		
		protected static var _count:int = 0;
		
		public var renderer:Renderer;
		public var burst:int;
		public var particles:Object;
		public var target:Object;
		public var ordering:String;
		public var particle:Particle;
		public var controllers:Object;
		
		protected var _id:int;
		protected var _eps:int;
		protected var _active:Boolean;
	
		public function Emitter() {
			super();
			_id = ++Emitter._count;
		}
		
		//getters setters
		
		public function get eps():int{
			return _eps;
		}
		public function set eps($value:int):void {
			_eps = $value;
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
			
		}
		
		public function stop():void {
			_active = false;
			
		}
		
		public function emit($burst:int):void {
			for (var i:int = 0; i < $burst; i++) {
				var np:Particle = new Particle(this);
			}
		}
		
		public function addParticleController():void {
			
		}
		
		protected function update():void {
			emit(burst);
		}
		
	}

}

