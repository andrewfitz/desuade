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

	public dynamic class MultiController extends Object {
		
		protected var _target:Object;
		protected var _duration:Number;
	
		public function MultiController($target:Object, $properties:Array, $duration:Number, $containerclass:Class = null, $tweenclass:Class = null) {
			super();
			_target = $target;
			_duration = $duration;
			for (var i:int = 0; i < $properties.length; i++) {
				this[$properties[i]] = new MotionController($target, $properties[i], $duration, $containerclass, $tweenclass);
			}
		}
		
		public function get target():Object{
			return _target;
		}
		public function set target($value:Object):void {
			_target = $value;
			for (var p:String in this) {
				this[p].target = $value;
			}
		}
		
		public function get duration():Number{
			return _duration;
		}
		public function set duration($value:Number):void {
			_duration = $value;
			for (var p:String in this) {
				this[p].duration = $value;
			}
		}
		
		public function get active():Boolean{
			for (var p:String in this) {
				if(this[p].active) return true
			}
			return false;
		}
		
		public function addController($property:String, $containerclass:Class = null):void {
			this[$property] = new MotionController(_target, $property, _duration, $containerclass);
		}
		
		public function addKeyframes($position:Number, $keyframes:Object, $label:String = null):void {
			for (var g:String in this) {
				var found:Boolean = false;
				for (var p:String in $keyframes) {
					if(p == g){
						var kp:Object = $keyframes[p];
						this[p].keyframes.add(new Keyframe($position, kp.value, kp.ease, kp.spread, kp.extras), $label);
						delete $keyframes[p];
						found = true;
						continue;
					}
				}
				if(!found) this[g].keyframes.add(new Keyframe($position, null), $label);
			}
		}
		
		public function setKeyframes($keyframe:String, $properties:Object):void {
			for (var p:String in $properties) {
				for (var k:String in $properties[p]) {
					this[p].keyframes[$keyframe][k] = $properties[p][k];
				}
			}
		}
		
		public function start($keyframe:String = null):void {
			for (var p:String in this){
				this[p].start($keyframe);
			}
		}
		
		public function stop():void {
			for (var p:String in this){
				this[p].stop();
			}
		}
	
	}

}

