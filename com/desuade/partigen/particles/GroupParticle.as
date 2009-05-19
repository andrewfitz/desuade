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
	
	import com.desuade.utils.*;

	public dynamic class GroupParticle extends Particle {
		
		/**
		 *	This holds the particles inside of the group.
		 */
		public var particles:Object = {};
	
		/**
		 *	This creates a new particle group for the Particle class. This is handled internally and should not be called manually.
		 *	
		 *	@param	particle	 The particle class to use for new particles.
		 *	@param	amount	 The amount of particles to create inside the group.
		 *	@param	proximity	 This determines the maximum distance away from the center of the group to create new particles.
		 */
		public function GroupParticle($particle:Class, $amount:int, $proximity:int) {
			super();
			for (var i:int = 0; i < $amount; i++) {
				particles[i] = new $particle();
				particles[i].x = Random.fromRange(-$proximity, $proximity, 0);
				particles[i].y = Random.fromRange(-$proximity, $proximity, 0);
				this.addChild(particles[i]);
			}
		}
		
	}

}
