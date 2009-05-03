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
		public function PrimitiveMultiTween($target:Object, $properties:Object, $duration:int, $ease:Function = null) {
			super($target, null, 0, $duration, $ease);
			arrayObject = PrimitiveMultiTween.makeMultiArrays($target, $properties);
		}
		
		/**
		 *	@private
		 */
		protected override function update($u:Object):void {
			var tmr:int = getTimer() - starttime;
			if(tmr >= duration){
				for (var i:int = 0; i < arrayObject.props.length; i++) {
					target[arrayObject.props[i]] = arrayObject.values[i];
				}
				end();
			} else {
				for (var k:int = 0; k < arrayObject.props.length; k++) {
					target[arrayObject.props[k]] = ease(tmr, arrayObject.startvalues[k], arrayObject.difvalues[k], duration);
				}
				dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {primitiveTween:this}));
			}
		}
	
	}

}
