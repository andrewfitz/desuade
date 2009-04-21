package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	
	/**
	 *  The ColorPointsContainer is the points container used with the ColorValueController. It holds all the points used by the controller, and methods to deal with them. It's identical to the regular PointsContainer, except those changes made to work with colors.
	 *	
	 *	For more information, read the documentation on PointsContainers.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.04.2009
	 */
	public dynamic class ColorPointsContainer extends BasePointsContainer {
		
		/**
		 *	This creates a new ColorPointsContainer. For most uses, this is all internally handled by the corresponding ColorValueController. Multiple controllers can use the same points container, allowing for incredible flexibility.
		 *	
		 *	@param	value	 The default value to assign to the begin and end points. Defaults to 'none', meaning that point will have no color applied, and use the type 'reset'
		 *	@param	type	 What kind of color transformation to perform. See com.desuade.utils.ColorHelper#getColorObject() for the various types
		 *	@param	amount	 The amount of color transformation to apply. This varies with the type property.
		 *	@see	com.desuade.utils.ColorHelper#getColorObject()
		 */
		public function ColorPointsContainer($value:* = 'none', $type:String = 'tint', $amount:Number = 1) {
			super();
			this.begin = {value:$value, spread:null, type:$type, amount:$amount, position:0};
			this.end = {value:$value, spread:null, type:$type, amount:$amount, position:1, ease:BasePointsContainer.linear};
		}
		
		/**
		 *	This adds a point to the ColorPointsContainer.
		 *	
		 *	"Points" are like a keyframe on the timeline. The all have a value, ease, label, and position. The ColorValueCntroller starts at the 'begin' point, and creates a sequence of tweens connecting from point-to-point, all the way to the 'end' point. Think in terms of a line graph, each point is a 'point' on the line.
		 *	
		 *	If no points are added, the ColorValueCntroller will simply create 1 tween from 'begin' to 'end'.
		 *	
		 *	@param	value	 A color value to tween to. A value to tween to. The target will arive (the tween will end) at this value at the position of this point. This may be irrelevant for certian types. String or uint - ie: "#FFF000", 140285, 0xff0044
		 *	@param	spread	 If this doesn't equal null, the value and spread will be used as a range for a random color between the two.
		 *	@param	position	 A value between 0-1 that reprsents the position of the point, 0 being the beginning of the controller and 1 being the end point (0 and 1 are already taken by 'begin' and 'end' points)
		 *	@param	type	 What kind of color transformation to perform. See com.desuade.utils.ColorHelper#getColorObject() for the various types
		 *	@param	amount	 The amount of color transformation to apply. This varies with the type property.
		 *	@param	ease	 What ease function to use. Adobe ease functions like Bounce.easeOut, etc. null will default to a linear ease.
		 *	@param	label	 A custom label for the point. Defaults to "point1", "point2", etc.
		 */
		public function add($value:*, $spread:*, $position:Number, $type:String = 'tint', $amount:Number = 1, $ease:* = null, $label:String = null):Object {
			$label = ($label == null) ? 'point' + ++_pointcount : $label;
			Debug.output('motion', 10001, [$label, $position]);
			return this[$label] = {value:$value, spread:$spread, position:$position, type:$type, amount:$amount, ease: $ease || BasePointsContainer.linear};
		}
		
		/**
		 *	Creates an unsorted Array of all the objects in the ColorPointsContainer
		 *	
		 *	@return		An unsorted Array of all the point Objects
		 */
		public function toArray():Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, type:this[p].type, amount:this[p].amount, label:p});
			}
			return pa;
		}
		
		/**
		 *	This "flattens" the container to the given value, setting all the 'value' properties in each point to the same value, essentially removing any tweens. The type and amount are also available to set.
		 *	
		 *	These always happend: the ease property becomes 'linear' and the spread becomes null.
		 *	
		 *	@param	value	 A color value to tween to. This may be irrelevant for certian types. String or uint - ie: "#FFF000", 140285, 0xff0044
		 *	@param	type	 What kind of color transformation to perform. See com.desuade.utils.ColorHelper#getColorObject() for the various types
		 *	@param	amount	 The amount of color transformation to apply. This varies with the type property.
		 *	@see #isFlat()
		 */
		public function flatten($value:*, $type:String = 'tint', $amount:Number = 1):void {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = BasePointsContainer.linear;
				p.value = $value;
				p.type = $type;
				p.amount = $amount;
				p.spread = null;
			}
			delete this.begin.ease;
		}
		
		/**
		 *	Determines if the ColorPointsContainer is flat.
		 *	
		 *	@return		True if all the values are the same.
		 *	@see #flatten()
		 */
		public function isFlat():Boolean {
			var pa:Array = this.toArray();
			for (var i:int = 0; i < pa.length; i++) {
				if((pa[i].value != this.begin.value || pa[i].amount != this.begin.amount) && pa[i].value != null) return false;
			}
			return true;
		}
		
		/**
		 *	Creates a new copy of the ColorPointsContainer, identical to the current one.
		 *	
		 *	@return		A new ColorPointsContainer that has the same points as the current one.
		 */
		public function clone():ColorPointsContainer {
			var npc:ColorPointsContainer = new ColorPointsContainer();
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 1; i < sa.length-1; i++) {
				var p:Object = this[sa[i]];
				npc.add(p.value, p.spread, p.position, p.type, p.amount, p.ease, sa[i]);
			}
			npc.begin = {value:this.begin.value, spread:this.begin.spread, type:this.begin.type, amount:this.begin.amount, position:0};
			npc.end = {value:this.end.value, spread:this.end.spread, type:this.end.type, amount:this.end.amount, position:1, ease:this.end.ease};
			return npc;
		}
		
	}

}
