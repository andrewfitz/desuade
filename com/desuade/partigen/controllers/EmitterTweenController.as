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
	import com.desuade.partigen.emitters.*;
	
	/**
	 *  This is a controller for the emitter that inherits a MotionController
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public class EmitterTweenController extends MotionController {
		
		/**
		 *	This creates an EmitterTweenController (which is basically a MotionController). Using the addTween() method is recommended over calling this directly.
		 *	
		 *	@param	target	 The emitter to tween
		 *	@param	property	 The property to control
		 *	@param	duration	 The entire duration for the controller. Since the emitter always exists, there must be a set duration.
		 *	@param	containerclass	 The class to use for Keyframes. Null will use the default.
		 *	@param	tweenclass	 The class to use for tweening on the controller. Null will use the default.
		 */
		public function EmitterTweenController($target:Emitter, $property:String, $duration:Number, $containerclass:Class = null, $tweenclass:Class = null) {
			super($target, $property, $duration, $containerclass, $tweenclass || EmitterController.tweenClass);
		}
	
	}

}

