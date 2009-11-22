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

package com.desuade.utils {
	
	/**
	 *  Helper methods for Arrays
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  22.11.2009
	 */
	public class ArrayHelper {
		
		/**
		 *	This adds an item to the end of the specified Array and removes the first item only if it's full.
		 *	
		 *	@param	array	 The Array to modify
		 *	@param	item	 The item to add
		 *	@param	length	 The max length the Array can be. Defaults to no max length, and will not squeeze.
		 */
		public static function squeeze($array:Array, $item:Object, $length:int = 0):void {
			$array.push($item);
			$length = ($length == 0) ? $array.length : $length;
			if($array.length > $length) $array.shift();
		}
		
		/**
		 *	This adds an item to the beginning of the specified Array and removes the last item only if it's full.
		 *	
		 *	@param	array	 The Array to modify
		 *	@param	item	 The item to add
		 *	@param	length	 The max length the Array can be. Defaults to no max length, and will not squeeze.
		 */
		public static function unsqueeze($array:Array, $item:Object, $length:int = 0):void {
			$array.unshift($item);
			$length = ($length == 0) ? $array.length : $length;
			if($array.length > $length) $array.pop();
		}
	
	}

}

