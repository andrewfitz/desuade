package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.tweens.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ValueController extends EventDispatcher {
	
		public var points:PointsContainer;
		public var target:Object;
		public var prop:String;
		public var duration:Number;
		public var precision:int;
		protected var _active:Boolean = false;
		protected var _sequence;
	
		public function ValueController($target:Object, $prop:String, $duration:Number, $precision:int = 0, $setvalue:Boolean = true){
			super();
			target = $target;
			prop = $prop;
			duration = $duration;
			precision = $precision;
			points = new PointsContainer(($setvalue) ? $target[$prop] : null);
		}
		
		public function get active():Boolean{
			return _active;
		}
		
		//public methods
		
		public function start():void {
			setStartValue();
			var ta:Array = createTweens();
			_active = true;
			_sequence = new BasicSequence();
			_sequence.pushArray(ta);
			_sequence.addEventListener(SequenceEvent.ENDED, this.tweenEnd);
			_sequence.start();
			dispatchEvent(new ControllerEvent(ControllerEvent.STARTED, {controller:this}));
		}
		
		public function stop():void {
			if(_active) _sequence.stop();
			else Debug.output('motion', 10003);
		}
		
		public function getPoints():Array {
			return points.getOrderedLabels();
		}
		
		public function tweenEnd(... args):void {
			_active = false;
			dispatchEvent(new ControllerEvent(ControllerEvent.ENDED, {controller:this}));
			Debug.output('motion', 10002, [target, prop]);
		}
		
		public function setStartValue():Number {
			var nv:Number = (typeof points.begin.value == 'string') ? target[prop] + Number(points.begin.value) : points.begin.value;
			return target[prop] = (points.begin.spread != 0) ? Random.fromRange(nv, nv + points.begin.spread, precision) : nv;
		}
		
		public function isSingleTween():Boolean {
			return (points.length > 2) ? false : true;
		}
		
		//private methods
		
		protected function calculateDuration($previous:Number, $position:Number):Number {
			return duration*($position-$previous);
		}

		protected function createTweens():Array {
			var pa:Array = points.getOrderedLabels();
			var ta:Array = [];
			//skip begin point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				//if null, sets it to starting value
				var np:Object = points[pa[i]];
				var nnnv:* = (np.value == null) ? target[prop] : np.value;
				var nuv:Number = Number(nnnv);
				var nv:* = (np.spread != 0) ? Random.fromRange(nuv, nuv + np.spread, precision) : nuv;
				nv = (typeof nnnv == 'string') ? nv.toString() : nv;
				var tmo:Object = {target:target, prop:prop, value:nv, ease:np.ease, duration:calculateDuration(points[pa[i-1]].position, np.position), delay:0};
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}
