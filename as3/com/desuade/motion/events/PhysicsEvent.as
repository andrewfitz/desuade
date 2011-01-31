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
	 *  This event is created by the BasicPhysics class in the motion package.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  23.04.2009
	 */
	public class PhysicsEvent extends MotionEvent {
		
		/**
		 *	This event is fired when a BasicPhysics object starts.
		 */
		public static const STARTED:String = "started";
		
		/**
		 *	<p>This event is fired when a BasicPhysics object is updating the target's property.</p>
		 *	<p>This does not get fired by default, and will only boradcast if update:true is passed to the config</p>
		 */
		public static const UPDATED:String = "updated";
		
		/**
		 *	This event is fired when a BasicPhysics object stops.
		 */
		public static const ENDED:String = "ended";
		
		/**
		 *	<p>This this object that gets passed when an event is fired. It contains the BasicPhysics object and PrimitivePhysics: <code>base</code> and <code>primitive</code></p>
		 */
		public var data:Object;
		
		/**
		 *	Creates a new PhysicsEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function PhysicsEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}

		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new TweenEvent(this.type, this.data, this.bubbles, this.cancelable);
		}

	}

}