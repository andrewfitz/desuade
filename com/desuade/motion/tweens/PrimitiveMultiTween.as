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

	public class PrimitiveMultiTween extends PrimitiveTween {
		
		public static var _count:int = PrimitiveTween._count;
		internal static var _sprite:Sprite = PrimitiveTween._sprite;
		
		internal var arrayObject:Object;
		
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
		
		public function PrimitiveMultiTween($target:Object, $props:Object, $duration:int, $ease:Function = null) {
			super($target, null, 0, $duration, $ease);
			arrayObject = PrimitiveMultiTween.makeMultiArrays($target, $props);
		}
		
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
				dispatchEvent(new TweenEvent(TweenEvent.UPDATE, {primitiveTween:this}));
			}
		}
	
	}

}
