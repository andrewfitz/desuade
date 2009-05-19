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

package com.desuade.partigen.emitters {
	
	import flash.display.*;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	import com.desuade.debugging.*;
	import com.desuade.utils.*;
	import com.desuade.partigen.renderers.*;
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.events.*;
	import com.desuade.partigen.pools.*;
	import com.desuade.partigen.controllers.*;

	/**
	 *  This creates particles and holds the controllers to configure the effects.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public dynamic class Emitter extends BasicEmitter {
		
		/**
		 *	<p>This object holds the EmitterController and the ParticleController.</p>
		 *	<p>They are accessible as follows: <code>controllers.emitter</code> and <code>controllers.particle</code></p>
		 *	<p>These controllers are what is used to configure particles and the way the behave, as well as properties for the emitter itself.</p>
		 */
		public var controllers:Object = {};
		
		/**
		 *	@private
		 */
		protected var _angle:Random = new Random(0, 0, 1);
		
		/**
		 *	<p>This creates a new Emitter.</p>
		 *	<p>This is the standard, full-featured emitter that's recommended to use. It offers an innovative and extremely powerful way to configure particle effects, based on ValueControllers from the Motion Package.</p>
		 *	<p>An emitter is the object that controls the creation of new particles, rather than calling <code>new Particle()</code> directly, using emitters makes creating particle effects easy.</p>
		 *	<p>Particles are (generally) spawned from the current location of the emitter, unless specifically overridden by x,y,z controller start values.</p>
		 *	<p>The management of the actual particle objects are handled by Pools, and how they are displayed on screen by Renderers. Both can be shared by multiple emitters.</p>
		 */
		public function Emitter() {
			super();
			group = GroupParticle;
			controllers.particle = new ParticleController();
			controllers.emitter = new EmitterController(this);
		}
		
		/**
		 *	<p>This is the angle used by ParticlePhysicsControllers on new particles. This only effects properties that are using physics.</p>
		 *	<p>This number will be random based on the angle_min and angle_max values. If this value is set to a Number, both min and max will be set to the same value.</p>
		 *	<p>The default value is 0, which is pointing "right". 90 is "up", 180 is "left", and 270 is "down".</p>
		 */
		public function get angle():Number{
			return _angle.randomValue;
		}
		
		/**
		 *	The minimum angle used to create a random <code>angle</code> value.
		 */
		public function get angle_min():Number{
			return _angle.min;
		}
		
		/**
		 *	The maximum angle used to create a random <code>angle</code> value.
		 */
		public function get angle_max():Number{
			return _angle.max;
		}
		
		/**
		 *	@private
		 */
		public function set angle($value:Number):void {
			_angle.min = _angle.max = $value;
		}
		
		/**
		 *	@private
		 */
		public function set angle_min($value:Number):void {
			_angle.min = $value;
		}
		
		/**
		 *	@private
		 */
		public function set angle_max($value:Number):void {
			_angle.max = $value;
		}
		
		/**
		 *	This starts the emitter. It also, by default, starts all the controllers managed by the EmitterController.
		 *	
		 *	@param	startcontrollers	 This starts all ValueControllers managed by the EmitterController.
		 */
		public override function start($startcontrollers:Boolean = true):void {
			super.start();
			if($startcontrollers){
				controllers.emitter.startAll();
			}
		}
		
		/**
		 *	This stops the emitter. It also, by default, stops all the controllers managed by the EmitterController.
		 *	
		 *	@param	stopcontrollers	 This stops all ValueControllers managed by the EmitterController.
		 */
		public override function stop($stopcontrollers:Boolean = true):void {
			super.stop();
			if($stopcontrollers){
				controllers.emitter.stopAll();
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function emit($burst:int = 1):void {
			for (var i:int = 0; i < $burst; i++) {
				var np:BasicParticle = pool.addParticle(particle, group, this);
				np.init(this);
				np.x = this.x;
				np.y = this.y;
				np.z = this.z;
				dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:np}));
				controllers.particle.attachAll(np, this);
				np.startControllers();
				renderer.addParticle(np);
			}
		}

	}

}
