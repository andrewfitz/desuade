/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

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

package com.desuade.utils {
	
	/**
	 *  Creates a generic pool for any kind of object.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  04.06.2010
	 */
	public class BasicObjectPool {
		
		/**
		 *	The current size of the pool
		 */
		public var size:int = 0;
		
		/**
		 *	The starting size of the pool
		 */
		public var startSize:int = 1;
		
		/**
		 *	The current length of the pool
		 */
		public var length:int = 0;
		
		/**
		 *	The class of objects used in and created by the pool
		 */
		public var objectClass:Class;
		
		/**
		 *	The method used to clean objects on checkIn
		 */
		public var clean:Function;
		
		/**
		 *	@private
		 */
		protected var _list:Array = [];
		
		/**
		 *	This creates a new BasicObjectPool.
		 *	
		 *	@param	objectClass	 The class of objects used in and created by the pool
		 *	@param	clean	The method used to clean objects on checkIn
		 *	@param	startSize	 The starting size of the pool
		 */
		public function BasicObjectPool($objectClass:Class, $clean:Function = null, $startSize:int = 1) {
			objectClass = $objectClass;
			clean = $clean;
			startSize = $startSize;
			for(var i:int = 0; i < startSize; i++) make();
		}
		
		/**
		 *	Makes an object in the pool.
		 *	
		 *	@return		The object made
		 */
		public function make():* {
			size++;
			return _list[length++] = new objectClass();
		}
		
		/**
		 *	This checks an object out of the pool.
		 *	
		 *	@return		An instance of the objectClass
		 */
		public function checkOut():* {
			return (length == 0) ? make() : _list[--length];
		}
		
		/**
		 *	Checks the item back into the pool.
		 *	
		 *	@param	item	 The item to be checked back in
		 */
		public function checkIn($item:*):void {
			if(clean != null) {
				clean($item);
				if($item.isclean != undefined) $item.isclean = true;
			} else {
				if($item.isclean != undefined) $item.isclean = false;
			}
			_list[length++] = $item;
		}
		
		/**
		 *	Disposes of the pool and all it's objects
		 */
		public function dispose():void {
			objectClass = null;
			clean = null;
			_list = null;
		}
	}
}