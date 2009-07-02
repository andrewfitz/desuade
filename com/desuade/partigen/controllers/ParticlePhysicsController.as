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
	
	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;

	public dynamic class ParticlePhysicsController extends Object {
		
		/**
		 *	The boolean flip (for cartesian reversal) value to be passed to the internal 'physics' object.
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public var flip:Boolean;
		
		protected var _duration:Number;
			
		public function ParticlePhysicsController($duration:Number, $containerclass:Class = null, $tweenclass:Class = null) {
			super();
			_duration = $duration;
			this.velocity = new ParticleTweenController($duration, $containerclass, $tweenclass);
			this.acceleration = new ParticleTweenController($duration, $containerclass, $tweenclass);
			this.friction = new ParticleTweenController($duration, $containerclass, $tweenclass);
			this.velocity.keyframes.precision = 3;
			this.acceleration.keyframes.precision = 3;
			this.friction.keyframes.precision = 3;
		}
		
		public function get duration():Number{
			return _duration;
		}
		
		public function set duration($value:Number):void {
			_duration = $value;
			for (var p:String in this) {
				this[p].duration = $value;
			}
		}
	
	}

}
