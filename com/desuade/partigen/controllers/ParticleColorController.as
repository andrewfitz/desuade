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

package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	
	/**
	 *  This controls the color of a particle over it's life.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  05.05.2009
	 */
	public class ParticleColorController extends Object {
		
		/**
		 *	This is a special PointsContainer for colors. This is what's used to store and manage points. To add, remove, and work with points, see the documentation on PointsContainers.
		 */
		public var points:ColorPointsContainer;
		
		/**
		 *	The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 */
		public var duration:Number;
		
		/**
		 *	<p>This creates a new ColorValueController for an emitter's particles.</p>
		 *	<p>Use this to create random colors for particles, change the colors over a particle's life, the start color, etc.</p>
		 *	
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 *	
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 */
		public function ParticleColorController($duration:Number) {
			super();
			duration = $duration;
			points = new ColorPointsContainer();
		}
	
	}

}
