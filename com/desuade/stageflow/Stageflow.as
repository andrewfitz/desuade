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
	
	public class Stageflow extends Object {
		
		public var padding_top:Number = 0;
		
		public var padding_right:Number = 0;
		
		public var padding_bottom:Number = 0;
		
		public var padding_left:Number = 0;
		
		/**
		 *	@private
		 */
		protected var _target:Object;
		
		/**
		 *	@private
		 */
		protected var _managed:Dictionary = new Dictionary();
		
		public function Stageflow($target:Object) {
			super();
			_target = $target;
			init();
			_target.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		public function init():void {
			_target.align = StageAlign.TOP_LEFT;
			_target.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		public function get target():Object{
			return _target;
		}
		
		public function add($target:Object, $location:String, $alignment:String):void {
			_managed[$target] = {location:$location, alignment:$alignment};
		}
		
		public function remove($target:Object):void {
			delete _managed[$target];
		}
		
		public function setPadding($t:Number, $r:Number, $b:Number, $l:Number):void {
			padding_top = $t, padding_right = $r, padding_bottom = $b, padding_left = $l;
		}
		
		protected function resizeHandler($o:Object):void {
			for (var f:Object in _managed) {
				var p1:Point = Align.getLocation(f, _managed[f].location);
				var p2:Point = getStageLocation(_managed[f].alignment);
				f.x = (f.x - p1.x) + p2.x;
				f.y = (f.y - p1.y) + p2.y;
			}
		}
		
		public function getStageLocation($location:String):Point {
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

