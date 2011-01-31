/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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
	
	import flash.utils.*;
	
	/**
	 *  Manages and holds all keyframes for MotionControllers.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class KeyframeContainer extends Object {
		
		/**
		 *	@private
		 */
		protected var _tweenClass:Class;
	
		/**
		 *	@private
		 */
		protected var _precision:int = 0;
		
		/**
		 *	<p>Creates a new KeyframeContainer. This is the core of a MotionController, as it holds, configures, and manages all keyframes, and generates the tween objects.</p>
		 *	
		 *	<p>Each KeyframeContainer will always have 2 keyframes: begin and end. Setting an end value will create a tween, and adding any keyframes will essentially divide it at a specified position and create 2 tweens.</p>
		 *	
		 *	<p>These are always created automatically by mew MotionControllers, but can also be created independently of a controller and shared among multiple ones.</p>
		 *	
		 *	@param	tweenClass	 The class of tweening engine to use. Null will use the default tweenClass from the MotionController static class.
		 */
		public function KeyframeContainer($tweenClass:Class = null) {
			super();
			_tweenClass = ($tweenClass != null) ? $tweenClass : MotionController.tweenClass;
			this['begin'] = new Keyframe(0);
			this['end'] = new Keyframe(1);
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
		 *	How many keyframes are in the container.
		 */
		public function get length():int{
			var c:int = 0;
			for (var p:String in this) c++;
			return c;
		}
		
		/**
		 *	Which tween class to use for creating the tweens. - ie: BasicTween, Tween, etc.
		 */
		public function get tweenClass():Class{
			return _tweenClass;
		}
		public function set tweenClass($value:Class):void {
			_tweenClass = $value;
		}
		
		/**
		 *	Adds a keyframe to the container. The only benefit this has is automatic label generation.
		 *	
		 *	@param	keyframe	 A Keyframe object to add
		 *	@param	label	 A label to give the keyframe. An auto-incremented label is created if none is provided.
		 *	@return		The keyframe's label
		 *	
		 *	@see	Keyframe
		 */
		public function add($keyframe:Keyframe, $label:String = null):String {
			$label = ($label == null) ? 'keyframe_' + (length+1) : $label;
			this[$label] = $keyframe;
			return $label;
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
		 *	<p>This "flattens" the container to the given value, setting all the 'value' and 'extra' properties in each keyframe to the same value, essentially removing any tweens.</p>
		 *	
		 *	<p>Note: this always happen: the ease property becomes 'linear' and the spread becomes '0'.</p>
		 *	
		 *	@param	value	 A value to set all the 'value' properties to. Pass a Number for absolute, or a String for relative.
		 *	@param	extras	 An object containing an extra properties to pass to the tween
		 *	
		 *	@see #isFlat()
		 */
		public function flatten($value:*, $extras:Object = null):void {
			var pa:Array = this.toLabeledArray();
			for (var i:int = 0; i < pa.length; i++) {
				var p:Object = this[pa[i].label];
				p.ease = 'linear';
				p.value = $value;
				p.spread = '0';
				p.extras = $extras || {};
			}
			this['begin'].ease = null;
		}
		
		/**
		 *	<p>Determines if the KeyframeContainer is flat. Used to determine if there is any actual change in value to tween.</p>
		 *	
		 *	<p>Note: this doesn't necessarily mean that all properties that are checked are necessarily equal, but rather, if the total of keyframes end up having any change in value.</p>
		 *	
		 *	@return		True if all the values result in the same end value.
		 *	@see	#flatten()
		 */
		public function isFlat():Boolean {
			var pa:Array = this.toLabeledArray();
			for (var i:int = 0; i < pa.length; i++) {
				if(pa[i].spread === '0' && (pa[i].value === '0' || pa[i].value == 'none')){
				} else {
					if(pa[i].spread !== '0' && pa.length > 2) return false;
					if(pa[i].value !== this['begin'].value && pa[i].value != null && pa[i].value !== '0') return false;
					if(pa[i].label != 'begin') {
						if(this['begin'].spread !== '0' && pa[i].value != null && pa[i].value !== '0') return false;
					}
				}
			}
			return true;
		}
		
		/**
		 *	Creates an unsorted Array of all the objects in the KeyframeContainer
		 *	
		 *	@param	sort	 Sort the Array based on position
		 *	
		 *	@return		An unsorted Array of all the keyframe Objects
		 */
		public function toLabeledArray($sort:Boolean = false):Array {
			var pa:Array = [];
			for (var p:String in this) {
				pa.push({value:this[p].value, spread:this[p].spread, ease:this[p].ease, position:this[p].position, extras:this[p].extras, label:p});
			}
			return ($sort) ? pa.sort(sortOnPosition) : pa;
		}
		
		/**
		 *	Creates an Array with all of the labels of the keyframes, from begin to end
		 *	
		 *	@return		An orderded Array with the labels of all keyframes in the container
		 */
		public function getOrderedLabels():Array {
			var pa:Array = this.toLabeledArray(true);
			var sa:Array = [];
			for (var i:int = 0; i < pa.length; i++) {
				sa.push(pa[i].label);
			}
			return sa;
		}
		
		/**
		 *	This creates an XML object that represents a KeyframeContainer and all it's Keyframes.
		 *	
		 *	@return		An XML object representing the KeyframeContainer including child Keyframes.
		 */
		public function toXML():XML {
			var txml:XML = <kfc />;
			txml.setLocalName(XMLHelper.getSimpleClassName(this));
			txml.@tweenClass = XMLHelper.getSimpleClassName(_tweenClass);
			txml.@precision = _precision;
			var sa:Array = this.getOrderedLabels();
			for (var i:int = 0; i < sa.length; i++) {
				var k:Keyframe = this[sa[i]];
				var kx:XML = k.toXML();
				kx.@label = sa[i];
				txml.appendChild(kx);
			}
			return txml;
		}
		
		/**
		 *	Configures the KeyframeContainer based on the values in the XML and creates child Keyframes.
		 *	
		 *	@param	xml	 The XML object to use.
		 *	
		 *	@return		This KeyframeContainer object (for chaining)
		 */
		public function fromXML($xml:XML):KeyframeContainer {
			_tweenClass = getDefinitionByName("com.desuade.motion.tweens::" + $xml.@tweenClass) as Class;
			_precision = int($xml.@precision);
			var cd:XMLList = $xml.children();
			for (var i:int = 0; i < cd.length(); i++) {
				this[cd[i].@label] = new Keyframe(0).fromXML(cd[i]);
			}
			return this;
		}
		
		//////private
		
		/**
		 *	@private
		 */
		internal function generateStartValue($target:Object, $property:String, $keyframe:String):* {
			var nv:Number;
			var bkf:Keyframe = this[$keyframe];
			if(bkf.value == null) nv = $target[$property];
			else nv = (typeof bkf.value == 'string') ? $target[$property] + Number(bkf.value) : bkf.value;
			return (bkf.spread !== '0') ? Random.fromRange(nv, ((typeof bkf.spread == 'string') ? nv + Number(bkf.spread) : bkf.spread), precision) : nv;
		}
		
		/**
		 *	@private
		 */
		internal function setStartValue($target:Object, $property:String, $keyframe:String, $sequence:Array = null):void {
			$target[$property] = ($sequence != null && $keyframe == 'begin') ? $sequence[0].value : generateStartValue($target, $property, $keyframe);
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
			for (var i:int = 0; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = this[pa[i]];
				var nuv:Number;
				if(np.value == null){
					nuv = $target[$property];
				} else {
					var nnnv:* = np.value;
					if(typeof nnnv == 'string'){
						var nfpv:Number = (i == 0) ? $target[$property] : ta[ta.length-1].value;
						nuv = nfpv + Number(nnnv);
					} else nuv = nnnv;
				}
				var nv:Number = (np.spread !== '0') ? Random.fromRange(nuv, ((typeof np.spread == 'string') ? nuv + Number(np.spread) : np.spread), precision) : nuv;
				var tmo:Object = {property:$property, value:nv, ease:np.ease, duration:(i == 0) ? 0 : calculateDuration($duration, this[pa[i-1]].position, np.position), delay:0};
				for (var h:String in np.extras) {
					tmo[h] = np.extras[h];
				}
				ta.push(tmo);
			}
			return ta;
		}
		
	}

}
