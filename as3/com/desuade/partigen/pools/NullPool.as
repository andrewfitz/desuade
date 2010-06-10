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

package com.desuade.partigen.pools {
	
	import com.desuade.partigen.Partigen;
	import com.desuade.partigen.interfaces.*;
	import com.desuade.debugging.*;

	/**
	 *  This offers basic object storage without any real 'pooling'.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class NullPool extends Pool {
	
		/**
		 *	Creates a NullPool to store particle objects. This can be used with multiple emitters.
		 *	
		 *	@param	particleClass	 The class of particle the pool will create.
		 */
		public function NullPool($particleClass:Class) {
			super($particleClass);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle():IBasicParticle {
			super.addParticle();
			var tp:* = new _particleClass();
			_particles[tp] = true;
			return tp;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($particle:*):void {
			super.removeParticle($particle);
			$particle.removeGroup();
			_particles[$particle] = null;
			delete _particles[$particle];
		}
	
	}

}
