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
	
	import com.desuade.utils.*
	
	/**
	 *  Manages multiple MotionControllers under one controller for a single target.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public dynamic class MultiController extends Object {
		
		/**
		 *	@private
		 */
		protected var _target:Object;
		
		/**
		 *	@private
		 */
		protected var _duration:Number;
		
		/**
		 *	<p>Creates a new MultiController. This controller creates MotionControllers to manage multiple properties on a single target object.</p>
		 *	
		 *	<p>Each property under this MultiController is a MotionController that is used to tween the target's same property (this['x'] == target['x'])</p>
		 *	
		 *	@param	target	 The target object to set for all child MotionControllers
		 *	@param	duration	 The length of time to set all child controllers
		 *	@param	properties	 An array of strings of child MotionControllers to create - ex: ['x', 'y', 'alpha']
		 *	@param	containerClass	 The class of keyframe container to use for all MotionControllers
		 *	@param	tweenClass	 The class of tweens to pass to all the keyframe container
		 */
		public function MultiController($target:Object, $duration:Number = 0, $properties:Array = null, $containerClass:Class = null, $tweenClass:Class = null) {
			super();
			_target = $target;
			_duration = $duration;
			if($properties != null){
				for (var i:int = 0; i < $properties.length; i++) {
					this[$properties[i]] = new MotionController($target, $properties[i], $duration, $containerClass, $tweenClass);
				}
			}
		}
		
		/**
		 *	The target for all child controllers
		 */
		public function get target():Object{
			return _target;
		}
		
		/**
		 *	@private
		 */
		public function set target($value:Object):void {
			_target = $value;
			for (var p:String in this) {
				this[p].target = $value;
			}
		}
		
		/**
		 *	Sets/gets the duration for all child controllers
		 */
		public function get duration():Number{
			return _duration;
		}
		
		/**
		 *	@private
		 */
		public function set duration($value:Number):void {
			_duration = $value;
			for (var p:String in this) {
				this[p].duration = $value;
			}
		}
		
		/**
		 *	This returns true if any of the child controllers are active. It will only return false if all the controllers are inactive.
		 */
		public function get active():Boolean{
			for (var p:String in this) {
				if(this[p].active) return true
			}
			return false;
		}
		
		/**
		 *	Creates a new child controller for the given property
		 *	
		 *	@param	proprty	 The property to have controlled
		 *	@param	containerClass	 The KeyframeContainer class to use
		 *	
		 *	@return		The MotionController added.
		 */
		public function addController($property:String, $containerClass:Class = null):MotionController {
			this[$property] = new MotionController(_target, $property, _duration, $containerClass);
			return this[$property];
		}
		
		/**
		 *	Adds a keyframe with the same label across all controllers at the same position.
		 *	
		 *	@param	position	 The position to add the keyframe (0-1)
		 *	@param	keyframes	 An object that has each controller and keyframe object - ex: {x:{value:'200', spread:'50'}, y:{value:0}, alpha:{ease:Sine.easeIn, value:.3}}
		 *	@param	label	 The label for the keyframe
		 */
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
		
		/**
		 *	This lets you configure a specific keyframe for each controller at once.
		 *	
		 *	@param	keyframe	 The label of the keyframe to set
		 *	@param	properties	 An object that has the properties of each controller - ex: {controller1:{value:40, spread:80}, controller3:{ease:Bounce.easeOut, value:5}}
		 */
		public function setKeyframes($keyframe:String, $properties:Object):void {
			for (var p:String in $properties) {
				for (var k:String in $properties[p]) {
					this[p].keyframes[$keyframe][k] = $properties[p][k];
				}
			}
		}
		
		/**
		 *	This starts all child MotionControllers at once. If a keyframe label is specified, each controller will be started at the given keyframe.
		 *	
		 *	@param	keyframe	 The label of the keyframe to start the controllers at.
		 *	@param	startTime	This is like keyframe, but instead uses actual time to start at, as if it's already been running. This overrides the keyframe param.
		 *	@param	rebuild		 Forces a rebuild of each MotionControllers internal sequence on start.
		 *	
		 *	@return		The MultiController (for chaining)
		 */
		public function start($keyframe:String = 'begin', $startTime:Number = 0, $rebuild:Boolean = false):* {
			for (var p:String in this){
				this[p].start($keyframe, $startTime, $rebuild);
			}
			return this;
		}
		
		/**
		 *	This stops all child MotionControllers at once
		 */
		public function stop():void {
			for (var p:String in this){
				this[p].stop();
			}
		}
		
		/**
		 *	This creates an XML object representing the MultiController and it's child MotionControllers.
		 *	
		 *	@return		And XML object for the MultiController
		 */
		public function toXML():XML {
			var txml:XML = <MultiController />;
			txml.setLocalName(XMLHelper.getSimpleClassName(this));
			txml.@duration = duration;
			for (var p:String in this){
				txml.appendChild(this[p].toXML());
			}
			return txml;
		}
		
		/**
		 *	Configures the MultiController and creates all child MotionControllers.
		 *	
		 *	@param	xml	 The XML object to use for configuration
		 *	@param	usealldurations	 If true, this uses all original durations for each controller. If false, all durations are set to the MultiController's duration value.
		 *	
		 *	@return		The MultiController object (for chaining)
		 */
		public function fromXML($xml:XML, $usealldurations:Boolean = true):MultiController {
			duration = Number($xml.@duration);
			var cd:XMLList = $xml.children();
			for (var i:int = 0; i < cd.length(); i++) {
				this[cd[i].@property] = new MotionController(_target, cd[i].@property, duration).fromXML(cd[i], false, $usealldurations);
			}
			return this;
		}
	
	}

}

