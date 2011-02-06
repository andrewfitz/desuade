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
		 *	The size of each expansion for the object pool
		 */
		public var expandSize:int;
		
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
		 *	The method called when the last object is checkedIn 
		 */
		public var onLastCheckIn:Function;
		
		/**
		 *	@private
		 */
		protected var _list:Array = [];
		
		/**
		 *	This is an array of all the actual objects currently available in the pool. Use with caution.
		 */
		public function get list():Array{
			return _list;
		}
		
		/**
		 *	This creates a new BasicObjectPool.
		 *	
		 *	@param	objectClass	 The class of objects used in and created by the pool
		 *	@param	clean	The method used to clean objects on checkIn
		 *	@param	expandSize	 The size of each expansion for the object pool
		 *	@param	startSize	 The starting size of the pool
		 */
		public function BasicObjectPool($objectClass:Class, $clean:Function = null, $expandSize:int = 50, $startSize:int = 0) {
			objectClass = $objectClass;
			clean = $clean;
			expandSize = $expandSize;
			make($startSize);
		}
		
		/**
		 *	Makes an object in the pool.
		 *	
		 *	@param	amount	 The amount of new objects to create
		 */
		public function make($amount:int = 1):void {
			for(var i:int = 0; i < $amount; i++) {
				size++;
				_list[length++] = new objectClass();
			}
		}
		
		/**
		 *	Removes an object in the pool.
		 *	
		 *	@param	amount	 The amount of old objects to remove
		 */
		public function remove($amount:int = 1):void {
			for(var i:int = 0; i < $amount; i++) {
				size--;
				length--;
				_list[0] = null;
				_list.shift();
			}
		}
		
		/**
		 *	This checks an object out of the pool. If there are no more available objects, the pool increases the amount by the expand size.
		 *	
		 *	@return		An instance of the objectClass
		 */
		public function checkOut():* {
			if(length == 0) make(expandSize);
			return _list[--length];
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
			if((length/expandSize) >= 1.9) remove(expandSize);
			if(size == length && onLastCheckIn != null) onLastCheckIn(this);
		}
		
		/**
		 *	Disposes of the pool and all it's objects
		 */
		public function dispose():void {
			objectClass = null;
			clean = null;
			for (var i:int = 0; i < _list.length; i++) {
				_list[i] = null;
				delete _list[i];
			}
			_list = null;
		}
	}
}