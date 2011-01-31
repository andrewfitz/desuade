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

package com.desuade.motion {

	import com.desuade.debugging.*
	
	/**
	 *  This is the CodeSet for the Motion Package.
	 *	
	 *	@private
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class DebugCodesMotion extends CodeSet {
		
		public function DebugCodesMotion() {
			super();
			
			setname = 'motion';
			codes = {
				10000: "Motion debug codes for aiding in development.",
				10001: "",
				10002: "[MotionController] controlled tween for % ended",
				10003: "[MotionController] can not stop, controller not active",
				10004: "[Tween] can not stop, tween has completed",
				10005: "[Tween] can not start, tween has completed",
				10006: "[Sequence] can not start, sequence is already active or has no items",
				10007: "[Sequence] can not stop/advance, sequence is not active",
				10008: "Direct functions can't be converted to XML. Please make your ease a String instead - ie: ease:'easeOutBounce'",
				
				// low level codes
				40001: "[Tween] new tween created",
				40002: "[Tween] tween delayed for % seconds",
				40003: "[Sequence] new sequence created",
				40004: "[Sequence] sequence now playing at position %",
				40005: "[Sequence] sequence ended",
				40006: "[Sequence] simulating new position at %", //removed
				40007: "[Tween] starting tween at position: %",
				40008: "[Sequence] sequence started",
				40009: "[Physics] new physics object created",
				40010: "[Physics] physics engine started",
				40011: "[Physics] physics engine stopped",
				40012: "[Sequence] new SequenceGroup created",
				
				//primitive low level codes
				50001: "[Primitive] created id: %",
				50002: "[Primitive] removed id: %",
				50003: "[Tween] rounding tween %: % -> %",
				50004: "Depreciated: eases should be String, not the Function - ie: Bounce.easeOut -> 'easeOutBounce'"
				
			}
			
		}
	
	}

}
