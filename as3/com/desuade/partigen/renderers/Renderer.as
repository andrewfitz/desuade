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

package com.desuade.partigen.renderers {
	
	import com.desuade.partigen.interfaces.*;
	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *  This controls how the particles are displayed (rendered). This is controlled internally.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public dynamic class Renderer extends EventDispatcher {
	
		/**
		 *	This creates a new Renderer. This base class should not be created, as it offers no direct functionality.
		 */
		public function Renderer() {
			super();
			Debug.output('partigen', 20002);
		}
		
		/**
		 *	This adds a particle to the display.
		 *	
		 *	@param	p	 The particle to add.
		 */
		public function addParticle($p:IBasicParticle):void {
			Debug.output('partigen', 40002, [$p.id]);
		}
		
		/**
		 *	This removes a particle from the display.
		 *	
		 *	@param	p	 The particle to remove.
		 */
		public function removeParticle($p:IBasicParticle):void {
			Debug.output('partigen', 40004, [$p.id]);
		}
	
	}

}
