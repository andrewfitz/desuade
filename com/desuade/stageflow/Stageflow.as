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
		 *	The minimum width objects should align to. No X position less than this.
		 */
		public var min_width:Number = 0;
		
		/**
		 *	The minimum height objects should align to. No Y position less than this.
		 */
		public var min_height:Number = 0;
		
		/**
		 *	The maximum width objects should align to. No X position greater than this.
		 */
		public var max_width:Number = 0;
		
		/**
		 *	The maximum height objects should align to. No Y position greater than this.
		 */
		public var max_height:Number = 0;
		
		/**
		 *	@private
		 */
		protected var _target:Object;
		
		/**
		 *	@private
		 */
		protected var _managedPosition:Dictionary = new Dictionary();
		
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
		 *	@param	offsetX	 Any offset for the X value
		 *	@param	offsetY	 Any offset for the Y value
		 *	@param	lockX	 This prevents any changes the X value
		 *	@param	lockY	 This prevents any changes the Y value
		 */
		public function positionAlign($target:Object, $location:String, $alignment:String, $offsetX:Number = 0, $offsetY:Number = 0, $lockX:Boolean = false, $lockY:Boolean = false):void {
			_managedPosition[$target] = {location:$location, alignment:$alignment, offsetX:$offsetX, offsetY:$offsetY, lockX:$lockX, lockY:$lockY};
		}
		
		/**
		 *	This adds the target object to the Stageflow, moving the object relative the the new stage height and width.
		 *	
		 *	@param	target	 The target object to be realigned on resize
		 *	@param	lockX	 This prevents any changes the X value
		 *	@param	lockY	 This prevents any changes the Y value
		 */
		public function positionRelative($target:Object, $lockX:Boolean = false, $lockY:Boolean = false):void {
			_managedPosition[$target] = {ox:$target.x, oy:$target.y, osw:_target.stageWidth, osh:_target.stageHeight, lockX:$lockX, lockY:$lockY};
		}
		
		/**
		 *	This removes the given object from all the managed objects.
		 *	
		 *	@param	target	 The object to remove
		 */
		public function remove($target:Object):void {
			if(_managedPosition[$target] != undefined) delete _managedPosition[$target];
		}
		
		/**
		 *	Sets all the padding at once.
		 *	
		 *	@param	t	 The padding_top value
		 *	@param	r	 The padding_right value
		 *	@param	b	 The padding_bottom value
		 *	@param	l	 The padding_left value
		 */
		public function setPadding($t:Number, $r:Number, $b:Number, $l:Number):void {
			padding_top = $t, padding_right = $r, padding_bottom = $b, padding_left = $l;
		}
		
		/**
		 *	This realigns all the managed objects according to their requested locations.
		 */
		public function realignAll():void {
			for (var f:Object in _managedPosition) {
				realign(f);
			}
		}
		
		/**
		 *	This realigns the given target.
		 *	
		 *	@param	target	 The target object (that's already managed) to realign
		 */
		public function realign($target:Object):void {
			var p:Point = getNewPosition($target);
			$target.x = p.x, $target.y = p.y;
		}
		
		/**
		 *	Gets the new position of the target.
		 *	
		 *	@param	target	 The target object (that's already managed) to get the new position of
		 *	@return		Point with the target's new position
		 */
		public function getNewPosition($target:Object):Point {
			var np:Point = new Point($target.x, $target.y);
			var m:Object = _managedPosition[$target];
			if(m.location != undefined){
				var p1:Point = Align.getLocation($target, m.location);
				var p2:Point = getStageLocation(m.alignment);
				if(!m.lockX) np.x = (($target.x - p1.x) + p2.x) + m.offsetX;
				if(!m.lockY) np.y = (($target.y - p1.y) + p2.y) + m.offsetY;
			} else {
				if(!m.lockX) np.x = m.ox - (m.osw - _target.stageWidth);
				if(!m.lockY) np.y = m.oy - (m.osh - _target.stageHeight);
			}
			if(max_width != 0 && (np.x) > max_width) np.x = max_width;
			if(max_height != 0 && (np.y) > max_height) np.y = max_height;			
			if(min_width != 0 && np.x < min_width) np.x = min_width;
			if(min_height != 0 && np.y < min_height) np.y = min_height;
			return np;
		}
		
		/**
		 *	@private
		 */
		protected function resizeHandler($o:Object):void {
			realignAll();
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
