package com.desuade.motion {

	import com.desuade.debugging.*
	
	/**
	 *  This is the CodeSet for the Motion Package.
	 *	
	 *	@private
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class DebugCodesMotion extends CodeSet {
		
		public function DebugCodesMotion() {
			super();
			
			setname = 'motion';
			codes = {
				10000: "Motion debug codes for aiding in development.",
				10001: "[PointsContainer] point $ added at position $",
				10002: "[ValueController] controlled tween for $.$ ended",
				10003: "[ValueController] can not stop, controller not active",
				10004: "[Tween] can not stop, tween has completed",
				10005: "[Tween] can not start, tween has completed",
				10006: "[Sequence] can not start, sequence is already active or has no items",
				10007: "[Sequence] can not stop, sequence is not active",
				
				// low level codes
				40001: "[Tween] new tween created",
				40002: "[Tween] tween delayed for $ seconds",
				40003: "[Sequence] new sequence created",
				40004: "[Sequence] sequence now playing at position $",
				40005: "[Sequence] sequence ended",
				40006: "[Sequence] simulating new position at $", //removed
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
