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
	
	import flash.display.Sprite;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.*;
	
	import com.desuade.debugging.Debug;
	import com.desuade.utils.*;
	import com.desuade.partigen.renderers.*;
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.events.*;
	import com.desuade.partigen.pools.*;

	/**
	 *  The most basic form of an Emitter, offering the minimum necessary to emit particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public dynamic class BasicEmitter extends Sprite {
		
		/**
		 *	@private
		 */
		protected static var _count:int = 0;
		
		/**
		 *	The Renderer to use for created particles. A NullRenderer is created by default. This can be a new Renderer or just assigned to an external independent Renderer.
		 */
		public var renderer:Renderer;
		
		/**
		 *	This is the Pool to use to store and manage the actual particle objects. A NullPool is created by default. This can be a new Pool or just assigned to an external independent Pool.
		 */
		public var pool:Pool;
		
		/**
		 *	This is the amount of particles to be created on each emission.
		 */
		public var burst:int = 1;
		
		/**
		 *	<p>This is the partcle class to be used to create new particles from. This can be an AS3 class, or a library MC.</p>
		 *	<p>It must inherit BasicParticle or Particle, unless GroupParticles are being used, then it's recommended otherwise.</p>
		 */
		public var particle:Class = BasicParticle;
		
		/**
		 *	This is the class used for particle groups. If the particle class you use inherits Particle, use the GroupParticle class, if it inherits BasicParticle, then use BasicGroupParticle, etc.
		 */
		public var group:Class = BasicGroupParticle;
		
		/**
		 *	<p>This controls how may particles are made in a "particle group". This allows you to have many particle act as a single particle.</p>
		 *	<p>This lets there be exponentially more particles since the sam amount of controllers/tweens are used regardless of the groupAmount.</p>
		 *	<p>If the number is greater than 1, it will create a group based on the <code>group</code> value, using the <code>particle</code>class. If this equals 1, it does not create a group.</p>
		 */
		public var groupAmount:int = 1;
		
		/**
		 *	This determines the maximum distance away from the center of the group to create new particles.
		 */
		public var groupProximity:int;
		
		/**
		 *	Enable particle BORN and DIED events. The default is false;
		 */
		public var enableEvents:Boolean = false;
		
		/**
		 *	<p>This is the duration in seconds a particle will exist for.</p>
		 *	<p>If the value is 0, the particle will live forever.</p>
		 */
		public var life:Number = 0;
		
		/**
		 *	<p>This is the spread for particle lives. This will create a random range for the life of new particles.</p>
		 *	<p>Note: if the life value is 0, this has no effect.</p>
		 */
		public var lifeSpread:* = "0";
		
		/**
		 *	@private
		 */
		protected var _id:int;
		
		/**
		 *	@private
		 */
		protected var _eps:Number = 0;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean;
		
		/**
		 *	@private
		 */
		protected var _updatetimer:Timer;
		
		/**
		 *	<p>This creates a new BasicEmitter.</p>
		 *	<p>This emitter does not have any controllers, and only offers basic emission and event functionality.</p>
		 */
		public function BasicEmitter() {
			super();
			_id = ++_count;
			renderer = new NullRenderer();
			pool = new NullPool();
			Debug.output('partigen', 20001, [id]);
		}
		
		
		/**
		 *	<p>This stands for "emissions per second". This is how many times per-second that the emitter will run the <code>emit()</code> method.</p>
		 *	<p>The total amount of particles-per-second depends on this eps value, the burst, and the group amount.</p>
		 *	<p>In order to do 1 emission every 2 seconds, etc, divide 1 by the amount of seconds - ie: eps = 0.5</p>
		 *	<p>Note: this internally sets up a timer each time it's set, so the eps value can not be currently tweened.</p>
		 */
		public function get eps():Number{
			return _eps;
		}
		
		/**
		 *	@private
		 */
		public function set eps($value:Number):void {
			_eps = $value;
			setTimer(true);
		}
		
		/**
		 *	This is true if the emitter is currently emitting.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	The unique id of the emitter.
		 */
		public function get id():int{
			return _id;
		}
		
		//runcontrollers does nothing here, but needed for override
		
		/**
		 *	Starts the emitter.
		 *	
		 *	@param	runcontrollers	 This does nothing for BasicEmitters, and is only used for emitter classes with controllers.
		 */
		public function start($runcontrollers:Boolean = true):void {
			if(!_active){
				_active = true;
				setTimer(true);
			}
		}
		
		/**
		 *	This stops the emitter from emitting particles.
		 *	
		 *	@param	runcontrollers	 This does nothing for BasicEmitters, and is only used for emitter classes with controllers.
		 */
		public function stop($runcontrollers:Boolean = true):void {
			if(_active){
				_active = false;
				setTimer(false);	
			}
		}
		
		/**
		 *	This method creates new particles each time it's called. The amount of particles it creates is dependent on the burst amount passed.
		 *	
		 *	@param	burst	 The amount of particles to create at once.
		 */
		public function emit($burst:int = 1):void {
			for (var i:int = 0; i < $burst; i++) {
				var np:BasicParticle = pool.addParticle(particle, group, this);
				np.init(this);
				np.x = this.x;
				np.y = this.y;
				np.z = this.z;
				if(life > 0) np.addLife(randomLife());
				if(enableEvents) dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:np}));
				renderer.addParticle(np);
			}
		}
		
		/**
		 *	This generates an XML object representing the entire emitter
		 *	
		 *	@return		An XML object representing the emitter
		 */
		public function toXML():XML {
			var txml:XML = <emitter />;
			txml.setLocalName(XMLHelper.getSimpleClassName(this));
			txml.@particle = getQualifiedClassName(particle);
			txml.@eps = eps;
			txml.@burst = burst;
			txml.@life = life;
			txml.@lifeSpread = XMLHelper.xmlize(lifeSpread);
			if(groupAmount > 1){
				txml.@group = XMLHelper.getSimpleClassName(group);
				txml.@groupAmount = groupAmount;
				txml.@groupProximity = groupProximity;
			}
			return txml;
		}
		
		/**
		 *	This configures the emitter based on the XML, and adds any controllers (if available)
		 *	
		 *	@param	xml	 The XML object to use to configure the emitter
		 *	
		 *	@return		The emitter object (for chaining)
		 */
		public function fromXML($xml:XML):* {
			particle = getDefinitionByName($xml.@particle) as Class;
			eps = Number($xml.@eps);
			if($xml.@burst != undefined) burst = Number($xml.@burst);
			if($xml.@group != undefined) group = getDefinitionByName("com.desuade.partigen.particles::" + $xml.@group) as Class;
			if($xml.@groupAmount != undefined) groupAmount = Number($xml.@groupAmount);
			if($xml.@groupProximity != undefined) groupProximity = Number($xml.@groupProximity);
			life = Number($xml.@life);
			if($xml.@lifeSpread != undefined) lifeSpread = XMLHelper.dexmlize($xml.@lifeSpread);
			return this;
		}
		
		/**
		 *	This kills all currently existing particles in the pool created by this emitter
		 */
		public function killParticles():void {
			for each (var particle:BasicParticle in pool.particles) {
				if(particle.emitter == this) particle.kill();
			}
		}
		
		/**
		 *	@private
		 */
		public function randomLife():Number{
			return (lifeSpread !== '0') ? Random.fromRange(life, (typeof lifeSpread == 'string') ? life + Number(lifeSpread) : lifeSpread, 2) : life;
		}
		
		/**
		 *	@private
		 */
		public function dispatchDeath(p:BasicParticle):void {
			if(enableEvents) dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:p}));
		}
		
		/**
		 *	@private
		 */
		protected function setTimer($set:Boolean):void {
			if($set){
				if(_updatetimer != null) setTimer(false);
				_updatetimer = new Timer(1000/_eps);
				_updatetimer.addEventListener(TimerEvent.TIMER, update, false, 0, false);
				if(_active) _updatetimer.start();
			} else {
				_updatetimer.stop();
				_updatetimer.removeEventListener(TimerEvent.TIMER, update);
				_updatetimer = null;
			}
		}
		
		/**
		 *	@private
		 */
		protected function update($o:Object):void {
			emit(burst);
			//Debug.output('partigen', 40001, [id]);
		}

	}

}
