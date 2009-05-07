package com.desuade.partigen.pools {
	
	import com.desuade.partigen.particles.*;
	import com.desuade.partigen.emitters.BasicEmitter;
	import com.desuade.debugging.*;

	/**
	 *  This offers basic object storage without any real 'pooling'.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class NullPool extends Pool {
	
		/**
		 *	Creates a NullPool to store particle objects. This can be used with multiple emitters.
		 */
		public function NullPool() {
			super();
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle($particleClass:Class, $groupClass:Class, $emitter:BasicEmitter):BasicParticle {
			super.addParticle($particleClass, $groupClass, $emitter);
			if($emitter.groupAmount > 1){
				return _particles[BasicParticle.count] = new $groupClass($particleClass, $emitter.groupAmount, $emitter.groupProximity);
			} else {
				return _particles[BasicParticle.count] = new $particleClass();
			}
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($id:int):void {
			delete _particles[$id];
			super.removeParticle($id);
		}
	
	}

}
