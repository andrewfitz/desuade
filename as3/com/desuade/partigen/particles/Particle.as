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
	
	import flash.display.Sprite;
	
	import com.desuade.debugging.*;
	import com.desuade.partigen.emitters.*;
	import com.desuade.partigen.events.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.motion.controllers.*;
	
	/**
	 *  This is the standard particle class used with the Emitter class that includes MotionControllers.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  08.05.2009
	 */
	public dynamic class Particle extends BasicParticle {
		
		/**
		 *	This holds all of the MotionControllers that are currently being ran on the particle.
		 */
		public var controllers:Object = {};
	
		/**
		 *	Creates a new particle. This should normally not be called; use <code>emitter.emit()</code> instead of this.
		 *	
		 *	@see	com.desuade.partigen.emitters.Emitter#emit()
		 */
		public function Particle() {
			super();
		}
		
		/**
		 *	This sets/gets both X and Y scales at once.
		 */
		public function get scale():Number{
			return scaleX;
		}
		
		/**
		 *	@private
		 */
		public function set scale($value:Number):void {
			scaleX = scaleY = $value;
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
					if(controllers[p] is PhysicsMultiController) controllers[p].physics.start('begin', $startTime);
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
