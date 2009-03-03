package com.desuade.motion {

	import com.desuade.debugging.*

	public class DebugCodesMotion extends CodeSet {
		
		public function DebugCodesMotion() {
			super();
			
			setname = 'motion';
			codes = {
				10000: "Motion debug codes for aiding in development.",
				10001: "[PointsContainer] point $ added at position $",
				10002: "[ValueController] controlled tween for $.$ ended",
				10003: "[TweenProxy] loaded engine: $ v$",
				
				//low level codes
				40001: "[PrimitiveTween] tween ended: $",
				40002: "[BasicTween] new tween delayed for $ seconds",
				40003: "[BasicSequence] new sequence",
				40004: "[BasicSequence] sequence now playing at position $",
				40005: "[BasicSequence] sequence ended",
				40006: "[BasicSequence] simulating new position at $"
			}
			
		}
	
	}

}
