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

package com.desuade.partigen.emitters {
	
	import flash.events.MouseEvent;
	
	/**
	 *  This is the class used for Partigen Emitter components for the Flash IDE.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.08.2009
	 */
	public dynamic class IDEEmitter extends Emitter {
		
		/**
		 *	@private
		 */
		protected var _autoStart:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _followMouse:Boolean = false;
		
		/**
		 *	Creates a new IDEEmitter (usually from a component)
		 */
		public function IDEEmitter() {
			super();
		}
		
		/**
		 *	Getter/setter that uses XML methods to return (as XML) or set the configuration of the emitter from String/XML.
		 */
		[Inspectable(name = "Config XML", defaultValue = "", variable = "config", type = "String")]
		public function get config():XML{
			return toXML();
		}
		
		/**
		 *	@private
		 */
		public function set config($value:*):void {
			if($value != "") fromXML((typeof $value == 'string') ? new XML($value) : $value);
		}
		
		/**
		 *	Start the emitter automatically.
		 */
		[Inspectable(name = "Will Auto Start", defaultValue = false, variable = "autoStart", type = "Boolean")]
		public function get autoStart():Boolean{
			return _autoStart;
		}
		
		/**
		 *	@private
		 */
		public function set autoStart($value:Boolean):void {
			_autoStart = $value;
			if($value) start();
		}
		
		/**
		 *	If the emitter follows the mouse.
		 */
		[Inspectable(name = "Follow Mouse", defaultValue = false, variable = "followMouse", type = "Boolean")]
		public function get followMouse():Boolean{
			return _followMouse;
		}
		
		/**
		 *	@private
		 */
		public function set followMouse($value:Boolean):void {
			_followMouse = $value;
			if(_followMouse){
				stage.addEventListener(MouseEvent.MOUSE_MOVE, fmouse);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, fmouse);
			}
		}
		
		/**
		 *	@private
		 */
		protected function fmouse($o:Object):void {
			x = root.stage.mouseX;
			y = root.stage.mouseY;
		}
	
	}

}
