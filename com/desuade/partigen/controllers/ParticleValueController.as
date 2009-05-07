package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	
	/**
	 *  This is used to tween any of a particle's properties over it's life.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  04.05.2009
	 */
	public class ParticleValueController extends Object {
		
		/**
		 *	This is what's used to store and manage points. To add, remove, and work with points, see the documentation on PointsContainers.
		 *	@see com.desuade.motion.controllers.PointsContainer
		 */
		public var points:PointsContainer;
		
		/**
		 *	The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 */
		public var duration:Number;
		
		/**
		 *	How many decimal points the random spread values have.
		 */
		public var precision:int;
		
		/**
		 *	<p>This creates a new ParticleValueController for an emitter's ParticleController.</p>
		 *	<p>A ParticleValueController is a ValueController (from the Motion package) that controls a particle's property over it's life. Instead of just having a x_begin, x_end, alpha_begin, alpha_end, etc, controllers allow for unlimited tweens over the course of a particle's life, for any property. This gives incredible power and control to the developer, and each particle will only tween properties that are explicitly set, saving memory and increasing performance.</p>
		 *	<p>ValueControllers use a PointsContainer to manage all the 'points'. Think of the controller as a mini timeline, and each 'point' is a keyframe.</p>
		 *	<p>Each particle created from this emitter will have a ValueController that is copied from this attached to it, along with all other ParticleValueControllers created in the emtiter's ParticleController.</p>
		 *	<p>This is identical to a ValueController from the Motion package, except it's used as a template to create real ValueControllers on each particle themselves. See the Motion Package for more information.</p>
		 *	
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. If 0, the duration will be the particle's life (recommended).
		 *	@param	precision	 How many decimal points the random spread values have.
		 *	@param	value	 The value for the begin and end points.
		 *	
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 *	
		 */
		public function ParticleValueController($duration:Number, $precision:int, $value:* = null) {
			super();
			duration = $duration;
			precision = $precision;
			points = new PointsContainer($value);
		}
	
	}

}
