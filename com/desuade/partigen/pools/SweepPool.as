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

package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.debugging.*;
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;

	/**
	 *  This offers basic object storage and removes objects in intervals.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.22.2009
	 */
	public class SweepPool extends NullPool {
		
		/**
		 *	@private
		 */
		protected var _interval:int;
		
		/**
		 *	@private
		 */
		protected var _marked:Array = [];
		
		/**
		 *	@private
		 */
		protected var _sweepTimer:Timer;
	
		/**
		 *	Creates a SweepPool to store particle objects. This can be used with multiple emitters.
		 *	
		 *	@param	interval	  The interval in ms to run a sweep.
		 */
		public function SweepPool($interval:int=4000) {
			super();
			startSweeper($interval);
		}
		
		/**
		 *	The current interval in ms for each sweep.
		 */
		public function get interval():int{
			return _interval;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($id:int):void {
			mark($id);
		}
		
		/**
		 *	@private
		 */
		protected function mark($id:int):void {
			_marked.push($id);
			Debug.output('partigen', 40006, [$id]);
		}
		
		/**
		 *	This starts the sweeper to periodically remove objects from the pool.
		 *	
		 *	@param	interval	 The interval in ms to run a sweep.
		 *	
		 */
		public function startSweeper($interval:int):void {
			_interval = $interval;
			_sweepTimer = new Timer(_interval);
			_sweepTimer.addEventListener(TimerEvent.TIMER, sweep, false, 0, false);
			_sweepTimer.start();
			Debug.output('partigen', 20004);
		}
		
		/**
		 *	This stops the sweeper.
		 */
		public function stopSweeper():void {
			_sweepTimer.removeEventListener(TimerEvent.TIMER, sweep);
			_sweepTimer.stop();
			_sweepTimer = null;
			Debug.output('partigen', 20005);
		}
		
		/**
		 *	This deletes the objects that have been marked for removal by the pool all at once.
		 */
		public function sweep($o:Object):void {
			Debug.output('partigen', 20006, [getTimer(), _marked.length]);
			for (var i:int = 0; i < _marked.length; i++) {
				_particles[_marked[i]] = null;
				delete _particles[_marked[i]];
				super.removeParticle(_marked[i]);
			}
			Debug.output('partigen', 20007, [getTimer()]);
			_marked = [];
		}
	
	}

}
