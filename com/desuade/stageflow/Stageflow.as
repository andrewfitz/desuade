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

package com.desuade.stageflow {

	import flash.events.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 *  Stageflow provides managment for display objects to keep alignment when a stage is resized.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  27.08.2009
	 */
	public class Stageflow extends Object {
		
		/**
		 *	The padding on the top of the stage
		 */
		public var padding_top:Number = 0;
		
		/**
		 *	The padding on the right of the stage
		 */
		public var padding_right:Number = 0;
		
		/**
		 *	The padding on the bottom of the stage
		 */
		public var padding_bottom:Number = 0;
		
		/**
		 *	The padding on the left of the stage
		 */
		public var padding_left:Number = 0;
		
		/**
		 *	@private
		 */
		protected var _target:Object;
		
		/**
		 *	@private
		 */
		protected var _managed:Dictionary = new Dictionary();
		
		/**
		 *	Creates a new Stageflow instance.
		 *	
		 *	@param	target	 The stage object to use. This is usually root.stage.
		 */
		public function Stageflow($target:Object) {
			super();
			_target = $target;
			init();
			_target.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**
		 *	Sets up the stage to be properly used by Stageflow
		 */
		public function init():void {
			_target.align = StageAlign.TOP_LEFT;
			_target.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 *	The target stage object used by the Stageflow instance
		 */
		public function get target():Object{
			return _target;
		}
		
		/**
		 *	Adds an object to the list of managed objects to realign on a stage resize.
		 *	
		 *	@param	target	 The target object to be realigned on resize
		 *	@param	location	 The location on the target object to align
		 *	@param	alignment	 The location of the stage to align to
		 */
		public function add($target:Object, $location:String, $alignment:String):void {
			_managed[$target] = {location:$location, alignment:$alignment};
		}
		
		/**
		 *	This removes the given object from the managed objects.
		 *	
		 *	@param	target	 The object to remove
		 */
		public function remove($target:Object):void {
			delete _managed[$target];
		}
		
		public function setPadding($t:Number, $r:Number, $b:Number, $l:Number):void {
			padding_top = $t, padding_right = $r, padding_bottom = $b, padding_left = $l;
		}
		
		/**
		 *	This realigns all the managed objects according to their requested locations.
		 */
		public function realign():void {
			for (var f:Object in _managed) {
				var p1:Point = Align.getLocation(f, _managed[f].location);
				var p2:Point = getStageLocation(_managed[f].alignment);
				f.x = (f.x - p1.x) + p2.x;
				f.y = (f.y - p1.y) + p2.y;
			}
		}
		
		/**
		 *	@private
		 */
		protected function resizeHandler($o:Object):void {
			realign();
		}
		
		/**
		 *	@private
		 */
		protected function getStageLocation($location:String):Point {
			var tp:Point = new Point(0,0);
			switch ($location) {
				case 'top_left':
					tp.y = _target.y + padding_top;
					tp.x = _target.x + padding_left;
					break;
				case 'top_center':
					tp.y = _target.y + padding_top;
					tp.x = _target.x + (_target.stageWidth/2);
					break;
				case 'top_right':
					tp.y = _target.y + padding_top;
					tp.x = _target.x + _target.stageWidth - padding_right;
					break;
				case 'bottom_left':
					tp.y = _target.y + _target.stageHeight - padding_bottom;
					tp.x = _target.x + padding_left;
					break;
				case 'bottom_center':
					tp.y = _target.y + _target.stageHeight - padding_bottom;
					tp.x = _target.x + (_target.stageWidth/2);
					break;
				case 'bottom_right':
					tp.y = _target.y + _target.stageHeight - padding_bottom;
					tp.x = _target.x + _target.stageWidth - padding_right;
					break;
				case 'left_center':
					tp.y = _target.y + (_target.stageHeight/2);
					tp.x = _target.x + padding_left;
					break;
				case 'right_center':
					tp.y = _target.y + (_target.stageHeight/2);
					tp.x = _target.x + _target.stageWidth - padding_right;
					break;
				case 'center':
					tp.y = _target.y + (_target.stageHeight/2);
					tp.x = _target.x + (_target.stageWidth/2);
					break;
			}
			return tp;
		}
	
	}

}
