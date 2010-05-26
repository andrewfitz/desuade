/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

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
	
	import com.desuade.partigen.interfaces.*;
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
		 *	<p>This is the angle used by ParticlePhysicsControllers on new particles. This only effects properties that are using physics, NOT ParticleTweenControllers.</p>
		 *	<p>The default value is 0, which is pointing "right". 90 is "up", 180 is "left", and 270 is "down".</p>
		 */
		public var angle:int = 0;
		
		/**
		 *	This is the spread for the angle, to create a random range for ParticlePhysicsControllers.
		 */
		public var angleSpread:* = "0";
		
		/**
		 *	@private
		 */
		protected var renderers:Array = [NullRenderer, StandardRenderer, BitmapRenderer, PixelRenderer];
		
		/**
		 *	@private
		 */
		protected var baseparticles:Array = [BasicParticle, Particle, BasicPixelParticle, PixelParticle];
		
		/**
		 *	<p>This creates a new Emitter.</p>
		 *	<p>This is the standard, full-featured emitter that's recommended to use. It offers an innovative and extremely powerful way to configure particle effects, based on MotionControllers from the Motion Package.</p>
		 *	<p>An emitter is the object that controls the creation of new particles, rather than calling <code>new Particle()</code> directly, using emitters makes creating particle effects easy.</p>
		 *	<p>Particles are (generally) spawned from the current location of the emitter, unless specifically overridden by x,y,z controller start values.</p>
		 *	<p>The management of the actual particle objects are handled by Pools, and how they are displayed on screen by Renderers. Both can be shared by multiple emitters.</p>
		 */
		public function Emitter() {
			super();
			particleBaseClass = Particle;
			controllers.particle = new ParticleController();
			controllers.emitter = new EmitterController(this);
		}
		
		/**
		 *	<p>Starts the emitter and optionally the renderer. If you only want to emit once, or at your own rate, use emit()</p>
		 *	<p>It also, by default, starts all the controllers managed by the EmitterController.</p>
		 *	
		 *	@param	prefetch	 Starts the emitter as if it's already been running for this duration (in seconds).
		 *	@param	startcontrollers	 This starts all MotionControllers managed by the EmitterController.
		 */
		public override function start($prefetch:Number = 0, $startcontrollers:Boolean = true):void {
			super.start($prefetch);
			if($startcontrollers){
				controllers.emitter.start();
			}
		}
		
		/**
		 *	This stops the emitter. It also, by default, stops all the controllers managed by the EmitterController.
		 *	
		 *	@param	stopcontrollers	 This stops all MotionControllers managed by the EmitterController.
		 */
		public override function stop($stopcontrollers:Boolean = true):void {
			super.stop();
			if($stopcontrollers){
				controllers.emitter.stop();
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		protected override function createParticle($totalLife:Number = 0, $remainingLife:Number = 0):IBasicParticle {
			var np:* = super.createParticle($totalLife, $remainingLife);
			controllers.particle.attachAll(np, this);
			if($remainingLife > 0) np.startControllers($totalLife-$remainingLife);
			else np.startControllers();
			return np;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function toXML():XML {
			var txml:XML = super.toXML();
			txml.@angle = angle;
			txml.@angleSpread = XMLHelper.xmlize(angleSpread);
			txml.appendChild(<Controllers />);
			txml.Controllers.appendChild(controllers.emitter.toXML());
			txml.Controllers.appendChild(controllers.particle.toXML());
			return txml;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function fromXML($xml:XML, $reset:Boolean = true, $renderer:Boolean = false):* {
			if(super.fromXML($xml, $reset, $renderer) != false){
				try {
					if($xml.@angle != undefined) angle = int($xml.@angle);
					if($xml.@angleSpread != undefined) angleSpread = XMLHelper.dexmlize($xml.@angleSpread);
					if($xml.hasOwnProperty("Controllers")){
						for (var i:int = 0; i < $xml.Controllers.children().length(); i++) {
							if($xml.Controllers.children()[i].name() == "ParticleController"){
								controllers.particle.fromXML($xml.Controllers.children()[i]);
							} else if($xml.Controllers.children()[i].name() == "EmitterController"){
								controllers.emitter.fromXML($xml.Controllers.children()[i]);
							}
						}
					}
					return this;
				} catch (e:Error){
					Debug.output('partigen', 20009, [e]);
					return false;
				}
			} else {
				return false;
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function reset():void {
			super.reset();
			angle = 0, angleSpread = '0', particleBaseClass = Particle;
			controllers = {};
			controllers.particle = new ParticleController();
			controllers.emitter = new EmitterController(this);
		}
		
		/**
		 *	@private
		 */
		public function randomAngle():Number{
			return (angleSpread !== '0') ? Random.fromRange(angle, (typeof angleSpread == 'string') ? angle + Number(angleSpread) : angleSpread, 2) : angle;
		}

	}

}
