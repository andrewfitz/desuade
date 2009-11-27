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
	
	import flash.display.*;
	
	import com.desuade.utils.Random;
	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;
	
	/**
	 *  This uses the standard DisplayList to display particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class StandardRenderer extends Renderer {
		
		/**
		 *	A visible DisplayObject that will "hold" the particles on the screen.
		 */
		public var target:DisplayObjectContainer;
		
		/**
		 *	The visual stacking order for new particles to be created – 'top', 'bottom', or 'random'.
		 */
		public var order:String;
		
		/**
		 *	Creates a new StandardRenderer. This will use a DisplayObject and the standard Flash way to show particles on screen. Particles will be created "inside" the object via <code>addChild()</code>.
		 *	
		 *	@param	target	 The target parent DisplayObject to create child particles in.
		 *	@param	order	 The visual stacking order for new particles to be created – 'top', 'bottom', or 'random'.
		 */
		public function StandardRenderer($target:DisplayObjectContainer, $order:String = 'top') {
			super();
			order = $order;
			target = $target;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle($p:BasicParticle):void {
			switch (order) {
				case 'top' :
					target.addChild($p);
				break;
				case 'bottom' :
					target.addChildAt($p, 0);
				break;
				case 'random' :
					target.addChildAt($p, Random.fromRange(0, target.numChildren, 0));
				break;
			}
			super.addParticle($p);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($p:BasicParticle):void {
			super.removeParticle($p);
			target.removeChild($p);
		}
	
	}

}
