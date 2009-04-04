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
				
				// low level codes
				40001: "[Tween] new tween created",
				40002: "[Tween] tween delayed for $ seconds",
				40003: "[Sequence] new sequence created",
				40004: "[Sequence] sequence now playing at position $",
				40005: "[Sequence] sequence ended",
				40006: "[Sequence] simulating new position at $",
				40007: "[Tween] starting tween at position: $",
				40008: "[Sequence] sequence started",
				
				//primitive low level codes
				50001: "[PrimitiveTween] tween started: $",
				50002: "[PrimitiveTween] tween ended: $",
				50003: "[Tween] rounding tween $: $ -> $"
				
			}
			
		}
	
	}

}
