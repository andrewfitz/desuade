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
	
	import com.desuade.utils.*;
	import com.desuade.partigen.Partigen;
	import com.desuade.thirdparty.zip.*;
	import com.desuade.debugging.*;
	import flash.utils.IDataInput;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.net.*;
	import flash.display.*;
	import flash.system.ApplicationDomain;
	import adobe.utils.*;
	
	/**
	 *  Loads and provides methods for PEL (Partigen Emitter Library) files.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.11.2009
	 */
	public class PELFile {
		
		/**
		 *	<p>Version of the Partigen Emitter Library (PEL) spec this class was designed for.</p>
		 *	<p>If the a pel file is loaded with a future spec, the details will be traced through the debug class, but will still load. If the new spec is too different, there can be issues.</p>
		 */
		public static const VERSION:Number = 2.0;
		
		/**
		 *	This error is sent to the onError method when there's an error loading the actual pel file
		 */
		public static const ERROR_LOAD_FILELOAD:String = "Error loading PEL file";
		
		/**
		 *	This error is sent to the onError method when there's no library.xml file found
		 */
		public static const ERROR_LOAD_MISSINGXML:String = "No library XML definition found";
		
		/**
		 *	This error is sent to the onError method when the current version of Partigen does not meet the libraries required version
		 */
		public static const ERROR_LOAD_REQUIRED:String = "Version does not meet requirments";
		
		/**
		 *	<p>Method to be called after the PEL file is loaded</p>
		 *	<p>1 arg is passed: PELFile</p>
		 */
		public var onLoad:Function;
		
		/**
		 *	<p>Method to be called if there's an error loading the PEL</p>
		 *	<p>2 args are passed: PELFile, error</p>
		 */
		public var onError:Function = null;
		
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
		 *	This is the library object that contains all the groups of presets
		 */
		public var library:Object = {};
		
		/**
		 *	An Object containing all the loaded SWC objects
		 */
		public var swcs:Object = {};
		
		/**
		 *	The original path of the .pel file
		 */
		public var path:String;
		
		/**
		 *	If the loaded SWC files should share their Classes or keep them in their own ApplicationDomain
		 */
		public var shared:Boolean = true;
	
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
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorFunc);
		}
		
		/**
		 *	This loads the specified PEL file.
		 *	
		 *	@param	file	 A string to the location of the PEL file
		 */
		public function load($file:String, $shared:Boolean = true):void {
			path = $file;
			shared = $shared;
			var request:URLRequest= new URLRequest($file);
			_urlLoader.load(request);
		}
		
		/**
		 *	This returns the direct Class from the passed string
		 *	
		 *	@param	className	 The name of the class to get
		 *	@return		The Class, or null if it's not found
		 */
		public function getClass($className:String):Class {
			for (var p:String in swcs) {
				var c:Class = swcs[p].getClass($className);
				if(c != null) return c;
			}
			return null;
		}
		
		/**
		 *	This returns an Array of Strings listing all available loaded classes
		 *	
		 *	@param	fullname	 To return the full qualified class name if true, false returns the short class name.
		 *	@param	duplicates	 Include duplicates in the result. Defaults to false.
		 *	@return		Array of class names
		 */
		public function getAllClasses($fullname:Boolean = true, $duplicates:Boolean = false):Array {
			var ca:Array = [];
			for (var p:String in swcs) {
				for (var t:String in (($fullname) ? swcs[p].classes : swcs[p].sc)) {
					ca.push(t);
				}
			}
			return ($duplicates) ? ca : ArrayHelper.removeDuplicates(ca);
		}
		
		/**
		 *	@private
		 */
		private function pelLoadComplete(event:Event):void {
			var loadedData:IDataInput = event.target.data as IDataInput;
			_zipFile = new ZipFile(loadedData);
			//check for the library.xml file because it's needed
			var libentry:ZipEntry = _zipFile.getEntry("library.xml");
			if(libentry == null){
				//report error here and exit and return
				if(onError != null) onError(this, ERROR_LOAD_MISSINGXML);
				return;
			} else {
				//load lib file
				var libdata:ByteArray = _zipFile.getInput(libentry);
				var zl:XML = XML(libdata.readUTFBytes(libdata.length));
				if(VERSION < zl.@version){
					//this means the current PELFile may not be able to parse the newer version
					Debug.output('partigen', 10002, [VERSION, zl.@version, zl.@version]);
				}
				var cc:XML = zl.children();
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
						//find all presets
						var lc:XML = cc[r].children();
						for (var a:int = 0; a < lc.length(); a++) {
							var lcn:String = lc[a].localName();
							if(lcn == 'Group'){
								var gname:String = lc[a].@name;
								library[gname] = {};
								var gp:XML = lc[a].children();
								for (var e:int = 0; e < gp.length(); e++) {
									library[gname][gp[e].@name] = gp[e];
									delete library[gname][gp[e].@name].@name;
								}
							} else {
								//do something if it's not a group
							}
						}
					} else {
						//do stuff when it's other
					}
				}
				//do checks and things if the required is off or whatever
				if(Partigen.VERSION < require){
					//it doesn't meet partigen requirements, so don't load it
					if(onError != null) onError(this, ERROR_LOAD_REQUIRED);
					return;
				}
			}
			//continue on if everything is good and load the resources
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
				} else if (ename == "library.xml") {
					//ignore it we already loaded it
				} else if (format == 'swc') {
					_swcTotal++;
					swcs[namey] = new SWCFile();
					swcs[namey].onLoad = function(t:SWCFile):void {
						checkSWCLoaded();
					}
					swcs[namey].loadData(data, shared);
				} else {
					//do when it's not a swc or xml
				}
			}
		}
		
		/**
		 *	@private
		 */
		private function checkSWCLoaded():void {
			if(++_swcLoaded == _swcTotal) {
				if(onLoad != null) onLoad(this);
				_swcLoaded = 0;
			}
		}
		
		/**
		 *	@private
		 */
		private function loadErrorFunc(e:Event = null):void {
			if(onError != null) onError(this, ERROR_LOAD_FILELOAD);
		}
		
	}

}
