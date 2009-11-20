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

package com.desuade.partigen.libraries {
	
	import com.desuade.utils.SWCFile;
	import com.desuade.partigen.Partigen;
	import com.desuade.thirdparty.zip.*;
	import flash.utils.IDataInput;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.net.*;
	import flash.display.*;
	import flash.system.ApplicationDomain;
	
	/**
	 *  This provides methods to work with Partigen Emitter Library 2 (pel) files
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.11.2009
	 */
	public class PELFile {
		
		/**
		 *	Version of the Partigen Emitter Library format this was made for
		 */
		public static const VERSION:Number = 2.0;
		
		/**
		 *	Method to be called after the SWC file is loaded
		 */
		public var onLoad:Function;
		
		/**
		 *	The version of the library
		 */
		public var version:Number;
		
		/**
		 *	The version of Partigen the library requires
		 */
		public var require:Number;
		
		/**
		 *	The name of the library
		 */
		public var name:String;
		
		/**
		 *	The author of the library
		 */
		public var author:String;
		
		/**
		 *	The original XML of the library
		 */
		public var xmlLibrary:XML;
		
		/**
		 *	An Object containing all the loaded SWC objects
		 */
		public var swcs:Object = {};
	
		/**
		 *	@private
		 */
		private var _urlLoader:URLLoader = new URLLoader()
		
		/**
		 *	@private
		 */
		private var _zipFile:ZipFile;
		
		/**
		 *	@private
		 */
		private var _swcTotal:int = 0;
		
		/**
		 *	@private
		 */
		private var _swcLoaded:int = 0;
		
		/**
		 *	This creates a PELFile that can be used to load preset emitter settings dynamicly at runtime.
		 */
		public function PELFile() {
			super();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, pelLoadComplete);
		}
		
		/**
		 *	This loads the specified PEL file.
		 *	
		 *	@param	pel	 A string to the location of the PEL file
		 */
		public function load($pel:String):void {
			var request:URLRequest= new URLRequest($pel);
			_urlLoader.load(request);
		}
		
		/**
		 *	This returns the direct class from the passed string
		 *	
		 *	@param	className	 The name of the class to get
		 */
		public function getClass($className:String):Class {
			for (var p:String in swcs) {
				return swcs[p].getClass($className);
			}
			return null;
		}
		
		/**
		 *	@private
		 */
		private function pelLoadComplete(event:Event) {
			var loadedData:IDataInput = event.target.data as IDataInput;
			_zipFile = new ZipFile(loadedData);
			for (var i:int = 0; i < _zipFile.entries.length; i++) {
				var entry:ZipEntry = _zipFile.entries[i];
				var data:ByteArray = _zipFile.getInput(entry);
				var ename:String = entry.name;
				var esplit:Array = ename.split('.');
				var format:String = String(esplit[1]).toLowerCase();
				var namey:String = String(esplit[0]);
				//ignore osx files and "." files
				if(ename.charAt(0) == '.' || ename.charAt(0) == "_"){
					//ignore these files
					//trace('ignored: ' + ename);
				} else if (ename == "library.xml") {
					var zl:XML = XML(data.readUTFBytes(data.length));
					var cc = zl.children();
					for (var r:int = 0; r < cc.length(); r++) {
						//check for the library
						var nn:String = cc[r].localName();
						if(nn == 'Library'){
							//do stuff when we find a library
							xmlLibrary = cc[r];
							version = Number(cc[r].@version);
							name = cc[r].@name;
							require = Number(cc[r].@require);
							author = cc[r].@author;
							
							//do stuff for making XML presets
							
						} else {
							//do stuff when it's other
						}
					}
				} else if (format == 'swc') {
					_swcTotal++;
					swcs[namey] = new SWCFile();
					swcs[namey].onLoad = function(t) {
						checkSWCLoaded();
					}
					swcs[namey].loadData(data);
				} else {
					//do when it's not a swc or xml
				}
			}
		}
		
		/**
		 *	@private
		 */
		private function checkSWCLoaded():void {
			if(++_swcLoaded == _swcTotal) onLoad();
		}
		
		/**
		 *	@private
		 */
		private function verify():void {
			//this will verify the PEL/ZIP has the proper contents and library.xml is formated right
			//in the future, also check against the pel2 namespace?
			//check for the main attributes
			//also check the particle classes in the library are found in the swcs
		}
	
	}

}
