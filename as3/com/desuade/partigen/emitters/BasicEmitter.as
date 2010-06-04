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
	import flash.utils.*;
	import flash.geom.*;
	
	import com.desuade.partigen.Partigen;
	import com.desuade.partigen.interfaces.*;
	import com.desuade.debugging.Debug;
	import com.desuade.utils.*;
	import com.desuade.motion.sequences.*;
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
		 *	<p>This is the class used to create new particles from. This can be an AS3 class, or a library MC. This is the source (image, movieclip, text, etc) used to be added as a child onto the actual particleBaseClass.</p>
		 *	<p>As of v2.1, this can be any class, and does NOT have to inherit BasicParticle. If you have custom classes that do, use particleBaseClass instead.</p>
		 */
		public var particle:Class;
		
		/**
		 *	<p>This is the base class to used for all created particles.</p>
		 *	<p>When the pools create particle objects, they use this. The 'particle' property, is the actual class used for particles you see.</p>
		 *	<p>This should only be used by classes that inherit BasicParticle or Particle. Most of the time you should not need to change this.</p>
		 */
		public function get particleBaseClass():Class{
			return _particleBaseClass;
		}
		
		/**
		 *	@private
		 */
		public function set particleBaseClass($value:Class):void {
			_particleBaseClass = $value;
			pool.setClass(_particleBaseClass);
		}
		
		/**
		 *	@private
		 */
		protected var _particleBaseClass:Class = BasicParticle;
		
		/**
		 *	<p>This defines the blendmode for each particle created.</p>
		 *	<p>Choices: "add", "alpha", "darken", "difference", "erase", "hardlight", "invert", "layer", "lighten", "multiply", "normal", "overlay", "screen", "subtract"</p>
		 */
		public var particleBlendMode:String = "normal";
		
		/**
		 *	This is an array of filters that gets applied to each particle as it's born.
		 */
		public var particleFilters:Array = [];
				
		/**
		 *	<p>This controls how may particles are made in a "particle group". This allows you to have many particle act as a single particle.</p>
		 *	<p>This lets there be exponentially more particles since the sam amount of controllers/tweens are used regardless of the groupAmount.</p>
		 */
		public var groupAmount:int = 1;
		
		/**
		 *	This determines the maximum distance away from the center of the group to create new particles.
		 */
		public var groupProximity:int = 0;
		
		/**
		 *	This will use a Bitmap for the particle instead of the direct display object. Used to improve performance of static particles. Be sure to use in conjunction with createParticleBitmap() (handled automatically with start()).
		 */
		public var groupBitmap:Boolean = false;
		
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
		 *	This forces pooled particles to rebuild their groups and controllers to eliminate any possible repetition at the cost of performance.
		 */
		public var forceVariety:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _id:int;
		
		/**
		 *	@private
		 */
		protected var _eps:Number = 1;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean;
		
		/**
		 *	@private
		 */
		protected var _updatetimer:Timer;
		
		/**
		 *	@private
		 */
		protected var _particlebitmap:BitmapData;
		
		/**
		 *	@private
		 */
		protected var _particleOrigin:Point = new Point(0,0);
		
		/**
		 *	<p>This creates a new BasicEmitter.</p>
		 *	<p>This emitter does not have any controllers, and only offers basic emission and event functionality.</p>
		 */
		public function BasicEmitter() {
			super();
			_id = ++Partigen._emitterCount;
			renderer = new NullRenderer();
			pool = new BasicPool(particleBaseClass);
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
		
		/**
		 *	Starts the emitter. Passing a time will 'prefetch' particles as if the emitter had already been running for the given amount of time. If you only want to emit once, or at your own rate, use emit()
		 *	
		 *	@param	time	 Starts the emitter as if it's already been running for this duration in seconds. If using physics controllers, be sure to set BaseTicker.physicsRate = stage.frameRate for accurate rendering.
		 *	@param	runcontrollers	 This does nothing for BasicEmitters, and is only used for emitter classes with controllers.
		 *	
		 *	@see	#emit()
		 */
		public function start($time:Number = 0, $runcontrollers:Boolean = true):void {
			if(!_active){
				if(groupBitmap) createParticleBitmap();
				_active = true;
				if($time > 0) {
					prefetch($time);
					var ei:Number = 1/eps;	
					var timerDif:Number = ei-(Math.abs($time - (ei * (int(eps * $time) + 1))));
					if(timerDif > 0.001) new DelayableFunc({func:prefetchstart, delay:timerDif}).start();
					else {
						setTimer(true);
						emit(burst);
					}
				} else {
					setTimer(true);
					emit(burst);
				}
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
		 *	This prefetches (and creates) the particles that would have existed if the emitter was running for the given time. This shouldn't be called directly, but through the start() method.
		 *	
		 *	@param	time	 The amount of time that should have passed since the emitter started.
		 */
		public function prefetch($time:Number):void {
			var lives:Array = getPrefetchLifeArray($time);
			for (var i:int = 0; i < lives.length; i++) {
				createParticle(lives[i][0], lives[i][1]);
			}
		}
		
		/**
		 *	This creates an array of particle's life values, both original and current, based on the eps/burst and supplied time value as it would if the emitter was running for the time duration.
		 *	
		 *	@param	time	 The amount of time that should have passed since the emitter started.
		 *	
		 *	@return		An Array with Arrays that contain the original life and current life [[1, .8], [1, .5], [1, .2]]
		 */
		public function getPrefetchLifeArray($time:Number):Array {
			//total emissions plus the first emission on start
			var totalFullEmissions:int = int(eps * $time) + 1;
			//the total amount of particles made so far
			var tpm:int = totalFullEmissions * burst;
			//length of time between emissions
			var ei:Number = 1/eps;	
			//the amount of leftover time passed since an emission
			var extraTimeOver:Number = Math.abs($time - (ei * totalFullEmissions));
			//the amount of time left until the emitter would normally emit
			//var timeUntilNextEmission:Number = ei-extraTimeOver;
			//array of lives that have started to die
			var newlifes:Array = [];
			//the final array of lifes to use
			var finalifes:Array = [];
			//crate an array of total possible particles lives
			var lifearray:Array = [];
			for (var i:int = 0; i < tpm; i++) {
				//get some new lifes, make double array to store original life and current life
				var nl:Number = randomLife();
				lifearray.push([nl, nl]);
			}
			//loop through lifearray
			for (var r:int = 0; r < totalFullEmissions; r++) {
				//removes a burst of particles from each emission from the total array
				//and then adds that array to the newlifes array
				newlifes = newlifes.concat(lifearray.splice(0, burst));
				//subtracts another interval of time
				for (var g:int = 0; g < newlifes.length; g++) {
					newlifes[g][1] -= ei;
				}
			}
			//lets apply the leftover time after all full emissions
			if(extraTimeOver > 0.001){
				for (var k:int = 0; k < newlifes.length; k++) {
					newlifes[k][1] -= extraTimeOver;
				}
			}
			//loop through newlifes and get the only living particles left
			for (var e:int = 0; e < newlifes.length; e++) {
				if(newlifes[e][1] > 0){
					//push living ones into an array
					finalifes.push(newlifes[e]);
				}
			}
			return finalifes;
		}
		
		/**
		 *	This method creates new particles each time it's called. The amount of particles it creates is dependent on the burst amount passed.
		 *	
		 *	@param	burst	 The amount of particles to create at once.
		 */
		public function emit($burst:int = 1):void {
			//var times:int = getTimer();
			for (var i:int = 0; i < $burst; i++) {
				createParticle((life > 0) ? randomLife() : 0);
			}
			//trace("Loop time: " + String(getTimer()-times));
		}
		
		/**
		 *	@private
		 */
		protected function createParticle($totalLife:Number = 0, $remainingLife:Number = 0):IBasicParticle {
			var np:* = pool.addParticle(); //this is where we would pass the clean method?
			np.init(this);
			//trace("ID: " + np.id);
			if(!np.isbuilt){
				np.blendMode = particleBlendMode;
				if(particleFilters != []) np.filters = particleFilters;
			}
			if(!np.isbuilt || forceVariety){
				if(groupBitmap) np.makeGroupBitmap(_particlebitmap, groupAmount, groupProximity, _particleOrigin);
				else np.makeGroup(particle, groupAmount, groupProximity);
			}
			if($remainingLife > 0){
				np.addLife($remainingLife);
				np.life = $totalLife;
			} else if($totalLife > 0) np.addLife($totalLife);
			if(enableEvents) dispatchEvent(new ParticleEvent(ParticleEvent.BORN, {particle:np}));
			renderer.addParticle(np);
			return np;
		}
		
		/**
		 *	This creates the main bitmapdata object used when groupBitmap == true.
		 *	
		 *	@param	padding	 Padding around the image (to compensate for filters).
		 */
		public function createParticleBitmap($padding:int = 0):void {
			var psource:DisplayObject = new particle();
			var smatx:Matrix = psource.transform.concatenatedMatrix;
			var srect:Rectangle = psource.transform.pixelBounds;
			_particleOrigin = new Point(srect.x/smatx.a, srect.y/smatx.a)
			var smx:Matrix = new Matrix();
			smx.translate(-((srect.x/smatx.a)-$padding), -((srect.y/smatx.a)-$padding));
			_particlebitmap = new BitmapData(psource.width+($padding*2), psource.height+($padding*2), true, 0);
			_particlebitmap.draw(psource, smx);
			psource = null;
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
			txml.@particleBaseClass = XMLHelper.getSimpleClassName(particleBaseClass);
			txml.@particleBlendMode = particleBlendMode;
			txml.@eps = eps;
			txml.@burst = burst;
			txml.@life = life;
			txml.@lifeSpread = XMLHelper.xmlize(lifeSpread);
			txml.@groupBitmap = XMLHelper.xmlize(groupBitmap);
			txml.@groupAmount = groupAmount;
			txml.@groupProximity = groupProximity;
			txml.appendChild(<Renderer />);
			var rt:String = XMLHelper.getSimpleClassName(renderer);
			txml.Renderer.@type = rt;
			if(rt == "StandardRenderer" || rt == "BitmapRenderer"){
				txml.Renderer.@order = renderer.order;
			}
			if(rt == "BitmapRenderer" || rt == "PixelRenderer"){
				txml.Renderer.@fade = renderer.fade;
				txml.Renderer.@fadeBlur = renderer.fadeBlur;
				txml.Renderer.@predraw = XMLHelper.xmlize(renderer.predraw);
			}
			txml.appendChild(<Filters />);
			for (var f:int = 0; f < particleFilters.length; f++) {
				txml.Filters.children()[f] = XMLHelper.objectToXML(particleFilters[f]);
			}
			return txml;
		}
		
		/**
		 *	This configures the emitter based on the XML, and adds any controllers (if available)
		 *	
		 *	@param	xml	 The XML object to use to configure the emitter
		 *	@param	reset	 Resets the emitter before applying XML and also purges the pool
		 *	@param	renderer	If true, this creates (and overwrites) the emitter's renderer with one from XML. If this is a BitmapRenderer, be sure to call resize(width, height) on it after the XML. Also, for BasicEmitters only (to save file size), you must create a reference to the Renderers you're going to use before using it through XML (for Flash to include the classes). This can be done easily as <code>var renderers:Array = [NullRenderer, StandardRenderer, BitmapRenderer];</code> (this is done already for the Emitter and IDEEmitter classes).
		 *	
		 *	@return		The emitter object (for chaining)
		 */
		public function fromXML($xml:XML, $reset:Boolean = true, $renderer:Boolean = false):* {
			if($reset) reset();
			try {
				if($xml.@particle != undefined) particle = getDefinitionByName($xml.@particle) as Class;
				if($xml.@particleBaseClass != undefined) particleBaseClass = (getDefinitionByName("com.desuade.partigen.particles::" + $xml.@particleBaseClass) as Class) || BasicParticle;
				if($xml.@particleBlendMode != undefined) particleBlendMode = String($xml.@particleBlendMode);
				if($xml.@eps != undefined) eps = Number($xml.@eps);
				if($xml.@burst != undefined) burst = int($xml.@burst);
				if($xml.@groupBitmap != undefined) groupBitmap = XMLHelper.dexmlize($xml.@groupBitmap);
				if($xml.@groupAmount != undefined) groupAmount = int($xml.@groupAmount);
				if($xml.@groupProximity != undefined) groupProximity = int($xml.@groupProximity);
				if($xml.@life != undefined) life = Number($xml.@life);
				if($xml.@lifeSpread != undefined) lifeSpread = XMLHelper.dexmlize($xml.@lifeSpread);
				if($renderer){
					if($xml.hasOwnProperty("Renderer")){
						var rt:String = $xml.Renderer.@type;
						var contclass:Class = getDefinitionByName("com.desuade.partigen.renderers::" + rt) as Class;
						if(rt == "NullRenderer"){
							renderer = new contclass();
						} else if(rt == "StandardRenderer"){
							renderer = new contclass(this.parent, ($xml.Renderer.@order != undefined) ? String($xml.Renderer.@order) : null);
						} else if(rt == "BitmapRenderer"){
							renderer = new contclass(1, 1, ($xml.Renderer.@order != undefined) ? String($xml.Renderer.@order) : null);
						} else if(rt == "PixelRenderer"){
							renderer = new contclass(1, 1);
						}
						if(rt == "BitmapRenderer" || rt == "PixelRenderer"){
							if($xml.Renderer.@fade != undefined) renderer.fade = Number($xml.Renderer.@fade);
							if($xml.Renderer.@fadeBlur != undefined) renderer.fadeBlur = int($xml.Renderer.@fadeBlur);
							if($xml.Renderer.@predraw != undefined) renderer.predraw = XMLHelper.dexmlize($xml.Renderer.@predraw);
						}
					}
				}
				if($xml.hasOwnProperty("Filters")){
					var xl:XMLList = $xml.Filters.children();
					for (var i:int = 0; i < xl.length(); i++) {
						particleFilters.push(XMLHelper.objectFromXML(xl[i]));
					}
				}
				return this;
			} catch (e:Error){
				Debug.output('partigen', 20009, [e]);
				return false;
			}
		}
		
		/**
		 *	This resets the emitter to the defaults and purges the pool
		 */
		public function reset():void {
			particleBaseClass = BasicParticle, eps = 1, burst = 1;
			groupAmount = 1, groupProximity = 0, life = 0, lifeSpread = "0", particleFilters = [], particleBlendMode = "normal";
			_particlebitmap = null;
			pool.purge();
		}
		
		/**
		 *	This kills all currently existing particles in the pool created by this emitter
		 */
		public function killParticles():void {
			for each (var particle:IBasicParticle in pool.particles) {
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
		public function dispatchDeath(p:IBasicParticle):void {
			if(enableEvents) dispatchEvent(new ParticleEvent(ParticleEvent.DIED, {particle:p}));
		}
		
		/**
		 *	@private
		 */
		protected function prefetchstart($o:Object = null):void {
			setTimer(true);
			emit(burst);
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
