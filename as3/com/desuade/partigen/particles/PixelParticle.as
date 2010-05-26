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

package com.desuade.partigen.particles {
	
	import com.desuade.partigen.interfaces.*;
	import com.desuade.debugging.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.events.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.motion.controllers.*;
	
	/**
	 *  A basic, high-performance Particle for use with the PixelRenderer.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.04.2010
	 */
	public dynamic class PixelParticle extends BasicPixelParticle implements IParticle {
		
		/**
		 *	This holds all of the MotionControllers that are currently being ran on the particle.
		 */
		public var controllers:Object = {};
	
		/**
		 *	<p>Creates a new pixel particle for the PixelRenderer. This should normally not be called; use <code>emitter.emit()</code> instead of this.</p>
		 *	
		 *	@see	com.desuade.partigen.emitters.Emitter#emit()
		 */
		public function PixelParticle() {
			super();
		}
		
		/**
		 *	@private
		 */
		public function startControllers($startTime:Number = 0):void {
			for (var p:String in controllers) {
				if(controllers[p] is MotionController && controllers[p].keyframes.isFlat()){
					controllers[p].setStartValue();
				} else {
					controllers[p].start('begin', $startTime);
					if(controllers[p] is PhysicsMultiController) controllers[p].physics.startAtTime($startTime);
				}
			}
		}
		
		/**
		 *	@private
		 */
		public function stopControllers():void {
			for (var p:String in controllers) {
				if(controllers[p].active){
					controllers[p].stop();
				}
				if(controllers[p] is PhysicsMultiController) controllers[p].physics.stop();
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function kill(... args):void {
			stopControllers();
			super.kill(args);
		}
	
	}

}
