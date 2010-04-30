package com.desuade.partigen.interfaces {
	
	import com.desuade.partigen.interfaces.*;

	/**
	 *  Provides basic interface for Particle classes.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.04.2010
	 */
	public interface IParticle extends IBasicParticle {
		function startControllers($startTime:Number = 0):void;
		function stopControllers():void;
	}

}