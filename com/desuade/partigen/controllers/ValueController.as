package com.desuade.partigen.controllers {
	
	import com.desuade.partigen.debug.*
	import com.desuade.partigen.proxies.*
	import com.desuade.partigen.utils.*

	public class ValueController extends Object {
	
		public var points:PointsContainer;
		public var target:Object;
		public var property:String;
		public var duration:Number;
		public var precision:Number = 2;
		private var _active:Boolean = false;
		public function get active():Boolean{
			return _active;
		}
	
		public function ValueController(target:Object, property:String, duration:Number){
			super();
			this.target = target;
			this.property = property;
			this.duration = duration;
			points = new PointsContainer(target[property]);
		}
		
		//public methods
		
		public function addPoint(value:Number, spread:Number, position:Number, ease:* = 'linear', label:String = 'point'):Object {
			return points.addPoint(value, spread, position, ease, label);
		}
		
		public function removePoint(label:String):void {
			points.removePoint(label);
		}
		
		public function start():void {
			var ta:Array = createTweens();
			//target[property] = points.beginning.value;
			TweenProxy.sequence(ta);
			_active = true;
		}
		
		public function stop():void {
			_active = false;
		}
		
		public function getPoints():Array {
			return points.getSortedPoints();
		}
		
		//private methods
		
		private function calculateDuration(previous:Number, position:Number):Number {
			return duration*(position-previous);
		}

		private function createTweens():Array {
			var pa:Array = points.getSortedPoints();
			var ta:Array = [];
			//skip beginning point (i=1), it gets set and doesn't need to be tweened to initial value
			for (var i:int = 1; i < pa.length; i++) {
				var tmo:Object = {target:target, ease:points[pa[i]].ease, duration:calculateDuration(points[pa[i-1]].position, points[pa[i]].position), delay:0};
				tmo[property] = (points[pa[i]].spread != 0) ? Random.fromRange(points[pa[i]].value, (points[pa[i]].value+points[pa[i]].spread), precision) : points[pa[i]].value;
				
				trace(tmo[property]);
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}

