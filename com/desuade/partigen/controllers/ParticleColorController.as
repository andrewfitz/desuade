package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	
	/**
	 *  This controls the color of a particle over it's life.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  05.05.2009
	 */
	public class ParticleColorController extends Object {
		
		/**
		 *	This is a special PointsContainer for colors. This is what's used to store and manage points. To add, remove, and work with points, see the documentation on PointsContainers.
		 */
		public var points:ColorPointsContainer;
		
		/**
		 *	The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 */
		public var duration:Number;
		
		/**
		 *	<p>This creates a new ColorValueController for an emitter's particles.</p>
		 *	<p>Use this to create random colors for particles, change the colors over a particle's life, the start color, etc.</p>
		 *	
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 *	
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 */
		public function ParticleColorController($duration:Number) {
			super();
			duration = $duration;
			points = new ColorPointsContainer();
		}
	
	}

}
