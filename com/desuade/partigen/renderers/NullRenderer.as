package com.desuade.partigen.renderers {

	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;

	/**
	 *  This will not display any particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class NullRenderer extends Renderer {
	
		/**
		 *	Creates a new NullRenderer. Renderers can be reused and used for multiple emitters.
		 */
		public function NullRenderer() {
			super();
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle($p:BasicParticle):void {
			super.addParticle($p);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($p:BasicParticle):void {
			super.removeParticle($p);
		}
	
	}

}
