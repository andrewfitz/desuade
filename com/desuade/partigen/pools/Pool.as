package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.debugging.*;

	/**
	 *  These hold and manage the actual particle objects in memory. This handles the creation of particle objects and is controlled internally.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class Pool extends Object {
		
		/**
		 *	@private
		 */
		protected var _particles:Object = {};
	
		/**
		 *	Creates a Pool to store particle objects. This base class should not be created, as it offers no direct functionality.
		 */
		public function Pool() {
			super();
			Debug.output('partigen', 20003);
		}
		
		/**
		 *	An object of all the current "living" particles, based on their unique id.
		 */
		public function get particles():Object{
			return _particles;
		}
		
		/**
		 *	Adds a new particle to the Pool.
		 *	
		 *	@param	particleClass	The class of the particle being created.
		 *	@param	groupClass	 This is the kind of particle grouping to use if the emitter's groupAmount > 1.
		 *	@param	emitter	 The parent emitter that is creating the particle.
		 *	
		 *	@return		The particle created.
		 */
		public function addParticle($particleClass:Class, $groupClass:Class, $emitter:BasicEmitter):BasicParticle {
			Debug.output('partigen', 40003);
			return null;
		}
		
		/**
		 *	Removes a particle from the Pool.
		 *	
		 *	@param	id	 The id of the particle to remove.
		 */
		public function removeParticle($id:int):void {
			Debug.output('partigen', 40005);
		}
	
	}

}
