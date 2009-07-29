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
	
	public class ClassSequence extends Sequence {
		
		/**
		 *	@private
		 */
		protected var _tweenClass:Class;
		
		/**
		 *	@private
		 */
		protected var _overrides:Object;
		
		/**
		 *	@private
		 */
		protected var _allowOverrides:Boolean = true;
		
		/**
		 *	<p>This is a Sequence that only uses one class to create sequence items.</p>
		 */
		public function ClassSequence($tweenClass:Class, ... args) {
			super();
			pushArray(args);
			_tweenClass = $tweenClass;
		}
		
		/**
		 *	<p>This is the class of tweens to use in the sequence.</p>
		 *	<p>Each Seqeuence will create only one kind of tween - ie: BasicTween, Tween, MultiTween, etc. To create a Seqeuence that contains multiple tween classes, create a new Seqeuence and then push that into the Array.</p>
		 */
		public function get tweenClass():Class{
			return _tweenClass;
		}
		
		/**
		 *	@private
		 */
		public function set tweenClass($value:Class):void {
			_tweenClass = $value;
		}
		
		/**
		 *	<p>An Object that represents a normal Sequence object, that contains properties to be applied to every object in the Sequence.</p>
		 *	
		 *	<p>For example: <code>seq.overrides = {target:my_obj, ease:Linear.none}</code> will assign all the tweens in the sequence their 'target' and 'ease' values to the given values in the overrides object, unless the object has <code>{allowOverrides:false}</code></p>
		 *	
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
		 *	Does the Seqeuence allow it's objects to be replaced with override values.
		 */
		public function get allowOverrides():Boolean{
			return _allowOverrides;
		}
		
		/**
		 *	@private
		 */
		public function set allowOverrides($value:Boolean):void {
			_allowOverrides = $value;
		}

	}
}