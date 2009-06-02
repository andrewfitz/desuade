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

package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.tweens.*
	import com.desuade.motion.eases.*

	/**
	 *  This is a container for working with points, used by a ValueController.
	 *	
	 *	When working with ValueControllers, this object is interfaced through myValueController.points, and provides all the methods used to add, remove, and manipulate points.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.04.2009
	 */
	public dynamic class PointsContainer extends BasePointsContainer {
	
		/**
		 *	This creates a new PointsContainer. For most uses, you do not need to create this for each ValueController, as this is all internally handled by the corresponding ValueController when that is created.
		 *	Multiple controllers can use the same points container, by either directly assigning a ValueController.points to another's, or creating a standalone PointsContainer that many can reference. This allows for incredible flexibility.
		 *	
		 *	@param	value	 This sets the begin and end values to this. Pass a Number for absolute, or a String for relative.
		 */
		public function PointsContainer($value:* = '0'){
			super();
			this.begin = {value:$value, spread:'0', position:0};
			this.end = {value:$value, spread:'0', position:1, ease:Linear.none};
		}
		
		/**
		 *	This adds a point to the PointsContainer.
		 *	
		 *	"Points" are like a keyframe on the timeline. The all have a value, ease, label, and position. The ValueCntroller starts at the 'begin' point, and creates a sequence of tweens connecting from point-to-point, all the way to the 'end' point. Think in terms of a line graph, each point is a 'point' on the line.
		 *	
		 *	If no points are added, the ValueCntroller will simply create 1 tween from 'begin' to 'end'.
		 *	
		 *	@param	value	 A value to tween to. The target will arive (the tween will end) at this value at the position of this point. Pass a Number for absolute, or a String for relative.
		 *	@param	spread	 A value to create a random range from. If the spread doesn't equal the 'value' value or '0', a random value will be created between the 'value' and the 'spread'. Pass a Number for absolute, or a String for relative.
		 *	@param	position	 A value between 0-1 that reprsents the position of the point, 0 being the beginning of the controller and 1 being the end point (0 and 1 are already taken by 'begin' and 'end' points)
		 *	@param	ease	 What ease function to use. Adobe ease functions like Bounce.easeOut, etc. null will default to Linear.none.
		 *	@param	label	 A custom label for the point. Defaults to "point1", "point2", etc.
		 */
		public function add($value:*, $spread:*, $position:Number, $ease:* = null, $label:String = null):Object {
			$label = ($label == null) ? 'point' + ++_pointcount : $label;
			Debug.output('motion', 10001, [$label, $position]);
			return this[$label] = {value:$value, spread:$spread, position:$position, ease: $ease || Linear.none};
		}
		
		/**
		 *	Creates an unsorted Array of all the objects in the PointsContainer
		 *	
		 *	@return		An unsorted Array of all the point Objects
		 */
		public function toArray():Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, label:p});
			}
			return pa;
		}
		
		/**
		 *	This "flattens" the container to the given value, setting all the 'value' properties in each point to the same value, essentially removing any tweens. The type and amount are also available to set.
		 *	
		 *	These always happend: the ease property becomes 'linear' and the spread becomes null.
		 *	
		 *	@param	value	 A value to set all the 'value' properties to. Pass a Number for absolute, or a String for relative.
		 *	@see #isFlat()
		 */
		public function flatten($value:*):void {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = Linear.none;
				p.value = $value;
				p.spread = '0';
			}
			delete this.begin.ease;
		}
		
		/**
		 *	Determines if the PointsContainer is flat.
		 *	
		 *	This doesn't mean that all properties that are checked are necessarily equal, but rather, if the total of points end up having any change in value.
		 *	
		 *	@return		True if all the values result in the same end value.
		 *	@see	#flatten()
		 */
		public function isFlat():Boolean {
			var pa:Array = this.toArray();
			for (var i:int = 1; i < pa.length; i++) {
				if(pa[i].spread == '0' && pa[i].value == '0'){
				} else {
					if(pa[i].spread !== '0') return false;
					if(pa[i].value !== this.begin.value && pa[i].value != null && pa[i].value !== '0') return false;
					if(this.begin.spread !== '0' && pa[i].value != null && pa[i].value !== '0') return false;
				}
			}
			return true;
		}
		
		/**
		 *	Creates a new copy of the PointsContainer, identical to the current one.
		 *	
		 *	@return		A new PointsContainer that has the same points as the current one.
		 */
		public function clone():PointsContainer {
			var npc:PointsContainer = new PointsContainer();
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 1; i < sa.length-1; i++) {
				var p:Object = this[sa[i]];
				npc.add(p.value, p.spread, p.position, p.ease, sa[i]);
			}
			npc.begin = {value:this.begin.value, spread:this.begin.spread, position:0};
			npc.end = {value:this.end.value, spread:this.end.spread, position:1, ease:this.end.ease};
			return npc;
		}
				
	}

}
