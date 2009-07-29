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

package com.desuade.motion.sequences {
	
	import com.desuade.debugging.*;
	import com.desuade.motion.events.*;
	import com.desuade.motion.tweens.*;
	
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
		protected override function itemCheck($o:*):* {
			if($o is SequenceGroup) {
				return $o;
			} else if($o is Sequence){
				return $o;
			} else if($o is Array) {
				return itemCheck(new SequenceGroup().pushArray($o));
			} else {
				for (var p:String in _overrides) {
					$o[p] = _overrides[p];
				}
				var targ:Object = $o.target;
				delete $o.target;
				return new motionClass(targ, $o);
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
		 *	<p>For example: <code>seq.overrides = {duration:3, ease:Linear.none}</code> will assign all the tweens in the sequence their 'duration' and 'ease' values to the given values in the overrides object.</p>
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

	}
}