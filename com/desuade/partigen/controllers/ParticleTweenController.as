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

package com.desuade.partigen.controllers {
	
	import com.desuade.motion.controllers.*;
	import com.desuade.motion.tweens.*;
	
	import flash.utils.*;

	/**
	 *  Used to configure MotionControllers for the particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.07.2009
	 */
	public class ParticleTweenController extends Object {
		
		/**
		 *	The duration of the entire controller to last. The length of individual tweens changes dependent on this.
		 */
		public var duration:Number;
		
		/**
		 *	This is where all the Keyframes are held and configured.
		 */
		public var keyframes:KeyframeContainer;
		
		/**
		 *	<p>This is like a MotionController from the Motion Package, but is used as a placeholder to configure emitters.</p>
		 *	
		 *	<p>ParticleTweenControllers create MotionControllers on each particle that's created, allowing the particles to change over their lives.</p>
		 *	
		 *	<p>Using the addTween() method is recommended over calling this directly.</p>
		 *	
		 *	@param	duration	 The entire duration for the controller. If this is 0, the duration will be set to the particle's life.
		 *	@param	containerClass	 The class to use for Keyframes. Null will use the default.
		 *	@param	tweenClass	 The class to use for tweening on the controller. Null will use the default.
		 */
		public function ParticleTweenController($duration:Number, $containerClass:Class = null, $tweenClass:Class = null) {
			super();
			duration = $duration;
			var containerClass:Class = ($containerClass == null) ? KeyframeContainer : $containerClass;
			keyframes = new containerClass($tweenClass || ParticleController.tweenClass);
		}
		
		/**
		 *	This easily sets the 'begin' and 'end' keyframes of the controller to create a standard "one-shot" tween.
		 *	
		 *	@param	begin	 The beginning value.
		 *	@param	beginSpread	 The beginning spread value.
		 *	@param	end	 The end value for the tween.
		 *	@param	endSpread	 The end spread value.
		 *	@param	ease	 The ease to use for the tween on the end keyframe.
		 *	@param	extras	 The extras object for the end keyframe.
		 */
		public function setSingleTween($begin:*, $beginSpread:*, $end:*, $endSpread:*, $ease:* = null, $extras:Object = null):void {
			keyframes.begin.value = $begin;
			keyframes.begin.spread = $beginSpread;
			keyframes.end.value = $end;
			keyframes.end.spread = $endSpread;
			keyframes.end.ease = $ease;
			keyframes.end.extras = $extras || {};
		}
		
		/**
		 *	<p>Create an XML object that contains the ParticleTweenController config, KeyframeContainer, and all child Keyframes.</p>
		 *	<p>Note: this does not include the "property" unless it's called from the ParticleController.</p>
		 *	
		 *	@return		An XML object representing the ParticleTweenController
		 */
		public function toXML():XML {
			var txml:XML = <ParticleTweenController />;
			txml.@duration = duration;
			txml.appendChild(keyframes.toXML());
			return txml;
		}
		
		/**
		 *	<p>Configures the ParticleTweenController from the XML object and sets the keyframes to the child KeyframeContainer XML and it's child Keyframes.</p>
		 *	<p>Note: this does not include the "property" unless it's called from the ParticleController.</p>
		 *	
		 *	@param	xml	 The XML object containing the config for the ParticleTweenController
		 *	
		 *	@return		The ParticleTweenController object (for chaining)
		 */
		public function fromXML($xml:XML):ParticleTweenController {
			duration = Number($xml.@duration);
			var kfclass:Class = getDefinitionByName("com.desuade.motion.controllers::" + $xml.children()[0].localName()) as Class;
			keyframes = new kfclass().fromXML($xml.children()[0]);
			return this;
		}
		
	}

}
