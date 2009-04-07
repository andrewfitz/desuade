package com.desuade.motion.physics {
	
	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BasicPhysics extends Object {
		
		internal static var _sprite:Sprite = new Sprite();
		
		protected var _active:Boolean;
		protected var _friction:Number;
		protected var _calcfriction:Number;
		protected var _calcangle:Number;
		
		public var target:Object;
		public var prop:String;
		public var velocity:Number;
		public var acceleration:Number;
		public var flip:Boolean;
		public var angle:Number;
		
		public function BasicPhysics($target:Object, $prop:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			target = $target;
			prop = $prop;
			velocity = $velocity;
			acceleration = $acceleration;
			friction = $friction;
			flip = $flip;
			angle = $angle;
		}
		
		public function set friction($value:Number):void {
			_calcfriction = (1 - ($value / 100));
			_friction = $value;
		}
		
		public function get friction():Number{
			return _friction;
		}
		
		public function get active():Boolean{
			return _active;
		}
		
		public function setAngle($value:Number):void {
			angle = $value;
			_calcangle = (flip) ? Math.sin($value * Math.PI / 180) : Math.cos($value * Math.PI / 180);
			velocity *= _calcangle;
		}
		
		public function enable($setangle:Boolean = true):void {
			_active = true;
			if($setangle) setAngle(angle);
			_sprite.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function disable():void {
			_active = false;
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		protected function update(u:Object):void {
			velocity += acceleration;
			velocity *= _calcfriction;
			if(flip) target[prop] -= velocity;
			else target[prop] += velocity;
		}
		
		////shortcuts add 0.075k
		
		public function get v():Number{
			return velocity;
		}
		public function set v($value:Number):void {
			velocity = $value;
		}
		public function get a():Number{
			return acceleration;
		}
		public function set a($value:Number):void {
			acceleration = $value;
		}
		public function get f():Number{
			return friction;
		}
		public function set f($value:Number):void {
			friction = $value;
		}
		
	}

}
