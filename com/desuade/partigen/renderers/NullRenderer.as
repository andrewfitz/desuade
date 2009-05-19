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

package com.desuade.partigen.renderers {

	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;

	/**
	 *  This will not display any particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class NullRenderer extends Renderer {
	
		/**
		 *	Creates a new NullRenderer. Renderers can be reused and used for multiple emitters.
		 */
		public function NullRenderer() {
			super();
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle($p:BasicParticle):void {
			super.addParticle($p);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($p:BasicParticle):void {
			super.removeParticle($p);
		}
	
	}

}
