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

package com.desuade.motion.bases {

	import flash.utils.getTimer;
	
	import com.desuade.motion.bases.*;
	import com.desuade.debugging.*
	
	/**
	 *  This is the base class to Primitive objects.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.07.2009
	 */
	public class BasePrimitive {
		
		/**
		 *	This is the unique internal id of the item.
		 */
		public var id:int;
		
		/**
		 *	The target object.
		 */
		public var target:Object;
		
		/**
		 *	The property on the target.
		 */
		public var property:String;
		
		/**
		 *	Has the Primitive ended or not.
		 */
		public var ended:Boolean = false;
		
		/**
		 *	The function to run on update.
		 */
		public var updateFunc:Function = uf;
		
		/**
		 *	The function to run on end.
		 */
		public var endFunc:Function = ef;
		
		/**
		 *	@private
		 */
		public var starttime:int;
		
		/**
		 *	This is used by the pool to determine if/how the Primitive has been used before in memory.
		 */
		public var isclean:Boolean = true;
		
		/**
		 *	Creates a new BasePrimitive. This is a base class and should be extended, not used directly.
		 *	
		 */
		public function BasePrimitive() {
			super();
			id = BaseTicker.aquireID();
			Debug.output('motion', 50001, [id]);
		}
		
		/**
		 *	Inits a new BasePrimitive.
		 *	
		 *	@param	target	 The target object
		 *	@param	property	 The property to use
		 */
		public function init(... args):void {
			target = args[0], property = args[1], starttime = getTimer(), ended = false;
		}
		
		/**
		 *	This renders the primitive. This is the function that does all the "magic".
		 *	
		 *	@param	time	 The current getTimer() time.
		 */
		public function render($time:int):void {
			//
		}
		
		/**
		 *	This ends the Primitive immediately.
		 *	
		 *	@param	broadcast	 If false, this will not fire the endFunc method.
		 */
		public function end($broadcast:Boolean = true):void {
			ended = true;
			if($broadcast) endFunc(this);
			Debug.output('motion', 50002, [id]);
		}
		
		///////////////
		
		/**
		 *	@private
		 */
		protected function uf($i:BasePrimitive):void{}
		
		/**
		 *	@private
		 */
		protected function ef($i:BasePrimitive):void{}
	
	}

}
