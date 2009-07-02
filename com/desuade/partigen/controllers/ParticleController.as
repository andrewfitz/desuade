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

	public dynamic class ParticleController extends Object {
		
		/**
		 *	The default tween class to use for emitter controllers
		 */
		public static var tweenClass:Class = BasicTween;
		
		/**
		 *	The default colortween class to use for emitter controllers
		 */
		public static var colorTweenClass:Class = BasicColorTween;
	
		public function ParticleController() {
			super();
		}
		
		public function setBeginValue($property:String, $value:*, $spread:* = '0', $precision:int = 0, $extras:Object = null):void {
			if(this[$property] == undefined) this[$property] = new ParticleTweenController(0);
			this[$property].keyframes.begin.value = $value;
			this[$property].keyframes.begin.spread = $spread;
			this[$property].keyframes.precision = $precision;
			if($extras != null) this[$property].keyframes.begin.extras = $extras;
		}
		
		public function addTween($property:String, $duration:Number = 0):void {
			this[$property] = new ParticleTweenController($duration);
		}
		
		public function addColorTween($property:String = 'color', $duration:Number = 0):void {
			this['color'] = new ParticleTweenController($duration, ColorKeyframeContainer, colorTweenClass);
		}
		
		public function addPhysics($property:String, $duration:Number = 0, $flip:Boolean = false):void {
			this[$property] = new ParticlePhysicsController($duration);
			this[$property].flip = $flip;
		}
		
		//privates
		
		/**
		 *	@private
		 */
		protected function attachController($particle:Particle, $property:String, $emitter:Emitter):void {
			if(this[$property] is ParticlePhysicsController){
				$particle.controllers[$property] = new PhysicsMultiController($particle, $property, (this[$property].duration == 0) ? $particle.life : this[$property].duration);
				$particle.controllers[$property].physics.angle = $emitter.angle;
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
