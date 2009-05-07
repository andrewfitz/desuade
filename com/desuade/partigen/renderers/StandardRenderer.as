package com.desuade.partigen.renderers {
	
	import flash.display.*;
	
	import com.desuade.partigen.particles.BasicParticle;
	import com.desuade.debugging.*;
	
	/**
	 *  This uses the standard DisplayList to display particles.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class StandardRenderer extends Renderer {
		
		/**
		 *	A visible DisplayObject that will "hold" the particles on the screen.
		 */
		public var target:DisplayObjectContainer;
		
		/**
		 *	The visual order of a new particle to be created - either 'top' or 'bottom'.
		 */
		public var order:String;
		
		/**
		 *	Creates a new StandardRenderer. This will use a DisplayObject and the standard Flash way to show particles on screen. Particles will be created "inside" the object via <code>addChild()</code>.
		 *	
		 *	@param	target	 The target parent DisplayObject to create child particles in.
		 *	@param	order	 The visual order of a new particle to be created - either 'top' or 'bottom'.
		 */
		public function StandardRenderer($target:DisplayObjectContainer, $order:String = 'top') {
			super();
			order = $order;
			target = $target;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function addParticle($p:BasicParticle):void {
			switch (order) {
				case 'top' :
					target.addChild($p);
				break;
				case 'bottom' :
					target.addChildAt($p, 0);
				break;
			}
			super.addParticle($p);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function removeParticle($p:BasicParticle):void {
			super.removeParticle($p);
			target.removeChild($p);
		}
	
	}

}
