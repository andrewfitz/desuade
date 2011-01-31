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

package com.desuade.partigen.events {

	import flash.events.Event;
	
	/**
	 *  Events for particles. Events are broadcasted from the emitter.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class ParticleEvent extends Event {
		
		/**
		 *	This gets fired everytime a particle is born.
		 */
		public static const BORN:String = "born";
		
		/**
		 *	This gets fired everytime a particle dies. Occurs naturally, or when kill() is called.
		 */
		public static const DIED:String = "died";
		
		/**
		 *	This is the info object that's gets passed to the function. It contains the <code>particle</code> property, that is the particle that the event is associated with.
		 */
		public var data:Object;

		/**
		 *	Creates a new ParticleEvent. Events get dispatched internally, manual creation isn't necessary.
		 */
		public function ParticleEvent($type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false){
			super($type, $bubbles, $cancelable);
			this.data = $data;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():Event{
			return new ParticleEvent(this.type, this.data, this.bubbles, this.cancelable);
		}
		
	}

}
