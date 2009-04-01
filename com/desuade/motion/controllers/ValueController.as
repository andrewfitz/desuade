package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.proxies.*
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
		
		public function get active():Boolean{
			return _active;
		}
	
		public function ValueController($target:Object, $prop:String, $duration:Number, $precision:int = 0, $setvalue:Boolean = true){
			super();
			target = $target;
			prop = $prop;
			duration = $duration;
			precision = $precision;
			points = new PointsContainer(($setvalue) ? $target[$prop] : null);
		}
		
		//public methods
		
		public function start():void {
			var ta:Array = createTweens();
			var nv:Number = (typeof points.beginning.value == 'string') ? target[prop] + Number(points.beginning.value) : points.beginning.value;
			target[prop] = (points.beginning.spread != 0) ? Random.fromRange(nv, nv + points.beginning.spread, precision) : nv;
			_active = true;
			_sequence = TweenProxy.sequence(ta);
			dispatchEvent(new ControllerEvent(ControllerEvent.STARTED, {controller:this}));
			TweenProxy.sequenceEndFunc(_sequence, this.tweenEnd);
		}
		
		public function stop():void {
			TweenProxy.stopSequence(_sequence, prop, this.tweenEnd);
		}
		
		public function getPoints():Array {
			return points.getSortedPoints();
		}
		
		public function tweenEnd(... args):void {
			_active = false;
			dispatchEvent(new ControllerEvent(ControllerEvent.ENDED, {controller:this}));
			Debug.output('motion', 10002, [target.name, prop]);
		}
		//private methods
		
		protected function calculateDuration($previous:Number, $position:Number):Number {
			return duration*($position-$previous);
		}

		protected function createTweens():Array {
			var pa:Array = points.getSortedPoints();
			var ta:Array = [];
			//skip beginning point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				var nuv:Number = Number(points[pa[i]].value);
				var nv:* = (points[pa[i]].spread != 0) ? Random.fromRange(nuv, nuv + points[pa[i]].spread, precision) : nuv;
				nv = (typeof points[pa[i]].value == 'string') ? nv.toString() : nv;
				var tmo:Object = {target:target, prop:prop, value:nv, ease:points[pa[i]].ease, duration:calculateDuration(points[pa[i-1]].position, points[pa[i]].position), delay:0};
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}

