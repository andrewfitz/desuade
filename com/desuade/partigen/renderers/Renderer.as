package com.desuade.partigen.renderers {
	
	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;
	
	/**
	 *  This controls how the particles are displayed (rendered). This is controlled internally.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class Renderer extends Object {
	
		/**
		 *	This creates a new Renderer. This base class should not be created, as it offers no direct functionality.
		 */
		public function Renderer() {
			super();
			Debug.output('partigen', 20002);
		}
		
		/**
		 *	This adds a particle to the display.
		 *	
		 *	@param	p	 The particle to add.
		 */
		public function addParticle($p:BasicParticle):void {
			Debug.output('partigen', 40002, [$p.id]);
		}
		
		/**
		 *	This removes a particle from the display.
		 *	
		 *	@param	p	 The particle to remove.
		 */
		public function removeParticle($p:BasicParticle):void {
			Debug.output('partigen', 40004, [$p.id]);
		}
	
	}

}
