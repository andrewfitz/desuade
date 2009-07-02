package com.desuade.partigen.controllers {

	public class EmitterTweenController extends MotionController {
	
		public function EmitterTweenController($target:Object, $property:String, $duration:Number, $containerclass:Class = null, $tweenclass:Class = null) {
			super($target, $property, $duration, KeyframeContainer, Partigen.tweenClass);
		}
	
	}

}

