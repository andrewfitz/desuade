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

	public dynamic class MetaController extends Object {
		
		protected var _target:Object;
		protected var _properties:Array;
		protected var _duration:Number;
	
		public function MetaController($target:Object, $properties:Array, $duration:Number, $containerclass:Class = null) {
			super();
			_target = $target;
			_properties = $properties;
			_duration = $duration;
			for (var i:int = 0; i < $properties.length; i++) {
				this[$properties[i]] = new MotionController($target, $properties[i], $duration, $containerclass);
			}
		}
		
		public function get target():Object{
			return _target;
		}
		public function set target($value:Object):void {
			_target = $value;
		}
		
		public function get properties():Array{
			return _properties;
		}
		
		public function get duration():Number{
			return _duration;
		}
		public function set duration($value:Number):void {
			_duration = $value;
		}
		
		public function get active():Boolean{
			for (var p:String in this) {
				if(this[p].active) return true
			}
			return false;
		}
		
		public function addController($property:String, $containerclass:Class = null):void {
			_properties.push($property);
			this[$property] = new MotionController(_target, $property, _duration, $containerclass);
		}
		
		public function addKeyframes($position:Number, $keyframes:Object, $label:String = null):void {
			for (var i:int = 0; i < _properties.length; i++) {
				var found:Boolean = false;
				for (var p:String in $keyframes) {
					var kp:Object = $keyframes[p];
					if(p == _properties[i]){
						this[p].keyframes.add(new Keyframe($position, kp.value, kp.ease, kp.spread, kp.extras), $label);
						delete $keyframes[p];
						found = true;
						continue;
					}
				}
				if(!found){
					this[_properties[i]].keyframes.add(new Keyframe($position, null), $label);
				}
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

