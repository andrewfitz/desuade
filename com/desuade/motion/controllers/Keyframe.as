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
	
	/**
	 *  Used by KeyframeContainers to set a point for a change in value during a tween
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public class Keyframe extends Object {
		
		/**
		 *	The value for the given property at this keyframe.
		 *	
		 *	This can either be an absolute value (as a Number) or a relative value (as a String).
		 */
		public var value:*;
		
		/**
		 *	The spread value for the current keyframe. If this is anything besides '0', it will create a random value in between the 'value' and this spread value.
		 *	
		 *	This can either be an absolute value (as a Number) or a relative value (as a String).
		 */
		public var spread:*;
		
		/**
		 *	A value in between 0 and 1 that specifies the relative position of the keyframe.
		 *	
		 *	This will effect the duration of the tween, along with the controller's 'duration' value.
		 */
		public var position:Number;
		
		/**
		 *	The ease to use to tween to this value.
		 *	
		 *	Note: the ease is used for tweens that end with this value, so the ease value on the 'begin' keyframe is irrelevant.
		 */
		public var ease:Function;
		
		/**
		 *	An object of any extra properties to be passed to the tweening engine. Such as 'bezier', 'type', 'amount', etc.
		 */
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
		 *	@param	value	 A value to tween to. The target will arive (the tween will end) at this value at the position of this point. Pass a Number for absolute, or a String for relative. null will use the target's start value.
		 *	@param	ease	 What ease function to use. Ease functions like Bounce.easeOut, etc. null will default to Linear.none
		 *	@param	spread	 A value to create a random range from. If the spread doesn't equal the 'value' value or '0', a random value will be created between the 'value' and the 'spread'. Pass a Number for absolute, or a String for relative.
		 *	@param	extras	An object that contains extra paramaters for the tween (depends on the tweenClass used in the KeyframeContainer)
		 */
		public function Keyframe($position:Number, $value:* = null, $ease:Function = null, $spread:* = null, $extras:Object = null) {
			super();
			position = $position;
			value = $value;
			ease = $ease || Linear.none;
			spread = $spread || "0";
			extras = $extras || {};
		}
	
	}

}
