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

package com.desuade.motion.tweens {

	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	/**
	 *  This is a PrimitiveTween that's used to tween multiple properties on an object in a single tween.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class PrimitiveMultiTween extends PrimitiveTween {
		
		/**
		 *	@private
		 */
		internal var arrayObject:Object;
		
		/**
		 *	@private
		 */
		public static function makeMultiArrays($target:Object, $object:Object):Object {
			var ob:Object = {props:[], values:[], startvalues:[], difvalues:[]};
			for (var p:String in $object) {
				ob.props.push(p);
				ob.values.push($object[p]);
				ob.startvalues.push($target[p]);
				ob.difvalues.push(($target[p] > $object[p]) ? ($object[p]-$target[p]) : -($target[p]-$object[p]));
			}
			return ob;
		}
		
		/**
		 *	This creates a new, raw PrimitiveTween. Users should use the Tween class instead of creating this directly.	
		 */
		public function PrimitiveMultiTween() {
			super();
		}
		
		/**
		 *	This inits the PrimitiveMultiTween.
		 *	
		 *	@param	target	 The target object to perform the tween on.
		 *	@param	properties	 An object of properties and values to tween on the target.
		 *	@param	value	 The new (end) value the property will be tweened to.
		 *	@param	duration	 How long the tween will last in ms.
		 *	@param	ease	 What easing equation to use to tween.
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public override function init(... args):void {
			super.init(args[0], null, 0, args[2], args[3]);
			arrayObject = PrimitiveMultiTween.makeMultiArrays(args[0], args[1]);
		}
		
		/**
		 *	This renders the tween. It calculates and sets the new value, and checks to see if the tween is finished.
		 *	
		 *	@param	time	 The current getTimer() time.
		 */
		public override function render($time:int):void {
			$time -= starttime;
			if($time >= duration){
				for (var i:int = 0; i < arrayObject.props.length; i++) {
					target[arrayObject.props[i]] = arrayObject.values[i];
				}
				updateFunc(this);
				end();
			} else {
				for (var k:int = 0; k < arrayObject.props.length; k++) {
					target[arrayObject.props[k]] = ease($time, arrayObject.startvalues[k], arrayObject.difvalues[k], duration);
				}
				updateFunc(this);
				//dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {primitiveTween:this}));
			}
		}
	
	}

}
