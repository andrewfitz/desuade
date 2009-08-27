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

	import flash.geom.Point;
	
	/**
	 *  Align class provides static methods for aligning display objects
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  26.08.2009
	 */
	public class Align {
		
		/**
		 *	<p>This returns a Point containing the x and y values for the given location passed.</p>
		 *	<p>This is a list of available locations:</p>
		 *	<ul>
		 *	<li>top</li>
		 *	<li>top_left</li>
		 *	<li>top_center</li>
		 *	<li>top_right</li>
		 *	<li>bottom</li>
		 *	<li>bottom_left</li>
		 *	<li>bottom_center</li>
		 *	<li>bottom_right</li>
		 *	<li>left</li>
		 *	<li>left_center</li>
		 *	<li>right</li>
		 *	<li>right_center</li>
		 *	<li>center</li>
		 *	</ul>
		 *	
		 *	@param	target	 The target Object to get the alignment from
		 *	@param	location	 The string for the location desired
		 *	
		 *	@return		A Point object.
		 */
		public static function getLocation($target:Object, $location:String):Point {
			var tp:Point = new Point(0,0);
			switch ($location) {
				case 'top':
					tp.y = $target.y;
					break;
				case 'top_left':
					tp.y = $target.y;
					tp.x = $target.x;
					break;
				case 'top_center':
					tp.y = $target.y;
					tp.x = $target.x + ($target.width/2);
					break;
				case 'top_right':
					tp.y = $target.y;
					tp.x = $target.x + $target.width;
					break;
				case 'bottom':
					tp.y = $target.y + $target.height;
					break;
				case 'bottom_left':
					tp.y = $target.y + $target.height;
					tp.x = $target.x;
					break;
				case 'bottom_center':
					tp.y = $target.y + $target.height;
					tp.x = $target.x + ($target.width/2);
					break;
				case 'bottom_right':
					tp.y = $target.y + $target.height;
					tp.x = $target.x + $target.width;
					break;
				case 'left':
					tp.x = $target.x;
					break;
				case 'left_center':
					tp.x = $target.x;
					tp.y = $target.y + ($target.height/2);
					break;
				case 'right':
					tp.x = $target.x + $target.width;
					break;
				case 'right_center':
					tp.x = $target.x + $target.width;
					tp.y = $target.y + ($target.height/2);
					break;
				case 'center':
					tp.x = $target.x + ($target.width/2);
					tp.y = $target.y + ($target.height/2);
					break;
			}
			return tp;
		}
		
		/**
		 *	<p>This aligns the given location of the first target, with the location of the seconed target.</p>
		 *	
		 *	@param	target	 Target object to align
		 *	@param	targetLocation	 The location of the target to align
		 *	@param	alignedTarget	 The target to align to
		 *	@param	alignedTargetLocation	 The location of the alignedTarget to align to
		 */
		public static function locToLoc($target:Object, $targetLocation:String, $alignedTarget:Object, $alignedTargetLocation:String):void {
			var p1:Point = getLocation($target, $targetLocation);
			var p2:Point = getLocation($alignedTarget, $alignedTargetLocation);
			$target.x = ($target.x - p1.x) + p2.x;
			$target.y = ($target.y - p1.y) + p2.y;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 */
		public static function top($target:Object, $alignedTarget:Object, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'top');
			$target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function top_left($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'top_left');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function top_center($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'top_center');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function top_right($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'top_right');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 */
		public static function bottom($target:Object, $alignedTarget:Object, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'bottom');
			$target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function bottom_left($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'bottom_left');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function bottom_center($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'bottom_center');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function bottom_right($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'bottom_right');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function left($target:Object, $alignedTarget:Object, $offsetX:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'left');
			$target.x = p.x + $offsetX;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function left_center($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'left_center');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function right($target:Object, $alignedTarget:Object, $offsetX:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'right');
			$target.x = p.x + $offsetX;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function right_center($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'right_center');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
		
		/**
		 *	Aligns the target with the location of the alignedTarget
		 *	
		 *	@param	target	 The target object to align
		 *	@param	alignedTarget	 The object that that target will align with
		 *	@param	offsetY	 Any offset to set on the Y value
		 *	@param	offsetX	 Any offset to set on the X value
		 */
		public static function center($target:Object, $alignedTarget:Object, $offsetX:Number = 0, $offsetY:Number = 0):void {
			var p:Point = getLocation($alignedTarget, 'center');
			$target.x = p.x + $offsetX, $target.y = p.y + $offsetY;
		}
	
	}

}
