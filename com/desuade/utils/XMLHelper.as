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
	
	import com.desuade.debugging.*
	import com.desuade.motion.eases.Easing;
	
	/**
	 *  Helps with XML parsing.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  27.07.2009
	 */
	public class XMLHelper {
		
		/**
		 *	Cleans a string from an XML object for use in the package.
		 *	
		 *	@param	xval	 The string from an XML object attribute or child
		 *	@return		The value as a String, Boolean, or Number
		 */
		public static function dexmlize($xval:*):* {
			if(String($xval) === "false"){
				return false;
			} else if(String($xval) === "true"){
				return true;
			} else if($xval.indexOf(",") != -1){
				var ba:Array = $xval.split(",");
				var na:Array = [];
				for (var i:int = 0; i < ba.length; i++) {
					na.push(dexmlize(ba[i]));
				}
				return na;
			} else {
				if(!isNaN($xval)){
					return Number($xval);
				} else {
					return ($xval.charCodeAt(0) == 42) ? String($xval).slice(1) : String($xval);
				}
			}
		}
		
		/**
		 *	Makes a value ready for XML as a String.
		 *	
		 *	@param	xval	 The value to prepare for XML
		 *	@return		An XML-ready String
		 */
		public static function xmlize($xval:*):String {
			if(typeof $xval == 'string'){
				return (!isNaN($xval)) ? "*" + $xval : $xval;
			} else if($xval is Array){
				var ns:String = "";
				for (var i:int = 0; i < $xval.length; i++) {
					if(i != 0) ns += ",";
					ns += xmlize($xval[i]);
				}
				return ns;
			} else {
				return $xval.toString();
			}
		}
	
	}

}