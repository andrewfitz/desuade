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

package com.desuade.partigen {

	import com.desuade.debugging.*
	
	/**
	 *  This is the CodeSet for Partigen.
	 *	
	 *	@private
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class DebugCodesPartigen extends CodeSet {
		
		public function DebugCodesPartigen() {
			super();
			
			setname = 'partigen';
			codes = {
				10000: "Partigen debug codes for aiding in development.",
				10001: "Test code for $ and $",
				
				//
				20001: "[Emitter] new emitter created",
				20002: "[Renderer] new renderer created",
				20003: "[Pool] new particle pool created",
				
				//
				40001: "[Emitter] running update on emitter: $ at: $",
				40002: "[Renderer] particle (id:$) was added to the renderer",
				40003: "[Pool] particle (id:$) was added to the pool",
				40004: "[Renderer] particle (id:$) was removed from the renderer",
				40005: "[Pool] particle (id:$) was removed from the pool",
				
				//particle events
				50001: "[Particle] a new particle was born (id:$)",
				50002: "[Particle] a particle died (id:$)"
			}
			
		}
	
	}

}
