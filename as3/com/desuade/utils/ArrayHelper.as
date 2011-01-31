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
		
		/**
		 *	This returns an Array that's cleaned of duplicates from the given Array. This does not modify the original Array.
		 *	
		 *	@param	array	 The Array to use
		 *	@param	duplicates	 To return the duplicates instead
		 *	@return		A new Array with no duplicates from the original
		 */
		public static function removeDuplicates($array:Array, $duplicates:Boolean = false):Array {
			var so:Array = [];
			var iu:Function = function (item:*, index:int, array:Array):Boolean {
				if(array.indexOf(item, index + 1) == -1){
					return true;
				} else {
					so.push(array[index]);
					return false;
				}
			};
			var na:Array = $array.filter(iu);
			return ($duplicates) ? so : na;
		}
		
		/**
		 *	Finds what values in array a are not in array b.
		 *	
		 *	@param	a	 The first array
		 *	@param	b	 The second array
		 *	@return		An array of values that a has, which are not found in b
		 */
		public static function aNotInB(a:Array, b:Array):Array {
			var na:Array = [];
			for each( var oa:Object in a) {
				if(b.indexOf(oa) == -1) na.push(oa);
			}
			return na;
		}
		
		/**
		 *	Finds what values in array a that are in array b.
		 *	
		 *	@param	a	 The first array
		 *	@param	b	 The second array
		 *	@return		An array of values that a has, which is also found somewhere in b
		 */
		public static function aInB(a:Array, b:Array):Array {
			var na:Array = [];
			for each( var oa:Object in a) {
				if(b.indexOf(oa) != -1) na.push(oa);
			}
			return na;
		}
	
	}

}

