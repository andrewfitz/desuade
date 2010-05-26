/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

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
	import flash.display.MovieClip;
	import com.desuade.partigen.renderers.*;
	import com.desuade.motion.events.*;
	import com.desuade.utils.Drawing;
	import flash.events.Event;
	import flash.utils.*;
	
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
		protected var _autoStart:Boolean = true;
		
		/**
		 *	@private
		 */
		protected var _followMouse:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _oldang:Array = ['n', 'n'];
		
		/**
		 *	@private
		 */
		public var indicator:MovieClip;
		
		/**
		 *	This is the prefetch time used when automatically starting the emitter.
		 */
		[Inspectable(name = "Prefetch Time", defaultValue = 0, variable = "prefetchTime", type = "Number")]
		public var prefetchTime:Number = 0;
		
		/**
		 *	@private
		 */
		protected var _isLivePreview:Boolean;
		
		/**
		 *	Creates a new IDEEmitter (usually from a component)
		 */
		public function IDEEmitter() {
			super();
			_isLivePreview = (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
			addEventListener(Event.ENTER_FRAME, updateAngleSlice, false, 0, false);
			if(stage != undefined) BaseTicker.physicsRate = stage.frameRate;
		}
		
		/**
		 *	Getter/setter that uses XML methods to return (as String) or set the configuration of the emitter from String/XML.
		 */
		[Inspectable(name = "Config XML", defaultValue = "", variable = "config", type = "String")]
		public function set config($value:String):void {
			if($value != "") fromXML(new XML($value), true, true);
		}
		
		/**
		 *	@private
		 */
		public function get config():String{
			return toXML().toXMLString();
		}
		
		/**
		 *	Start the emitter automatically.
		 */
		[Inspectable(name = "Start Automatically", defaultValue = true, variable = "autoStart", type = "Boolean")]
		public function set autoStart($value:Boolean):void {
			_autoStart = $value;
			if($value && !_isLivePreview) start(prefetchTime);
		}
		
		/**
		 *	@private
		 */
		public function get autoStart():Boolean{
			return _autoStart;
		}
		
		/**
		 *	If the emitter indicator should be shown, marking it's position on the stage.
		 */
		[Inspectable(name = "Show Indicator", defaultValue = true, variable = "showIndicator", type = "Boolean")]
		public function set showIndicator($value:Boolean):void {
			if(!_isLivePreview) indicator.visible = $value;
		}
		
		/**
		 *	@private
		 */
		public function get showIndicator():Boolean{
			return indicator.visible;
		}
		
		/**
		 *	If the emitter follows the mouse.
		 */
		[Inspectable(name = "Follow Mouse", defaultValue = false, variable = "followMouse", type = "Boolean")]
		public function set followMouse($value:Boolean):void {
			if(_followMouse != $value){
				_followMouse = $value;
				if(_followMouse){
					stage.addEventListener(MouseEvent.MOUSE_MOVE, fmouse);
				} else {
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, fmouse);
				}
			}
		}
		
		/**
		 *	@private
		 */
		public function get followMouse():Boolean{
			return _followMouse;
		}
		
		/**
		 *	@private
		 */
		protected function fmouse($o:Object):void {
			x = root.stage.mouseX;
			y = root.stage.mouseY;
		}
		
		/**
		 *	@private
		 */
		public function updateAngleSlice($e:Object):void {
			if(indicator.visible){
				if(_oldang[0] != angle || _oldang[1] != angleSpread){
					_oldang[0] = angle;
					_oldang[1] = angleSpread;
					indicator.graphics.clear();
					var ags:Number = (typeof angleSpread == 'string') ? angle + Number(angleSpread) : angleSpread;
					Drawing.drawSlice(indicator, angle, ((angle-ags) < 10 && (angle-ags) > -10) ? angle+10 : ags, 9, '#cccccc', 0, 0, 2);
				}
			}
		}
	
	}

}
