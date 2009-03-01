package com.desuade.partigen.controllers {
	
	import com.desuade.partigen.debug.*

	public class ValueController extends Object {
	
		public var points:PointsContainer;
		public var target:Object;
		public var property:String;
		public var duration:Number;
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

		private function createTweens():void {
			
		}
	
	}

}

