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

package com.desuade.motion.sequences {
	
	import com.desuade.debugging.*;
	import com.desuade.motion.events.*;
	import com.desuade.motion.tweens.*;
	import com.desuade.motion.bases.*;
	
	import flash.utils.getTimer;
	
	/**
	 *  A Sequence that uses a single class and config objects to create a sequence.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.07.2009
	 */
	public dynamic class ClassSequence extends Sequence {
		
		/**
		 *	@private
		 */
		protected var _motionClass:Class;
		
		/**
		 *	@private
		 */
		protected var _overrides:Object;
		
		/**
		 *	<p>This is a Sequence that only uses one class to create sequence items.</p>
		 *	<p>All Config Objects passed in after the motionClass parametere will be added to the sequence.</p>
		 *	
		 *	@param	motionClass	 The class to use in creating the sequence
		 */
		public function ClassSequence($motionClass:Class, ... args) {
			super();
			pushArray(args);
			_motionClass = $motionClass;
		}
		
		/**
		 *	@private
		 */
		internal override function itemCheck($o:*):* {
			if($o is SequenceGroup) {
				return $o;
			} else if($o is Sequence){
				return $o;
			} else if($o is Array) {
				return new SequenceGroup().pushArray($o);
			} else {
				for (var p:String in _overrides) {
					$o[p] = _overrides[p];
				}
				if($o.target != undefined){
					var targ:Object = $o.target;
					delete $o.target;
					return new motionClass(targ, $o);
				} else {
					return new motionClass($o);
				}
			}
		}
		
		/**
		 *	<p>This is the class to use in creating the sequence.</p>
		 */
		public function get motionClass():Class{
			return _motionClass;
		}
		
		/**
		 *	@private
		 */
		public function set motionClass($value:Class):void {
			_motionClass = $value;
		}
		
		/**
		 *	<p>An Object that represents a normal Sequence object, that contains properties to be applied to every object in the Sequence.</p>
		 *	<p>For example: <code>seq.overrides = {duration:3, ease:'linear'}</code> will assign all the tweens in the sequence their 'duration' and 'ease' values to the given values in the overrides object.</p>
		 */
		public function get overrides():Object{
			return _overrides;
		}
		
		/**
		 *	@private
		 */
		public function set overrides($value:Object):void {
			_overrides = $value;
		}
		
		/**
		 *	This gets the current position in time out of the entire duration ONLY if the motionClass is a form of tween.
		 */
		public function getPositionInTime():Number {
			var totaldur:Number = 0;
			var durarr:Array = [];
			for (var i:int = 0; i < length; i++) {
				durarr.push((this[i].duration || 0) + (this[i].delay || 0));
				totaldur += durarr[i];
			}
			var parttime:Number = 0;
			for (var t:int = 0; t < position; t++) {
				parttime += durarr[t];
			}
			var pt:* = BaseTicker.getItem(current.pid);
			return parttime + (pt.duration - (getTimer()-pt.starttime)); 
		}
		
		/**
		 *	This allows you start at any point in time of the sequence ONLY if the motionClass is a form of tween.
		 *	
		 *	@param	time	 The time to position the sequence in.
		 */
		public function startAtTime($time:Number):void {
			var totaldur:Number = 0;
			var durarr:Array = [];
			for (var i:int = 0; i < length; i++) {
				durarr.push((this[i].duration || 0) + (this[i].delay || 0));
				totaldur += durarr[i];
			}
			var fti:Number = 0;
			for (var r:int = 0; r < durarr.length; r++) {
				if($time < (fti + durarr[r])){
					if(this[r] is SequenceGroup){
						for (var p:int = 0; p < this[r].length; p++) {
							var dr:Number = ((this[r][p].delay || 0) - ($time - fti));
							if(dr >= 0){
								this[r][p].delay = dr;
								this[r][p].position = 0;
							} else {
								this[r][p].delay = 0;
								this[r][p].position = (this[r][p].duration-(dr + this[r][p].duration))/this[r][p].duration;
							}
						}
					} else {
						var dr2:Number = ((this[r].delay || 0) - ($time - fti));
						if(dr2 >= 0){
							this[r].delay = dr2;
							this[r].position = 0;
						} else {
							this[r].delay = 0;
							this[r].position = (this[r].duration-(dr2 + this[r].duration))/this[r].duration;
						}
					}
					start(r);
					return;
				} else {
					if(this[r] is SequenceGroup){
						var ni:* = itemCheck(this[r]);
						for (var h:int = 0; h < ni.length; h++) {
							for (var t:String in _overrides) {
								ni[h][t] = _overrides[t];
							}
							if(ni[h].property != undefined && ni[h].property != null) ni[h].target[ni[h].property] = ni[h].value;
						}
					} else {
						for (var g:String in _overrides) {
							this[r][g] = _overrides[g];
						}
						if(this[r].property != undefined && this[r].property != null) this[r].target[this[r].property] = this[r].value;
					}
				}
				fti += durarr[r];
			}
		}
		
		/**
		 *	This gets the total duration ONLY if the motionClass is a form of tween.
		 */
		public function get duration():Number {
			var totaldur:Number = 0;
			for (var i:int = 0; i < length; i++) {
				totaldur += (this[i].duration || 0) + (this[i].delay || 0);
			}
			return totaldur;
		}
		
	}
}