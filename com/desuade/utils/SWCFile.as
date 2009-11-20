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
	
	import flash.utils.IDataInput;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.net.*;
	import flash.display.*;
	import flash.system.ApplicationDomain;
	import com.desuade.thirdparty.zip.*;
	
	/**
	 *  A class that makes loading and using resources from a SWC file easy
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
		 *	The actual MovieClip from the library.swf file
		 */
		public var libraryMC:MovieClip;
		
		/**
		 *	Raw data of the SWF
		 */
		public var libraryMCData:ByteArray;
	
		/**
		 *	@private
		 */
		private var _libLoader:Loader = new Loader();
		
		/**
		 *	@private
		 */
		private var _urlLoader:URLLoader = new URLLoader()
		
		/**
		 *	SWCFile is an object that represents information and data from a loaded SWC file. It provides a simple way to call resources from the SWC file.
		 */
		public function SWCFile() {
			super();
			//add listener for the loader
			_libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, libLoadComplete);
		}
		
		/**
		 *	This loads the specified SWC file.
		 *	@param	swc	 A string to the location of the SWC file
		 */
		public function load($swc:String):void {
			// load the swc
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, swcLoadComplete);
			var request:URLRequest= new URLRequest($swc);
			_urlLoader.load(request);
		}
		
		/**
		 *	This will load the SWC from an IDataInput
		 *	
		 *	@param	data	 The data to load the SWC from
		 */
		public function loadData($data:IDataInput):void {
			var zipFile:ZipFile = new ZipFile($data);
			for (var i:int = 0; i < zipFile.entries.length; i++) {
				var entry:ZipEntry = zipFile.entries[i];
				var data:ByteArray = zipFile.getInput(entry);
				if (entry.name == "catalog.xml") {
					catalog = XML(data.readUTFBytes(data.length));
				} else if (entry.name == "library.swf") {
					// load the library
					_libLoader.loadBytes(data);
					libraryMCData = data;
				}
			}
		}
		
		/**
		 *	This returns the direct class from the passed string
		 *	
		 *	@param	className	 The name of the class to get
		 *	@return		The Class, or null if it's not found
		 */
		public function getClass($className:String):Class {
			for (var e:String in sc) {
				if($className == e) return sc[e] as Class;
			}
			for (var r:String in classes) {
				if($className == r) return classes[r] as Class;
			}
			return null;
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
			//remove the livepreview classes
			if(classes['fl.livepreview::LivePreviewParent'] != undefined){
				delete classes['fl.livepreview::LivePreviewParent'];
				delete sc['LivePreviewParent'];
			}
		}
		
		/**
		 *	@private
		 */
		private function swcLoadComplete(event:Event):void {
			var loadedData:IDataInput = event.target.data as IDataInput;
			loadData(loadedData);
		}
		
		/**
		 *	@private
		 */
		private function libLoadComplete(event:Event):void {
			libraryMC = _libLoader.content as MovieClip;
			dom = _libLoader.contentLoaderInfo.applicationDomain;
			//let's go through the xml and gather resources
			readCatalog();
			onLoad(this);
		}
		
	}

}
