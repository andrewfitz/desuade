package com.desuade.motion.physics {
	
	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *  This class simulates very basic physics, using motion equations to change the value of a property. This can be used like a 'tween' to change any property's value, not just positional properties like x and y.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  27.04.2009
	 */
	public class BasicPhysics extends EventDispatcher {
		
		/**
		 *	@private
		 */
		internal static var _sprite:Sprite = new Sprite();
		
		/**
		 *	@private
		 */
		protected var _active:Boolean;
		
		/**
		 *	@private
		 */
		protected var _friction:Number;
		
		/**
		 *	@private
		 */
		protected var _calcfriction:Number;
		
		/**
		 *	@private
		 */
		protected var _calcangle:Number;
		
		/**
		 *	The target object. Any Object, not just a DisplayObject.
		 */
		public var target:Object;
		/**
		 *	@private
		 */
		public var property:String;
		public var velocity:Number;
		public var acceleration:Number;
		public var flip:Boolean;
		public var angle:Number;
		
		public function BasicPhysics($target:Object, $property:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false) {
			super();
			target = $target;
			property = $property;
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
			_sprite.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		public function disable():void {
			_active = false;
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		protected function update(u:Object):void {
			velocity += acceleration;
			velocity *= _calcfriction;
			if(flip) target[property] -= velocity;
			else target[property] += velocity;
			dispatchEvent(new PhysicsEvent(PhysicsEvent.UPDATED, {basicPhysics:this}));
		}
		
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
