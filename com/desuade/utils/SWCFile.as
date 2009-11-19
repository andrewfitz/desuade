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

//IMPORTANT: This requires the nochump zip library: http://nochump.com/blog/?p=15

package com.desuade.utils {
	
	import flash.utils.IDataInput;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.net.*;
	import flash.display.*;
	import flash.system.ApplicationDomain;
	import nochump.util.zip.*;
	
	/**
	 *  A class that makes loading resources from a SWC file easy
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  19.11.2009
	 */
	public class SWCFile {
		
		/**
		 *	This is the XML of the catalog.xml file in the SWC
		 */
		public var catalog:XML;
		
		/**
		 *	This is the ApplicationDomain info from the library.swf
		 */
		public var dom:ApplicationDomain;
		
		/**
		 *	Method to be called after the SWC file is loaded
		 */
		public var onLoad:Function;
		
		/**
		 *	This is an object containing all the classes found in the SWC
		 */
		public var classes:Object = {};
		
		/**
		 *	This is an object containing the classes, but by the shorthand name. If there are conflicts with multiple classes using the same name, they will be overritten.
		 */
		public var sc:Object = {};
	
		/**
		 *	@private
		 */
		private var _libLoader:Loader = new Loader();
		
		/**
		 *	@private
		 */
		private var _urlLoader:URLLoader = new URLLoader()
		
		/**
		 *	SWC is an object that represents information and data from a loaded SWC file. It provides a simple way to call resources from the SWC file.
		 */
		public function SWC() {
			super();
			//add listener for the loader
			_libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, libLoadComplete);
			// load the swc
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, swcLoadComplete);
		}
		
		/**
		 *	This loads the specified swc file.
		 *	@param	swc	 A string to the location of the SWC file
		 */
		public function load($swc:String):void {
			var request:URLRequest= new URLRequest($swc);
			_urlLoader.load(request);
		}
		
		/**
		 *	@private
		 */
		private function readCatalog():void {
			var cc = catalog.children();
			for (var r:int = 0; r < cc.length(); r++) {
				//check for the library
				var nn:String = cc[r].localName();
				if(nn == 'libraries'){
					var libc = cc[r].children();
					for (var i:int = 0; i < libc.length(); i++) {
						var ll = libc[i].children();
						for (var t:int = 0; t < ll.length(); t++) {
							var cst:String = ll[t].children()[0].@id;
							var classname:String = cst.split(':').join('::');
							classes[classname] = dom.getDefinition(classname) as Class;
							sc[cst.split(':')[1]] = dom.getDefinition(classname) as Class;
						}
					}
				} else if(nn == 'components'){
					//trace('components are here');
					//libraries not found
				} else if(nn == 'files'){
					//trace('files are here');
				}
			}
		}
		
		/**
		 *	@private
		 */
		private function swcLoadComplete(event:Event) {
			var loadedData:IDataInput = event.target.data as IDataInput;
			var zipFile:ZipFile = new ZipFile(loadedData);
			for (var i:int = 0; i < zipFile.entries.length; i++) {
				var entry:ZipEntry = zipFile.entries[i];
				var data:ByteArray = zipFile.getInput(entry);
				if (entry.name == "catalog.xml") {
					catalog = XML(data.readUTFBytes(data.length));
				}
				if (entry.name == "library.swf") {
					// load the library
					_libLoader.loadBytes(data);
				}
			}
		}
		
		/**
		 *	@private
		 */
		private function libLoadComplete(event:Event):void {
			dom = _libLoader.contentLoaderInfo.applicationDomain;
			//let's go through the xml and gather resources
			readCatalog();
			onLoad();
		}
	
	}

}
