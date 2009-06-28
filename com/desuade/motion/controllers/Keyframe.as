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

package com.desuade.motion.controllers {

	import com.desuade.motion.eases.Linear;
	
	public class Keyframe extends Object {
	
		public var value:*;
		
		public var spread:*;
		
		public var position:Number;
		
		public var ease:Function;
		
		public var extras:Object;
		
		/**	
		 *	"Keyframes" in the motion package are very similar to a keyframe on the timeline or the motion editor in Flash (and many other programs). They all have a value, ease, spread, position, and an extras property.
		 *	
		 *	The MotionController starts at the 'begin' keyframe, and creates a sequence of tweens connecting from keyframe-to-keyframe, all the way to the 'end' keyframe. Think in terms of a line graph, each keyframe is a 'point' on the line.
		 *	
		 *	Note: the engine uses time (seconds) instead of actual frames to create motion, so these ARE NOT timeline keyframes, but rather a "virtual" specific spot during the duration of a controller where a value is changed (just like real, frame-based keyframes).
		 *	
		 *	If no keyframes are added, the MotionController will simply create 1 tween from 'begin' to 'end'.
		 *	
		 *	@param	position	 A value between 0-1 that reprsents the position of the point, 0 being the beginning of the controller and 1 being the end point (0 and 1 are already taken by 'begin' and 'end' points)
		 *	@param	value	 A value to tween to. The target will arive (the tween will end) at this value at the position of this point. Pass a Number for absolute, or a String for relative.
		 *	@param	ease	 What ease function to use. Ease functions like Bounce.easeOut, etc. null will default to Linear.none
		 *	@param	spread	 A value to create a random range from. If the spread doesn't equal the 'value' value or '0', a random value will be created between the 'value' and the 'spread'. Pass a Number for absolute, or a String for relative.
		 *	@param	extras	An object that contains extra paramaters for the tween (depends on the tweenclass used in the KeyframeContainer)
		 */
		public function Keyframe($position:Number, $value:*, $ease:Function = null, $spread:* = '0', $extras:Object = null) {
			super();
			position = $position;
			value = $value;
			ease = ($ease == null) ? Linear.none : $ease;
			spread = $spread;
			extras = $extras || {};
		}
	
	}

}
