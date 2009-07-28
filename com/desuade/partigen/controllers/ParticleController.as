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

	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.particles.*;
	
	import flash.utils.*;

	/**
	 *  This is created by an emitter to manage and control all the particle motion controller configurations.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class ParticleController extends Object {
		
		/**
		 *	The default tween class to use for emitter controllers
		 */
		public static var tweenClass:Class = BasicTween;
		
		/**
		 *	The default colortween class to use for emitter controllers
		 */
		public static var colorTweenClass:Class = BasicColorTween;
		
		/**
		 *	This creates a ParticleController. This is created automatically by the emitter and does not need to be called on it's own. 
		 */
		public function ParticleController() {
			super();
		}
		
		/**
		 *	<p>This sets the initial value of the given property. If the property exists as a ParticleTweenController already, it will modify the current 'begin' keyframe. If it doesn't, this creates a new ParticleTweenController and sets its 'begin' keyframe.</p>
		 *	
		 *	<p>Note: this only sets ParticleTweenControllers, NOT ParticlePhysicsControllers.</p>
		 *	
		 *	@param	property	 The particle's property to be set.
		 *	@param	value	 The property's value.
		 *	@param	spread	 The spread of the value. If this is anything besides '0', a random value will be generated using the value and spread.
		 *	@param	precision	 The amount of decimal points used when creating a spread value
		 *	@param	extras	 An 'extras' object to be passed to the tween engine for that keyframe.
		 */
		public function addBeginValue($property:String, $value:*, $spread:* = '0', $precision:int = 0, $extras:Object = null):ParticleTweenController {
			if(this[$property] == undefined) this[$property] = new ParticleTweenController(0);
			this[$property].keyframes.begin.value = $value;
			this[$property].keyframes.begin.spread = $spread;
			this[$property].keyframes.precision = $precision;
			if($extras != null) this[$property].keyframes.begin.extras = $extras;
			return this[$property];
		}
		
		/**
		 *	This creates a ParticleTweenController for the given property. Each particle created will have this MotionController generated for it.
		 *	
		 *	@param	property	 The particle's property to be set.
		 *	@param	duration	 The entire duration for the controller. If this is 0 (default), the duration will be set to the particle's life.
		 */
		public function addTween($property:String, $duration:Number = 0):ParticleTweenController {
			return this[$property] = new ParticleTweenController($duration);
		}
		
		/**
		 *	<p>This creates a ParticleTweenController that is specific for color tweening. This can be used to tween other properties on the particle that are color variables, like a fill or 3D object.</p>
		 *	
		 *	<p>For a standard color tween on a display object, use the property 'color'. Any other value will assume it's a special property on the particle.</p>
		 *	
		 *	@param	property	 The particle's property to be set for color. The standard property should be 'color'.
		 *	@param	duration	 The entire duration for the controller. If this is 0 (default), the duration will be set to the particle's life.
		 */
		public function addColorTween($property:String = 'color', $duration:Number = 0):ParticleTweenController {
			return this[$property] = new ParticleTweenController($duration, ColorKeyframeContainer, colorTweenClass);
		}
		
		/**
		 *	This creates a ParticlePhysicsController (which is like a PhysicsMultiController) that has 3 ParticleTweenControllers for each physics property: velocity, acceleration, and friction.
		 *	
		 *	@param	property	 The particle's property to be set.
		 *	@param	duration	 The entire duration for the controller. If this is 0 (default), the duration will be set to the particle's life.
		 *	@param	flip	 To set the physics's object flip value. This is useful for some properties like 'y'.
		 *	@param	useAngle	 To use the emitter's angle value for the physics object. Set to false for properties besides x,y,z
		 */
		public function addPhysics($property:String, $duration:Number = 0, $flip:Boolean = false, $useAngle:Boolean = true):ParticlePhysicsController {
			this[$property] = new ParticlePhysicsController($duration);
			this[$property].flip = $flip;
			this[$property].useAngle = $useAngle;
			return this[$property];
		}
		
		/**
		 *	Creates an XML object containing configuration for the ParticleController
		 *	
		 *	@return		An XML object representing the ParticleController
		 */
		public function toXML():XML {
			var txml:XML = <ParticleController />;
			for (var p:String in this){
				var nx:XML = this[p].toXML();
				nx.@property = p;
				txml.appendChild(nx);
			}
			return txml;
		}
		
		/**
		 *	This configures the ParticleController from XML and creates all child controllers.
		 *	
		 *	@param	xml	 The XML object used to configure the ParticleController.
		 *	
		 *	@return		The ParticleController object (for chaining)
		 */
		public function fromXML($xml:XML):ParticleController {
			var cd:XMLList = $xml.children();
			for (var i:int = 0; i < cd.length(); i++) {
				var contclass:Class = getDefinitionByName("com.desuade.partigen.controllers::" + cd[i].localName()) as Class;
				this[cd[i].@property] = new contclass(0).fromXML(cd[i]);
			}
			return this;
		}
		
		//privates
		
		/**
		 *	@private
		 */
		protected function attachController($particle:Particle, $property:String, $emitter:Emitter):void {
			if(this[$property] is ParticlePhysicsController){
				$particle.controllers[$property] = new PhysicsMultiController($particle, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration);
				$particle.controllers[$property].physics.angle = (this[$property].useAngle) ? $emitter.angle : null;
				$particle.controllers[$property].physics.flip = this[$property].flip;
				$particle.controllers[$property].velocity.keyframes = this[$property].velocity.keyframes;
				$particle.controllers[$property].acceleration.keyframes = this[$property].acceleration.keyframes;
				$particle.controllers[$property].friction.keyframes = this[$property].friction.keyframes;
			} else {
				$particle.controllers[$property] = new MotionController($particle, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration);
				$particle.controllers[$property].keyframes = this[$property].keyframes;
			}
		}
		
		/**
		 *	@private
		 */
		public function attachAll($particle:Particle, $emitter:Emitter):void {
			for (var p:String in this) {
				attachController($particle, p, $emitter);
			}
			if($particle.controllers['color'] != undefined) {
				$particle.controllers['color'].property = null;
			}
		}
			
	}

}
