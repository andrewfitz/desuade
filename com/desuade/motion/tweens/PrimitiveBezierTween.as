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
	 *  This is a PrimitiveTween that also has bezier points, used by the Tween class to create bezier tweens.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class PrimitiveBezierTween extends PrimitiveTween {
		
		/**
		 *	The array that contains all the bezier points for the tween.
		 */
		public var bezier:Array;
		
		/**
		 *	This creates a new, raw PrimitiveTween. Users should use the Tween class, instead of creating this directly.
		 *	
		 *	@param	target	 The target object to perform the tween on.
		 *	@param	property	 The property to tween on the target.
		 *	@param	value	 The new (end) value the property will be tweened to.
		 *	@param	duration	 How long the tween will last in ms.
		 *	@param	bezier	 An array of points to create a bezier curve with.
		 *	@param	ease	 What easing equation to use to tween.
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#bezier
		 *	@see	PrimitiveTween#ease
		 */
		public function PrimitiveBezierTween($target:Object, $property:String, $value:Number, $duration:int, $bezier:Array, $ease:Function = null) {
			bezier = $bezier;
			super($target, $property, $value, $duration, $ease);
		}
		
		/**
		 *	@private
		 */
		protected override function update(u:Object):void {
			var tmr:int = getTimer() - starttime;
			if(tmr >= duration){
				target[property] = value;
				end();
			} else {
				var nres:Number;
				var res:Number = ease(tmr, startvalue, difvalue, duration);
				var easeposition:Number = (res-startvalue)/(value-startvalue);
				if(bezier.length == 1) {
					nres = startvalue + (easeposition*(2*(1-easeposition)*(bezier[0]-startvalue)+(easeposition*difvalue)));
				} else {
					var b1:Number, b2:Number;
					var bpos:Number = int(easeposition*bezier.length);
					var ipos:Number = (easeposition-(bpos*(1/bezier.length)))*bezier.length;
					if (bpos == 0){
						b1 = startvalue;
						b2 = (bezier[0]+bezier[1])*.5;
					} else if (bpos == bezier.length-1){
						b1 = (bezier[bpos-1]+bezier[bpos])*.5;
						b2 = value;
					} else{
						b1 = (bezier[bpos-1]+bezier[bpos])*.5;
						b2 = (bezier[bpos]+bezier[bpos+1])*.5;
					}
					nres = b1+ipos*(2*(1-ipos)*(bezier[bpos]-b1) + ipos*(b2 - b1));
				}
				target[property] = nres;
				dispatchEvent(new TweenEvent(TweenEvent.UPDATED, {primitiveTween:this}));
			}
			
		}
	
	}

}
