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
	
	import flash.utils.*;
	
	/**
	 *  This stores pools and manages objects based on multiple classes.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  09.06.2010
	 */
	public class MultiPool {
		
		/**
		 *	The starting size and rate of expansion of the object pool
		 */
		public var expandSize:int;
		
		/**
		 *	@private
		 */
		protected var _classPools:Dictionary = new Dictionary(true);
		
		/**
		 *	@private
		 */
		protected var _clean:Function;
		
		/**
		 *	This creates a new MultiPool.
		 *	
		 *	@param	clean	 This is the function to clean all the objects with.
		 *	@param	expandSize	 The size of each expansion for the object pool
		 */
		public function MultiPool($clean:Function, $expandSize:int = 50) {
			super();
			_clean = $clean;
			expandSize = $expandSize;
		}
		
		/**
		 *	This checks out the object to the specified class pool.
		 *	
		 *	@param	class	 The class of objects to create.
		 *	
		 *	@return		The new object.
		 */
		public function checkOutClass($class:Class):* {
			if(_classPools[$class] == undefined) _classPools[$class] = new BasicObjectPool($class, _clean, expandSize);
			return _classPools[$class].checkOut();
		}
		
		/**
		 *	This checks in the object to the specified class pool.
		 *	
		 *	@param	class	 The class of object.
		 *	@param	item	 The object to check in.
		 */
		public function checkInClass($class:Class, $item:*):void {
			if(_classPools[$class] != undefined) _classPools[$class].checkIn($item);
			else $item = null;
		}
		
		/**
		 *	This removes all the object pools for classes to free up memory. Only call this after all objects are done and/or purged. Use with caution.
		 */
		public function purgeAllClasses():void {
			for each (var item:BasicObjectPool in _classPools) {
				item.dispose();
			}
			_classPools = null;
			_classPools = new Dictionary(true);
		}
		
	}

}
