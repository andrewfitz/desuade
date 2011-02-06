/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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
	
	import com.desuade.partigen.Partigen;
	import com.desuade.utils.*;
	import com.desuade.partigen.interfaces.*;
	import com.desuade.debugging.*;
	
	/**
	 *  This is a basic particle pool that uses actual object pooling to reuse particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  03.06.2010
	 */
	public class BasicPool extends Pool {
		
		/**
		 *	@private
		 */
		protected var _pool:BasicObjectPool = null;
		
		/**
		 *	The starting size and rate of expansion of the object pool
		 */
		public var expandSize:int;
		
		/**
		 *	This creates a basic particle pool using object pooling.
		 *	
		 *	@param	particleClass	 The baseParticleClass to use for the particles
		 *	@param	expandSize	 The size of each expansion for the object pool
		 */
		public function BasicPool($particleClass:Class, $expandSize:int = 50) {
			super($particleClass);
			expandSize = $expandSize;
			setClass(_particleClass);
		}
		
		/**
		 *	This clears all particles in the object pool and will not check any currently living particles back into the object pool.
		 */
		public override function purge():void {
			for (var p:* in _particles) p.destroy = true;
			if(_pool != null) {
				for (var i:int = 0; i < _pool.list.length; i++) _pool.list[i].removeGroup();
				_pool.dispose();
			}
			_pool = new BasicObjectPool(_particleClass, _particleClass.clean, expandSize, 0);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function set onLastParticle($func:Function):void {
			_pool.onLastCheckIn = $func;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function get onLastParticle():Function{
			return _pool.onLastCheckIn;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function setClass($particleClass:Class):void {
			super.setClass($particleClass);
			purge();
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle():IBasicParticle {
			super.addParticle();
			var tp:* = _pool.checkOut();
			_particles[tp] = tp.id;
			return tp;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($particle:*):void {
			super.removeParticle($particle);
			if($particle.destroy != undefined && $particle.destroy) {
				$particle.removeGroup();
				_particles[$particle] = null;
			} else {
				$particle.isbuilt = true;
				_pool.checkIn($particle);
			}
			delete _particles[$particle];
		}
	
	}

}
