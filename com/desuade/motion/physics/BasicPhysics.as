/*
This software is distributed under the MIT License.

Copyright (c) 2009 Desuade (http://desuade.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.desuade.motion.physics {
	
	import flash.display.*;
	import com.desuade.debugging.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.motion.events.*;
	
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
		 *	@private
		 */
		protected var _physicsconfig:Object;
		
		/**
		 *	The target object. Any Object, not just a DisplayObject.
		 */
		public var target:Object;
		
		/**
		 *	The property to apply the physics to.
		 */
		public var property:String;
		
		/**
		 *	The velocity of the property. This is added to the current value every frame - ie: FPS of 50, with a velocity of 2 = 100/second.
		 *	Shortcut: "v" - (BasicPhysics.velocity == BasicPhysics.v)
		 */
		public var velocity:Number;
		
		/**
		 *	The acceleration of the property. This is added to the current velocity. A negative acceleration would represent gravity.
		 *	Shortcut: "a" - (BasicPhysics.acceleration == BasicPhysics.a)
		 */
		public var acceleration:Number;
		
		/**
		 *	Setting this to true will 'flip' the way the property is handled. This is for properties such as 'y' that are reversed from the cartesian coordinate system.
		 */
		public var flip:Boolean;
		
		/**
		 *	This is the angle to simulate the beginning velocity. This needs to be set before the engine starts, and only effects the start velocity.
		 *	This is usually set for both 'x' and 'y' to show an angle.
		 *	
		 *	0 = right, 90 = up, 180 = left, 270 = down, 360 = right.
		 */
		public var angle:* = null;
		
		/**
		 *	<p>This creates a BasicPhysics object.</p>
		 *	
		 *	<p>Each BasicPhysics object controls a single property on a given target object, and applies basic physics equations to calculate a change in value.</p>
		 *	
		 *	<p>Unlike tweens, there is no end value, and the BasicPhysics' update will continue to run until it is stopped.</p>
		 *	
		 *	<ul>
		 *	<li>target:Object – The target object.</li>
		 *	<li>property:String – The property to apply the physics to.</li>
		 *	<li>velocity:Number – The velocity of the property. Defaults 0.</li>
		 *	<li>acceleration:Number – The acceleration of the property. Defaults 0.</li>
		 *	<li>friction:Number – The friction of the property. Defaults 0.</li>
		 *	<li>angle:* – The angle at which to start at. Defaults null (disabled).</li>
		 *	<li>flip:Boolean – To flip the cartesian coordinates or not. Defaults false.</li>
		 *	</ul>
		 *	
		 *	@see #target
		 *	@see #property
		 *	@see #velocity
		 *	@see #acceleration
		 *	@see #friction
		 *	@see #angle
		 *	@see #flip
		 */
		public function BasicPhysics($physicsObject:Object) {
			super();
			_physicsconfig = $physicsObject;
			target = $physicsObject.target;
			property = $physicsObject.property;
			velocity = $physicsObject.velocity || 0;
			acceleration = $physicsObject.acceleration || 0;
			friction = $physicsObject.friction || 0;
			flip = $physicsObject.flip || false;
			angle = $physicsObject.angle || null;
			Debug.output('motion', 40009);
		}
		
		/**
		 *	The friction of the property. This will slow down the velocity to 0 if there is no acceleration. Should be a positive number.
		 */
		public function set friction($value:Number):void {
			_calcfriction = (1 - ($value / 100));
			_friction = $value;
		}
		
		/**
		 *	@private
		 */
		public function get friction():Number{
			return _friction;
		}
		
		/**
		 *	If the engine is active or not.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Gets the original physics config object that was passed in the constructor (target, velocity, etc). The properties in this object can be modified, but unlike tween classes, it doesn't directly effect the physics.
		 */
		public function get config():Object{
			return _physicsconfig;
		}
		
		/**
		 *	Starts the physics simulation.
		 *	
		 *	@param	setangle	 Apply the angle to the velocity when starting.
		 *	@see	#angle
		 */
		public function start($setangle:Boolean = true):void {
			_active = true;
			dispatchEvent(new PhysicsEvent(PhysicsEvent.STARTED, {basicPhysics:this}));
			if($setangle && angle != null) setAngle(angle);
			_sprite.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			Debug.output('motion', 40010);
		}
		
		/**
		 *	Stops the physics simulation.
		 */
		public function stop():void {
			_active = false;
			_sprite.removeEventListener(Event.ENTER_FRAME, update);
			dispatchEvent(new PhysicsEvent(PhysicsEvent.ENDED, {basicPhysics:this}));
			Debug.output('motion', 40011);
		}
		
		/**
		 *	@private
		 */
		protected function setAngle($value:Number):void {
			angle = $value;
			_calcangle = (flip) ? Math.sin($value * Math.PI / 180) : Math.cos($value * Math.PI / 180);
			velocity *= _calcangle;
		}
		
		/**
		 *	@private
		 */
		public function update(u:Object):void {
			velocity += acceleration;
			velocity *= _calcfriction;
			if(flip) target[property] -= velocity;
			else target[property] += velocity;
			dispatchEvent(new PhysicsEvent(PhysicsEvent.UPDATED, {basicPhysics:this}));
		}
		
	}

}
