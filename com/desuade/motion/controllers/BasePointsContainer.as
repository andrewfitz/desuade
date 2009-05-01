package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.tweens.*

	/**
	 *  This is the base points container class that the PointsContainer and ColorPointsContainer inherit from. It's used to hold 'points' for ValueControllers and offers methods to work with the points.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  20.04.2009
	 */
	public dynamic class BasePointsContainer extends Object {
		
		/**
		 *	@private
		 */
		protected var _pointcount:Number = 0;
		
		/**
		 *	Contstuctor creates a new BasePointsContainer
		 *	
		 *	@param	value	 sets the default value of the begin and end points
		 */
		public function BasePointsContainer($value:* = '0'){
			super();
		}
		
		/**
		 *	Removes a point from the container with the given label. Begin and end points can not be removed.
		 *	
		 *	@param	label	 The label of the point to remove
		 */
		public function remove($label:String):void {
			if($label != 'begin' && $label != 'end') delete this[$label];
		}
		
		/**
		 *	Creates an Array with all of the labels of the points, from begin to end points
		 *	
		 *	@return		An orderded Array with the labels of all points in the container
		 */
		public function getOrderedLabels():Array {
			var pa:Array = this.toArray();
			var sa:Array = [];
			pa.sort(sortOnPosition);
			for (var i:int = 0; i < pa.length; i++) {
				sa.push(pa[i].label);
			}
			return sa;
		}
		
		/**
		 *	Removes all points from the container.
		 *	
		 *	@return		An object of all the points that were emptied
		 */
		public function empty():Object {
			var no:Object = {};
			for (var p:String in this) {
				if(p != 'begin' && p != 'end'){
					no[p] = this[p];
					this[p] = null;
					delete this[p];
				}
			}
			return no;
		}
		
		/**
		 *	@private
		 */
		internal static function sortOnPosition(a:Object, b:Object):Number {
		    var aPos:Number = a.position;
		    var bPos:Number = b.position;
		    if(aPos > bPos) {
		        return 1;
		    } else if(aPos < bPos) {
		        return -1;
		    } else {
		        return 0;
		    }
		}
		
	}

}
