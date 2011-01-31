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
	 *  Helps with XML parsing in the Motion and Partigen packages.
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
		
		/**
		 *	Returns a string for the class name. This is like getQualifiedClassName, except without the first half.
		 *	
		 *	@param	object	 The object to get the class name of
		 *	
		 *	@return		String of the object's class.
		 */
		public static function getSimpleClassName($object:Object):String {
			return getQualifiedClassName($object).split("::")[1];
		}
		
		/**
		 *	Converts any "flat" Object into XML.
		 *	
		 *	@param	object	 The Object to convert to XML.
		 *	
		 *	@return		XML object
		 */
		public static function objectToXML($object:Object):XML {
			var ata:Array = [];
			var dsx:XML = describeType($object);
			var cd:XMLList = dsx.children();
			for (var e:String in cd) if(cd[e].name() == "accessor") ata.push(cd[e].@name);
			var txml:XML = <ob />;
			txml.setLocalName(getSimpleClassName($object) || getQualifiedClassName($object));
			txml.@xmlctype = getQualifiedClassName($object);
			for (var p:String in $object) txml.@[p] = xmlize($object[p]);
			for (var i:int = 0; i < ata.length; i++) txml.@[ata[i]] = xmlize($object[ata[i]]);
			return txml;
		}
		
		/**
		 *	Converts XML into it's original Object.
		 *	
		 *	@param	xml	 The XML representation of the Object.
		 *	
		 *	@return		The new Object from the XML.
		 */
		public static function objectFromXML($xml:XML):* {
			var noc:Class = getDefinitionByName($xml.@xmlctype) as Class;
			var no:* = new noc();
			var ats:XMLList = $xml.attributes();
			for (var p:String in ats) {
				var an:String = ats[p].name();
				if(an != 'xmlctype') no[an] = dexmlize($xml.@[an]);
			}
			return no;
		}
	
	}

}
