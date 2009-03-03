package com.desuade.motion.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.proxies.*
	import com.desuade.utils.*

	public class ValueController extends Object {
	
		public var points:PointsContainer;
		public var target:Object;
		public var prop:String;
		public var duration:Number;
		protected var _active:Boolean = false;
		public function get active():Boolean{
			return _active;
		}
	
		public function ValueController($target:Object, $prop:String, $duration:Number, $setvalue:Boolean = true){
			super();
			target = $target;
			prop = $prop;
			duration = $duration;
			points = new PointsContainer(($setvalue) ? $target[$prop] : null);
		}
		
		//public methods
		
		public function addPoint($value:*, $position:Number, $ease:* = null, $label:String = 'point'):Object {
			return points.addPoint($value, $position, $ease || PointsContainer.linear, $label);
		}
		
		public function removePoint($label:String):void {
			points.removePoint($label);
		}
		
		public function start():void {
			var ta:Array = createTweens();
			ta[ta.length-1].func = this.tweenEnd;
			target[prop] = points.beginning.value;
			TweenProxy.sequence(ta);
			_active = true;
		}
		
		public function stop():void {
			_active = false;
		}
		
		public function getPoints():Array {
			return points.getSortedPoints();
		}
		
		public function flattenTo($value:*):void {
			points.flatten($value);
		}
		
		public function tweenEnd(... args):void {
			_active = false;
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
				var tmo:Object = {target:target, prop:prop, value:(points[pa[i]].value is Random) ? points[pa[i]].value.randomValue : points[pa[i]].value, ease:points[pa[i]].ease, duration:calculateDuration(points[pa[i-1]].position, points[pa[i]].position), delay:0};
				ta.push(tmo);
			}
			return ta;
		}
	
	}

}

