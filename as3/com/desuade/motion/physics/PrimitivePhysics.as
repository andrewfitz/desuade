/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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

package com.desuade.motion.physics {
	
	import com.desuade.motion.bases.*;
	
	/**
	 *  This is a primitive physics object that applies velocity, acceleration, and friction.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.07.2009
	 */
	public class PrimitivePhysics extends BasePrimitive {
		
		/**
		 *	The velocity of the property. This is added to the current value every frame - ie: FPS of 50, with a velocity of 2 = 100/second.
		 */
		public var velocity:Number;
		
		/**
		 *	The acceleration of the property. This is added to the current velocity. A negative acceleration would represent gravity.
		 */
		public var acceleration:Number;
		
		/**
		 *	Setting this to true will 'flip' the way the property is handled. This is for properties such as 'y' that are reversed from the cartesian coordinate system.
		 */
		public var flip:Boolean;
		
		/**
		 *	How long the physics calculations should be applied for.
		 */
		public var duration:int = 0;
		
		/**
		 *	@private
		 */
		protected var _friction:Number;
		
		/**
		 *	@private
		 */
		protected var _calcfriction:Number;
		
		/**
		 *	The PrimitivePhysics object.
		 */
		public function PrimitivePhysics() {
			super();
		}
		
		/**
		 *	This inits the PrimitivePhysics.
		 */
		public override function init(... args):void {
			super.init(args[0], args[1]);
			velocity = args[2], acceleration = args[3], friction = args[4], flip = args[5], duration = args[6];
		}
		
		/**
		 *	The friction of the property. This will slow down the velocity to 0 if there is no acceleration. Should be a positive number.
		 */
		public function set friction($value:Number):void {
			_calcfriction = (1 - ($value / 100));
			_friction = $value;
		}
		
		/**
		 *	@private
		 */
		public function get friction():Number{
			return _friction;
		}
		
		/**
		 *	@private
		 */
		public override function render($time:int):void {			
			velocity += acceleration;
			velocity *= _calcfriction;
			if(flip) target[property] -= velocity;
			else target[property] += velocity;
			updateFunc(this);
			if(duration > 0) {
				$time -= starttime;
				if($time >= duration) end();
			}
		}
	
	}

}
