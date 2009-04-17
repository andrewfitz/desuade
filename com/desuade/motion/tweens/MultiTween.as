package com.desuade.motion.tweens {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	public class MultiTween extends Tween {
		
		protected var _newvals:Array = [];
		protected var _startvalues:Array = [];
		protected var _difvalues:Array = [];
		protected var _newproperties:Object = {};
		
		public function MultiTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		//Static tween function
		public static function tween($target:Object, $properties:Object, $duration:int, $ease:Function = null, $delay:Number = 0, $position:Number = 0, $bezier:Array = null):MultiTween {
			var st:MultiTween = new MultiTween({target:$target, properties:$properties, duration:$duration, ease:$ease, delay:$delay, position:$position, bezier:$bezier});
			st.start();
			return st;
		}
		
		protected override function createTween($to:Object):int {
			var pt:PrimitiveMultiTween;
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				if(_newvals.length == 0){
					for (var p:String in $to.properties) {
						var ftv = $to.target[p];
						var t:Object = $to.properties;
						var tp:* = t[p];
						var ntval:*;
						var newvaly:Number;
						if(tp is Random){
							ntval = tp.randomValue;
						} else {
							ntval = tp;
						}
						if($to.relative === true){
							newvaly = ftv + Number(ntval);
						} else if($to.relative === false){
							newvaly = Number(ntval);
						} else {
							newvaly = (typeof ntval == 'string') ? ftv + Number(ntval) : ntval;
						}
						_newvals.push(newvaly);
						_newproperties[p] = newvaly;
					}
				}
				//no bezier tweens for multitweening
				pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween($to.target, _newproperties, $to.duration*1000, $to.ease);
				pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(_newvals.length > 0) {
						pt.arrayObject.startvalues = _startvalues;
						pt.arrayObject.difvalues = _difvalues;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATED, updateListener, false, 0, true);
				if($to.round) addEventListener(TweenEvent.UPDATED, roundTweenValue, false, 0, true);
				return pt.id;
			}
		}
		
		protected override function endFunc($o:Object):void {
			if($o.info.primitiveTween.target[$o.info.primitiveTween.arrayObject.props[0]] == $o.info.primitiveTween.arrayObject.values[0]){
				_completed = true;
			}
			super.endFunc($o);
		}
		
		public override function clone():* {
			return new MultiTween(_tweenconfig);
		}
		
		////new methods
		
		public override function reset():void {
			_pausepos = undefined;
			_newvals = [];
			_difvalues = [];
			_startvalues = [];
			_newproperties = {};
			_completed = false;
			_tweenconfig.position = 0;
		}
		
		protected override function roundTweenValue($i:Object):void {
			var pt:Object = $i.info.primitiveTween;
			for (var p:String in pt.arrayObject.props) {
				pt.target[p] = int(pt.target[p]);
			}
			Debug.output('motion', 50003, [pt.id, pt.target[pt.prop], int(pt.target[pt.prop])]);
		}
		
		protected override function setpauses():void {
			_pausepos = position;
			_startvalues = BasicTween._tweenholder[_tweenID].arrayObject.startvalues;
			_difvalues = BasicTween._tweenholder[_tweenID].arrayObject.difvalues;
		}
	
	}

}
