/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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
	import com.desuade.motion.bases.*;
	
	/**
	 *  This class simulates very basic physics, using basic motion equations to change the value of a property. This can be used like a 'tween' to change any property's value, not just positional properties like x and y.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  27.04.2009
	 */
	public class BasicPhysics extends BaseBasic {
		
		/**
		 *	@private
		 */
		public static const PI:Number = Math.PI;
		
		/**
		 *	<p>This creates a BasicPhysics object.</p>
		 *	
		 *	<p>Each BasicPhysics object controls a single property on a given target object, and applies basic physics equations to calculate a change in value.</p>
		 *	
		 *	<p>Unlike tweens, there is no end value, and the BasicPhysics' update will continue to run until it is stopped, or it reaches the specified duration.</p>
		 *	<p>Paramaters for the configObject:</p>
		 *	<ul>
		 *	<li>property:String – The property to apply the physics to.</li>
		 *	<li>velocity:Number – The velocity of the property. Defaults 0.</li>
		 *	<li>acceleration:Number – The acceleration of the property. Defaults 0.</li>
		 *	<li>friction:Number – The friction of the property. Defaults 0.</li>
		 *	<li>angle:* – The angle at which to start at. Defaults disabled. 0 = right, 90 = up, 180 = left, 270 = down, 360 = right</li>
		 *	<li>flip:Boolean – To flip the cartesian coordinates or not. Defaults false.</li>
		 *	<li>duration:Number – How long to apply the physics for. 0 (the default) will apply the physics until stop() is called</li>
		 *	<li>update:Boolean – enable broadcasting of UPDATED event (can lower performance)</li>
		 *	</ul>
		 *	
		 *	@param	target	 The target object.
		 *	@param	configObject	 The object containing the physics configuration values.
		 *	
		 *	@see #target
		 *	@see #property
		 *	@see PrimitivePhysics#velocity
		 *	@see PrimitivePhysics#acceleration
		 *	@see PrimitivePhysics#friction
		 *	@see #angle
		 *	@see PrimitivePhysics#flip
		 *	@see PrimitivePhysics#duration
		 *	@see #config
		 */
		public function BasicPhysics($target:Object, $configObject:Object = null) {
			if($configObject != null){
				$configObject.velocity =($configObject.velocity != undefined) ? $configObject.velocity : 0;
				$configObject.acceleration = ($configObject.acceleration != undefined) ? $configObject.acceleration : 0;
				$configObject.friction = ($configObject.friction != undefined) ? $configObject.friction : 0;
				$configObject.angle = ($configObject.angle != undefined) ? $configObject.angle : null;
				$configObject.flip = ($configObject.flip != undefined) ? $configObject.flip : false;
				$configObject.duration = ($configObject.duration != undefined) ? $configObject.duration : 0;
			}
			super($target, $configObject);
			_eventClass = PhysicsEvent;
			Debug.output('motion', 40009);
		}
		
		/**
		 *	This will start the physics as if it's already been running for the given amount of time.
		 *	
		 *	@param	time	 How long in seconds to emulate
		 *	@param	rate	If the target isn't a DisplayObject, you need to set the fps manually here, or BaseTicker.physicsRate.
		 *	
		 *	@return		The BasicPhysics object.
		 */
		public function startAtTime($time:Number = 0, $rate:Number = 0):BasicPhysics {
			start();
			if($time > 0){
				var iterations:int = 0;
				if($rate > 0) iterations = $rate * $time;
				else if(target.stage != undefined) iterations = target.stage.frameRate * $time;
				else iterations = BaseTicker.physicsRate * $time;
				var pt:PrimitivePhysics = BaseTicker.getItem(pid);
				for (var i:int = 0; i < iterations; i++) pt.render(i);
			}
			return this;
		}
		
		/**
		 *	Gets the velocity that's calculated with a given angle.
		 *	
		 *	@param	velocity	 The velocity to use
		 *	@param	angle	 The angle used to determine the new velocity
		 *	@param	flip	 Negate (or flip) the velocity.
		 *	
		 *	@return		Number representing the new angle-velocity
		 */
		public static function getVelocityWithAngle($velocity:Number, $angle:Number, $flip:Boolean):Number {
			var calcangle:Number = ($flip) ? Math.sin($angle * PI / 180) : Math.cos($angle * PI / 180);
			return $velocity * calcangle;
		}
		
		/**
		 *	Sets/gets the velocity of the config and PrimitivePhysics object
		 */
		public function get velocity():Number{
			return (pid != 0) ? BaseTicker.getItem(pid).velocity : _config.velocity;
		}
		
		/**
		 *	@private
		 */
		public function set velocity($value:Number):void {
			if(pid != 0) BaseTicker.getItem(pid).velocity = $value;
			_config.velocity = $value;
		}
		
		/**
		 *	Sets/gets the acceleration of the config and PrimitivePhysics object
		 */
		public function get acceleration():Number{
			return (pid != 0) ? BaseTicker.getItem(pid).acceleration : _config.acceleration;
		}
		
		/**
		 *	@private
		 */
		public function set acceleration($value:Number):void {
			if(pid != 0) BaseTicker.getItem(pid).acceleration = $value;
			_config.acceleration = $value;
		}
		
		/**
		 *	Sets/gets the friction of the config and PrimitivePhysics object
		 */
		public function get friction():Number{
			return (pid != 0) ? BaseTicker.getItem(pid).friction : _config.friction;
		}
		
		/**
		 *	@private
		 */
		public function set friction($value:Number):void {
			if(pid != 0) BaseTicker.getItem(pid).friction = $value;
			_config.friction = $value;
		}
		
		/**
		 *	@private
		 */
		protected override function createPrimitive($to:Object):int {
			var nv:Number = ($to.angle != null) ? getVelocityWithAngle($to.velocity, $to.angle, $to.flip) : $to.velocity;
			var pt:PrimitivePhysics = BaseTicker.addItem(PrimitivePhysics);
			pt.init(target, $to.property, nv, $to.acceleration, $to.friction, $to.flip, $to.duration*1000);
			pt.endFunc = endFunc;
			pt.updateFunc = updateListener;
			return pt.id;
		}
		
	}

}
