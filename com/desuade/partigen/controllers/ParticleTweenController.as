package com.desuade.partigen.controllers {

	public class ParticleTweenController extends Object {
		
		public var duration:Number;
		
		public var keyframes:KeyframeContainer;
	
		public function ParticleTweenController($duration:Number, $containerclass:Class = null, $tweenclass:Class = null) {
			super();
			duration = $duration;
			var containerclass:Class = ($containerclass == null) ? KeyframeContainer : $containerclass;
			keyframes = new containerclass($tweenclass || Partigen.tweenClass);
		}
		
		public function setSingleTween($start:*, $startSpread:*, $end:*, $endSpread:*, $ease:* = null):void {
			keyframes.begin.value = $start;
			keyframes.begin.spread = $startSpread;
			keyframes.end.value = $end;
			keyframes.end.spread = $endSpread;
			keyframes.end.ease = $ease;
		}
	
	}

}
