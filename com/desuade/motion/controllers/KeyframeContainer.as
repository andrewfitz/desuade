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
	import com.desuade.utils.*

	public dynamic class KeyframeContainer extends Object {
		
		/**
		 *	@private
		 */
		protected var _keyframecount:Number = 0;
		
		/**
		 *	@private
		 */
		protected var _tweenclass:Class;
	
		/**
		 *	@private
		 */
		protected var _precision:int = 0;
	
		public function KeyframeContainer($tweenclass:Class = null) {
			super();
			_tweenclass = ($tweenclass != null) ? $tweenclass : MotionController.tweenClass;
			this['begin'] = new Keyframe(0, null, null);
			this['end'] = new Keyframe(1, null);
		}
		
		/**
		 *	How many decimal points the random spread values have.
		 */
		public function get precision():int{
			return _precision;
		}
		public function set precision($value:int):void {
			_precision = $value;
		}
		
		/**
		 *	Which tween class to use for creating the tweens. - ie: BasicTween, Tween, etc.
		 */
		public function get tweenclass():Class{
			return _tweenclass;
		}
		public function set tweenclass($value:Class):void {
			_tweenclass = $value;
		}
		
		/**
		 *	Adds a keyframe to the container. The only benefit this has is automatic label generation.
		 *	
		 *	@param	keyframe	 A Keyframe object to add
		 *	@param	label	 A label to give the keyframe. An auto-incremented label is created if none is provided.
		 *	
		 *	@see	Keyframe
		 */
		public function add($keyframe:Keyframe, $label:String = null):Object {
			$label = ($label == null) ? 'keyframe_' + ++_keyframecount : $label;
			return this[$label] = $keyframe;
		}
		
		/**
		 *	Removes all keyframes between the begin and end keyframes from the container.
		 *	
		 *	@return		An object of all the keyframes that were emptied
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
		 *	This "flattens" the container to the given value, setting all the 'value' and 'extra' properties in each keyframe to the same value, essentially removing any tweens.
		 *	
		 *	These always happen: the ease property becomes 'linear' and the spread becomes '0'.
		 *	
		 *	@param	value	 A value to set all the 'value' properties to. Pass a Number for absolute, or a String for relative.
		 *	@see #isFlat()
		 */
		public function flatten($value:*, $extras:Object):void {
			var pa:Array = this.toLabeledArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = Linear.none;
				p.value = $value;
				p.spread = '0';
				p.extras = $extras;
			}
			this['begin'].ease = null;
		}
		
		/**
		 *	Determines if the KeyframeContainer is flat.
		 *	
		 *	This doesn't mean that all properties that are checked are necessarily equal, but rather, if the total of keyframes end up having any change in value.
		 *	
		 *	@return		True if all the values result in the same end value.
		 *	@see	#flatten()
		 */
		public function isFlat():Boolean {
			var pa:Array = this.toLabeledArray();
			for (var i:int = 1; i < pa.length; i++) {
				if(pa[i].spread == '0' && pa[i].value == '0'){
				} else {
					if(pa[i].spread !== '0') return false;
					if(pa[i].value !== this['begin'].value && pa[i].value != null && pa[i].value !== '0') return false;
					if(this['begin'].spread !== '0' && pa[i].value != null && pa[i].value !== '0') return false;
				}
			}
			return true;
		}
		
		/**
		 *	@private
		 */
		internal function generateStartValue($target:Object, $property:String):* {
			var nv:Number;
			if(this['begin'].value == null) nv = $target[$property];
			else nv = (typeof this['begin'].value == 'string') ? $target[$property] + Number(this['begin'].value) : this['begin'].value;
			return (this['begin'].spread !== '0') ? Random.fromRange(nv, ((typeof this['begin'].spread == 'string') ? nv + Number(this['begin'].spread) : this['begin'].spread), precision) : nv;
		}
		
		/**
		 *	@private
		 */
		internal function setStartValue($target:Object, $property:String):void {
			$target[$property] = generateStartValue($target, $property);
		}
		
		/**
		 *	Creates an unsorted Array of all the objects in the KeyframeContainer
		 *	
		 *	@return		An unsorted Array of all the point Objects
		 */
		public function toLabeledArray():Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, extras:this[p].extras, label:p});
			}
			return pa;
		}
		
		/**
		 *	Creates an Array with all of the labels of the keyframes, from begin to end
		 *	
		 *	@return		An orderded Array with the labels of all keyframes in the container
		 */
		public function getOrderedLabels():Array {
			var pa:Array = this.toLabeledArray();
			var sa:Array = [];
			pa.sort(sortOnPosition);
			for (var i:int = 0; i < pa.length; i++) {
				sa.push(pa[i].label);
			}
			return sa;
		}
		
		/**
		 *	Creates a new copy of the KeyframeContainer, identical to the current one.
		 *	
		 *	@return		A new KeyframeContainer that has the same keyframes as the current one.
		 */
		public function clone():KeyframeContainer {
			var npc:KeyframeContainer = new KeyframeContainer();
			npc.precision = _precision;
			npc.tweenclass = _tweenclass;
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 1; i < sa.length-1; i++) {
				var p:Object = this[sa[i]];
				npc.add(new Keyframe(p.position, p.value, p.ease, p.spread, p.extras), sa[i]);
			}
			npc.begin.value = this['begin'].value;
			npc.begin.spread = this['begin'].spread;
			npc.begin.extras = this['begin'].extras;
			npc.end.value = this['end'].value;
			npc.end.spread = this['end'].spread;
			npc.end.ease = this['end'].ease;
			npc.end.extras = this['end'].extras;
			return npc;
		}
		
		//////private
		
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
		
		/**
		 *	@private
		 */
		protected function calculateDuration($duration:Number, $previous:Number, $position:Number):Number {
			return $duration*($position-$previous);
		}

		/**
		 *	@private
		 */
		internal function createTweens($target:Object, $property:String, $duration:Number):Array {
			var pa:Array = getOrderedLabels();
			var ta:Array = [];
			//skip begin keyframe (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = this[pa[i]];
				var nuv:Number;
				if(np.value == null){
					nuv = $target[$property];
				} else {
					var nnnv:* = np.value;
					if(typeof nnnv == 'string'){
						var nfpv:Number = (ta.length == 0) ? $target[$property] : ta[ta.length-1].value;
						nuv = nfpv + Number(nnnv);
					} else nuv = nnnv;
				}
				var nv:Number = (np.spread !== '0') ? Random.fromRange(nuv, ((typeof np.spread == 'string') ? nuv + Number(np.spread) : np.spread), precision) : nuv;
				var tmo:Object = {target:$target, property:$property, value:nv, ease:np.ease, duration:calculateDuration($duration, this[pa[i-1]].position, np.position), delay:0};
				for (var h:String in np.extras) {
					tmo[h] = np.extras[h];
				}
				ta.push(tmo);
			}
			return ta;
		}
		
	}

}
