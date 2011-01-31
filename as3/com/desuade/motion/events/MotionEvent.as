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
	 *  This base event is created by any of the classes in the motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class MotionEvent extends Event {
		
		/**
		 *	This event gets broadcasted when a MotionObject starts.
		 */
		public static const STARTED:String = "started";
		
		/**
		 *	This event gets broadcasted when a value is updated.
		 */
		public static const UPDATED:String = "updated";
		
		/**
		 *	This event gets broadcasted when a sequence moves to the next item.
		 */
		public static const ADVANCED:String = "advanced";
		
		/**
		 *	This event gets broadcasted when a MotionObject ends.
		 */
		public static const ENDED:String = "ended";
		
		/**
		 *	Creates a new MotionEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function MotionEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new MotionEvent(this.type, this.bubbles, this.cancelable);
		}
		
	}
	
}