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

package com.desuade.partigen.particles {
	
	import flash.display.Sprite;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import com.desuade.debugging.Debug;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.partigen.events.ParticleEvent;

	/**
	 *  The most basic form of Particle, only the minimum necessary.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public dynamic class BasicParticle extends Sprite {
		
		/**
		 *	@private
		 */
		protected static var _count:int = 0;
		
		/**
		 *	@private
		 */
		protected var _emitter:BasicEmitter;
		
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
		 *	Creates a new particle. This should normally not be called; use <code>emitter.emit()</code> instead of this.
		 *	
		 *	@see	com.desuade.partigen.emitters.BasicEmitter#emit()
		 */
		public function BasicParticle() {
			super();
		}
		
		/**
		 *	@private
		 */
		public function init($emitter:BasicEmitter):void {
			_emitter = $emitter;
			_id = _count++;
			Debug.output('partigen', 50001, [id]);
		}
		
		/**
		 *	The amount of total particles created.
		 */
		public static function get count():int { 
			return _count; 
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
				_lifeTimer.removeEventListener(TimerEvent.TIMER, kill);
				_lifeTimer.stop();
				_lifeTimer = null;
			}
			_emitter.dispatchDeath(this);
			Debug.output('partigen', 50002, [id]);
			_emitter.renderer.removeParticle(this);
			_emitter.pool.removeParticle(this.id);
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
	
	}

}
