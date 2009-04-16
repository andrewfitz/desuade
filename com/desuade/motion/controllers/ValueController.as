package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.sequencers.*
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
		public var tweenclass:Class = BasicTween;
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
			_sequence = new Sequence(tweenclass);
			_sequence.pushArray(ta);
			_sequence.addEventListener(SequenceEvent.ENDED, tweenEnd, false, 0, true);
			_sequence.addEventListener(SequenceEvent.ADVANCED, advance, false, 0, true);
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
			_sequence.removeEventListener(SequenceEvent.ENDED, tweenEnd);
			_sequence.removeEventListener(SequenceEvent.ADVANCED, advance);
			Debug.output('motion', 10002, [target, prop]);
		}
		
		public function setStartValue():Number {
			var nv:Number = (typeof points.begin.value == 'string') ? target[prop] + Number(points.begin.value) : points.begin.value;
			return target[prop] = (points.begin.spread !== '0') ? Random.fromRange(nv, ((typeof points.begin.spread == 'string') ? nv + Number(points.begin.spread) : points.begin.spread), precision) : nv;
		}
		
		public function isSingleTween():Boolean {
			return (points.length > 2) ? false : true;
		}
		
		public function set name(value:Object):void {
			_name = value;
		}
		
		//private methods
		
		protected function advance($o:Object):void {
			var pos:String = points.getOrderedLabels()[$o.info.sequence.position];
			dispatchEvent(new ControllerEvent(ControllerEvent.ADVANCED, {position:pos, controller:this}));
		}
		
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
				var nuv:Number;
				if(np.value == null){
					nuv = target[prop];
				} else {
					var nnnv:* = np.value;
					if(typeof nnnv == 'string'){
						var nfpv:Number = (ta.length == 0) ? target[prop] : ta[ta.length-1].value;
						nuv = nfpv + Number(nnnv);
					} else {
						nuv = nnnv;
					}
				}
				var nv:Number = (np.spread !== '0') ? Random.fromRange(nuv, ((typeof np.spread == 'string') ? nuv + Number(np.spread) : np.spread), precision) : nuv;
				var tmo:Object = {target:target, prop:prop, value:nv, ease:np.ease, duration:calculateDuration(points[pa[i-1]].position, np.position), delay:0};
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}
