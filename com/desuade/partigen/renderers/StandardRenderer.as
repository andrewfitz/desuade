package com.desuade.partigen.renderers {
	
	import flash.display.*;
	
	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;
	
	public class StandardRenderer extends Renderer {
		
		public var target:DisplayObjectContainer;
	
		public function StandardRenderer($target:DisplayObjectContainer) {
			super();
			target = $target;
		}
		
		public override function addParticle($p:Particle):void {
			target.addChild($p);
			super.addParticle($p);
		}
		
		public override function removeParticle($p:Particle):void {
			target.removeChild($p);
			super.removeParticle($p);
		}
	
	}

}
