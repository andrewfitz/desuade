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
				
				// low level codes
				40001: "[Tween] new tween",
				40002: "[Tween] new tween delayed for $ seconds",
				40003: "[Sequence] new sequence",
				40004: "[Sequence] sequence now playing at position $",
				40005: "[Sequence] sequence ended",
				40006: "[Sequence] simulating new position at $",
				
				//primitive low level codes
				50001: "[PrimitiveTween] tween started: $",
				50002: "[PrimitiveTween] tween ended: $",
				50003: "[Tween] rounding tween $: $ -> $"
				
			}
			
		}
	
	}

}
