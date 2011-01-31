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

package com.desuade.motion.bases {

	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import com.desuade.utils.XMLHelper;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.*;
	import com.desuade.motion.eases.*;
	import com.desuade.motion.bases.*;
	
	/**
	 *  The base class for Basic objects.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BaseBasic extends EventDispatcher {
		
		/**
		 *	@private
		 */
		protected var _config:Object;
		
		/**
		 *	@private
		 */
		protected var _primitiveID:int = 0;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	The target object
		 */
		public var target:Object;
		
		/**
		 *	@private
		 */
		protected var _eventClass:Class = MotionEvent;
		
		/**
		 *	<p>This creates a new BaseBasic instance.</p>
		 *	<p>The constructor accepts an object that has all the paramaters for the config.</p>
		 *	
		 *	@param	target	 The target object
		 *	@param	configObject	 The config object that has all the values for the config
		 *	
		 */
		public function BaseBasic($target:Object, $configObject:Object = null) {
			super();
			BaseTicker.start();
			target = $target;
			_config = $configObject || {};
		}
		
		//args need to be in here for overriding - delay and position
		
		/**
		 *	This starts and creates the primitive.
		 *	
		 *	@return		The object (for chaining)
		 */
		public function start($delay:Number = -1, $position:Number = -1):* {
			if(!_active){
				_active = true;
				dispatchEvent(new _eventClass(_eventClass.STARTED, {basic:this}));
				_primitiveID = createPrimitive(_config);
			}
			return this;
		}
		
		/**
		 *	This stops and removes the primitive.
		 *	
		 *	@return		True if the primitive could be stopped.
		 */
		public function stop():Boolean {
			if(_primitiveID != 0) {
				BaseTicker.getItem(_primitiveID).end();
				return true;
			} else return false;
		}
		
		/**
		 *	If the primitive is currently active and running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Gets the config object that was passed in the constructor. The properties in this object can be modified.
		 */
		public function get config():Object{
			return _config;
		}
		
		/**
		 *	The primitive's id
		 */
		public function get pid():int{
			return _primitiveID;
		}
		
		/**
		 *	This creates an XML object that represents the object, based on it's config object.
		 *	
		 *	@return		An XML object of the config
		 */
		public function toXML():XML {
			var txml:XML = <basic />;
			txml.setLocalName(XMLHelper.getSimpleClassName(this));
			for (var p:String in _config) {
				if(_config[p] != undefined) txml.@[p] = XMLHelper.xmlize(_config[p]);
			}
			//if(_config.ease != undefined && typeof _config.ease != 'string') Debug.output('motion', 10008);
			return txml;
		}
		
		/**
		 *	<p>Configures the object based on the values provided by the XML.</p>
		 *	<p>Most properties can assigned in the attributes using the same names.</p>
		 *	<p>The values of the attributes will be converted to Numbers if they're not NaN. For values that should be Strings (for relative), use a '&#42;' – ie: value='&#42;50'</p>
		 *	
		 *	@param	xml	The XML to use for configuration
		 *	@return		The object that called the method (for chaining)
		 */
		public function fromXML($xml:XML):* {
			var ats:XMLList = $xml.attributes();
			for (var p:String in ats) {
				var an:String = ats[p].name();
				_config[an] = XMLHelper.dexmlize($xml.@[an]);
			}
			return this;
		}
		
		/**
		 *	@private
		 */
		protected function createPrimitive($to:Object):int {
			return 0;
		}
		
		/**
		 *	@private
		 */
		protected function endFunc($o:Object):void {
			dispatchEvent(new _eventClass(_eventClass.ENDED, {basic:this, primitive:BaseTicker.getItem(_primitiveID)}));
			_active = false;
			BaseTicker.removeItem(_primitiveID);
			_primitiveID = 0;
		}
		
		/**
		 *	@private
		 */
		protected function updateListener($i:Object):void {
			if(_config.update) dispatchEvent(new _eventClass(_eventClass.UPDATED, {basic:this, primitive:BaseTicker.getItem(_primitiveID)}));
		}

	}

}
