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

package com.desuade.motion.events {

	import flash.events.Event;
	
	/**
	 *  This event is created by controller classes in the Motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class ControllerEvent extends MotionEvent {
		
		/**
		 *	This event is fired when a controller starts at the 'begin' point.
		 */
		public static const STARTED:String = "started";
		
		/**
		 *	This event is fired when a controller gets to and begins a tween from the next point.
		 */
		public static const ADVANCED:String = "advanced";
		
		/**
		 *	This event is fired when a controller finishes and reaches the 'end' point.
		 */
		public static const ENDED:String = "ended";

		/**
		 *	<p>This this object that gets passed that has different objects depending on what event:</p>
		 *	
		 *	<p>STARTED and ENDED: <code>controller</code></p>
		 *	<p>ADVANCED: <code>controller</code> and <code>position</code></p>
		 */
		public var data:Object;

		/**
		 *	Creates a new ControllerEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function ControllerEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new ControllerEvent(this.type, this.data, this.bubbles, this.cancelable);
		}

	}

}