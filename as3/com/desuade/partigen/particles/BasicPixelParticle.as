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

package com.desuade.partigen.particles {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.display.*;
	
	import com.desuade.partigen.interfaces.*;
	import com.desuade.debugging.Debug;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.partigen.events.ParticleEvent;
	import com.desuade.utils.*;
	
	/**
	 *  A basic, high-performance BasicParticle for use with the PixelRenderer.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.04.2010
	 */
	public class BasicPixelParticle extends Object implements IBasicParticle {
		
		/**
		 *	The x value of the pixel.
		 */
		public var x:int = 0;
		
		/**
		 *	The y value of the pixel.
		 */
		public var y:int = 0;
		
		/**
		 *	This is the alpha value of the pixel.
		 */
		public var alpha:Number = 1;
		
		/**
		 *	This is the pixel color.
		 */
		public var color:uint = 0xffffffff;
	
		/**
		 *	This holds the particles inside of the group.
		 */
		public var group:Array;
		
		/**
		 *	@private
		 */
		protected var _emitter:BasicEmitter;
		
		/**
		 *	@private
		 */
		protected var _renderer;
		
		/**
		 *	@private
		 */
		protected var _pool;
		
		/**
		 *	@private
		 */
		protected var _id:int;
		
		/**
		 *	The life of the particle: how long the particle will live for. This also effects the duration of controller tweens.
		 */
		public var life:Number;
		
		/**
		 *	@private
		 */
		protected var _lifeTimer:Timer;
		
		/**
		 *	<p>Creates a new pixel particle for the PixelRenderer. This should normally not be called; use <code>emitter.emit()</code> instead of this.</p>
		 *	
		 *	@see	com.desuade.partigen.emitters.BasicEmitter#emit()
		 */
		public function BasicPixelParticle() {
			super();
		}
		
		/**
		 *	@private
		 */
		public function init($emitter:BasicEmitter):void {
			_emitter = $emitter, _renderer = $emitter.renderer, _pool = $emitter.pool, _id = BasicParticle._count++;
			Debug.output('partigen', 50001, [id]);
		}
		
		/**
		 *	@private
		 */
		public function makeGroup($particle:Class, $amount:int, $proximity:int):void {
			
			///chage this for pixel
			
			
			/*
			group = [];
			for (var i:int = 0; i < $amount; i++) {
				group[i] = new $particle();
				if($proximity > 0){
					group[i].x = Random.fromRange(-$proximity, $proximity, 0);
					group[i].y = Random.fromRange(-$proximity, $proximity, 0);
				}
				//add child
			}
			*/
		}
		
		//irrelevant
		/**
		 *	@private
		 */
		public function makeGroupBitmap($particleData:BitmapData, $amount:int, $proximity:int, $origin:Point):void {
		}
		
		/**
		 *	The unique id of the particle.
		 */
		public function get id():int{
			return _id;
		}
		
		/**
		 *	The parent emitter that emitted this particle.
		 */
		public function get emitter():BasicEmitter{
			return _emitter;
		}
		
		/**
		 *	This instantly kills the particle and dispatches a "DIED" event.
		 */
		public function kill(... args):void {
			if(_lifeTimer != null){
				removeLife();
			}
			_emitter.dispatchDeath(this);
			Debug.output('partigen', 50002, [id]);
			_renderer.removeParticle(this);
			_pool.removeParticle(this.id);
		}
		
		/**
		 *	@private
		 */
		public function addLife($life:Number):void {
			life = $life;
			_lifeTimer = new Timer($life*1000);
			_lifeTimer.addEventListener(TimerEvent.TIMER, kill, false, 0, false);
			_lifeTimer.start();
		}
		
		/**
		 *	@private
		 */
		public function removeLife():void {
			_lifeTimer.removeEventListener(TimerEvent.TIMER, kill);
			_lifeTimer.stop();
			_lifeTimer = null;
		}
		
		//holder variables for things that don't affect the pixel
		
		public function get blendMode():String{
			return 'normal';
		}
		public function set blendMode(value:String):void {
			//nothing
		}
		public function get filters():Array{
			return [];
		}
		public function set filters(value:Array):void {
			//nothing
		}
	
	}

}
