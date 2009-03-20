package com.desuade.motion.tween {
	
	import flash.display.*; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	public class PrimitiveBezierTween extends PrimitiveTween {
	
		public static var _count:int = PrimitiveTween._count;
		internal static var _sprite:Sprite = PrimitiveTween._sprite;
		
		public var bezierArray:Array;
	
		public function PrimitiveBezierTween($target:Object, $prop:String, $value:Number, $duration:int, $bezier:Array, $ease:Function = null) {
			bezierArray = $bezier;
			super($target, $prop, $value, $duration, $ease);
		}
		
		protected override function update(u:Object):void {
			var tmr:int = getTimer() - starttime;
			var nres:Number;
			var res:Number = ease(tmr, startvalue, difvalue, duration);
			var easeposition:Number = (res-startvalue)/(value-startvalue);
			if(bezierArray.length == 1) {
				nres = startvalue + (easeposition*(2*(1-easeposition)*(bezierArray[0]-startvalue)+(easeposition*difvalue)));
			} else {
				var b1:Number, b2:Number;
				var bpos:Number = int(easeposition*bezierArray.length);
				var ipos:Number = (easeposition-(bpos*(1/bezierArray.length)))*bezierArray.length;
				if (bpos == 0){
					b1 = startvalue;
					b2 = (bezierArray[0]+bezierArray[1])*.5;
				} else if (bpos == bezierArray.length-1){
					b1 = (bezierArray[bpos-1]+bezierArray[bpos])*.5;
					b2 = value;
				} else{
					b1 = (bezierArray[bpos-1]+bezierArray[bpos])*.5;
					b2 = (bezierArray[bpos]+bezierArray[bpos+1])*.5;
				}
				nres = b1+ipos*(2*(1-ipos)*(bezierArray[bpos]-b1) + ipos*(b2 - b1));
			}
			target[prop] = nres;
			dispatchEvent(new TweenEvent(TweenEvent.UPDATE, {primitiveTween:this}));
			if(tmr >= duration){
				target[prop] = value;
				end();
			}
			
		}
	
	}

}

