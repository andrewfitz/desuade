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

package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.utils.*
	import com.desuade.partigen.particles.*
	import com.desuade.partigen.emitters.*
	
	/**
	 *  This is a meta controller that handles all the properties for particles on a given emitter.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  06.05.2009
	 */
	public dynamic class ParticleController extends Object {
		
		/**
		 *	@private
		 */
		protected var _life:Object = {value:0, spread:'0'};
		
		/**
		 *	@private
		 */
		protected var _color:ParticleColorController = null;
		
		/**
		 *	This creates a new ParticleController. This normally shouldn't be needed, as this is automatically created by default when an emitter is created.
		 */
		public function ParticleController() {
			super();
		}
		
		/**
		 *	<p>This is the duration in seconds a particle will exist for.</p>
		 *	<p>This is an object that resembles a point:</p>
		 *	<p><code>{value:0, spread:'0'}</code></p>
		 *	<p>If the value is 0, the particle will live forever.</p>
		 */
		public function get life():Object{
			return _life;
		}
		
		/**
		 *	This is a special property for a new ParticleColorController. Defaults to null. If this is null, no ColorValueController will be created.
		 */
		public function get color():ParticleColorController{
			return _color;
		}
		
		/**
		 *	@private
		 */
		public function set color($value:ParticleColorController):void {
			_color = $value;
		}
		
		/**
		 *	<p>This sets a start value for a particle's property, without creating a tween. Useful for setting a random start value without dealing with points.</p>
		 *	<p>Even though there is no tween, a ParticleValueController is still created, and can easily be turned into a tween.</p>
		 *	
		 *	@param	property	 The proprty to assign the start value to.
		 *	@param	value	 The value the property will be when the particle is born. This sets the 'begin point' value.
		 *	@param	spread	 If this is anything besides <code>'0'</code>, a random range of value will be created for each new particle. This sets the 'begin point' spread.
		 *	@param	precision	 How many decimal points the random spread values have.
		 *	
		 *	@see	ParticleValueController
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 */
		public function addStartValue($property:String, $value:*, $spread:* = '0', $precision:int = 2):void {
			var tp:ParticleValueController = this[$property] = new ParticleValueController(0, $precision);
			tp.points.begin.value = $value;
			tp.points.begin.spread = $spread;
			tp.points.end.value = null;
			tp.points.end.spread = '0';
		}
		
		/**
		 *	<p>This creates a new ParticleValueController with a quick and easy syntax, rather than <code>particlecontroller.property = new ParticleValueController()</code></p>
		 *	<p>See the docs on ParticleValueController for more information.</p>
		 *	
		 *	@param	property	 The property of the particle to tween.
		 *	@param	start	 The value the property will be when the particle is born. This sets the 'begin point' value.
		 *	@param	startSpread	 If this is anything besides <code>'0'</code>, a random range of value will be created for each new particle. This sets the 'begin point' spread.
		 *	@param	end	 The value of the property when the particle dies (or the end of the duration). This sets the 'end point' value.
		 *	@param	endSpread	 If this is anything besides <code>'0'</code>, a random range of value will be created for each new particle. This sets the 'end point' spread.
		 *	@param	ease	 The ease used between start and end values. This sets the 'end point' ease.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 *	@param	precision	 How many decimal points the random spread values have.
		 *	
		 *	@see	ParticleValueController
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 *	
		 */
		public function addBasicTween($property:String, $start:*, $startSpread:*, $end:*, $endSpread:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ParticleValueController = this[$property] = new ParticleValueController($duration, $precision);
			tp.points.begin.value = $start;
			tp.points.end.value = $end;
			tp.points.begin.spread = $startSpread;
			tp.points.end.spread = $endSpread;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		/**
		 *	<p>This is a method to quickly create a ParticlePhysicsController, instead of <code>particlecontroller.property = new ParticlePhysicsController()</code></p>
		 *	<p>The new ParticlePhysicsController creates a new PhysicsValueController for the corresponding property to be used for each particle. This controls the value of all 3 physics properties for a single particle property.</p>
		 *	<p>This uses physics instead of tweens to change a particle's property, including those that aren't positional (x,y).</p>
		 *	<p>See the BasicPhysics documentation for more information on what each property does.</p>
		 *	
		 *	@param	property	 The property of the particle to have it's value handled by physics.
		 *	@param	velocity	 The start velocity for the particle's property. This is affected by all the other properties.
		 *	@param	acceleration	 The start acceleration for the property.
		 *	@param	friction	 The start friction for the property.
		 *	@param	angle	 The angle the BasicPhysics object will use to calculate initial velocity. Mostly used with position properties, such as x, y, z. This gets assigned by the emitter, so leave this null.
		 *	@param	flip	 The boolean flip (for cartesian reversal) for properties such as y.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens of the internal ValueControllers, since the position is dependent on the the duration. Set to <code>0</code> for the duration to be set to the particle's life (recommended).
		 *	
		 *	@see ParticlePhysicsController
		 *	@see com.desuade.motion.controllers.ValueController
		 *	@see com.desuade.motion.controllers.PointsContainer
		 *	@see com.desuade.motion.physics.BasicPhysics#velocity
		 *	@see com.desuade.motion.physics.BasicPhysics#acceleration
		 *	@see com.desuade.motion.physics.BasicPhysics#friction
		 *	@see com.desuade.motion.physics.BasicPhysics#angle
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public function addBasicPhysics($property:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false, $duration:Number = 0):void {
			this[$property] = new ParticlePhysicsController($duration, $velocity, $acceleration, $friction, $angle, $flip);
		}
		
		/**
		 *	@private
		 */
		protected function randomLife():Number{
			return (_life.spread !== '0') ? Random.fromRange(_life.value, (typeof _life.spread == 'string') ? _life.value + Number(_life.spread) : _life.spread, 2) : _life.value;
		}
		
		/**
		 *	@private
		 */
		protected function attachController($particle:Particle, $property:String, $emitter:Emitter = null):void {
			if(this[$property] is ParticlePhysicsController){
				$particle.controllers[$property] = new PhysicsValueController($particle, $property, this[$property].duration, this[$property].velocity.points.begin.value, this[$property].acceleration.points.begin.value, this[$property].friction.points.begin.value, (this[$property].angle == null) ? $emitter.angle : this[$property].angle, this[$property].flip);
				$particle.controllers[$property].velocity.points = this[$property].velocity.points;
				$particle.controllers[$property].acceleration.points = this[$property].acceleration.points;
				$particle.controllers[$property].friction.points = this[$property].friction.points;
				$particle.controllers[$property].velocity.duration = (this[$property].velocity.duration == 0) ? $particle.life : this[$property].velocity.duration;
				$particle.controllers[$property].acceleration.duration = (this[$property].acceleration.duration == 0) ? $particle.life : this[$property].acceleration.duration;
				$particle.controllers[$property].friction.duration = (this[$property].friction.duration == 0) ? $particle.life : this[$property].friction.duration;
			} else {
				$particle.controllers[$property] = new ValueController($particle, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration, this[$property].precision);
				$particle.controllers[$property].points = this[$property].points;
			}
		}
		
		/**
		 *	@private
		 */
		protected function attachColorController($particle:Particle, $emitter:Emitter = null):void {
			$particle.controllers.color = new ColorValueController($particle, (_color.duration == 0) ? $particle.life : _color.duration);
			$particle.controllers.color.points = _color.points;
		}
		
		/**
		 *	@private
		 */
		public function attachAll($particle:Particle, $emitter:Emitter = null):void {
			if(_life.value > 0) $particle.addLife(randomLife());
			for (var p:String in this) {
				attachController($particle, p, $emitter);
			}
			if(_color != null) attachColorController($particle, $emitter);
		}
	
	}

}
