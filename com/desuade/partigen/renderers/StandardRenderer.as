package com.desuade.partigen.renderers {
	
	import flash.display.*;
	
	import com.desuade.partigen.particles.*;
	import com.desuade.debugging.*;
	
	public class StandardRenderer extends Renderer {
		
		public var target:DisplayObjectContainer;
	
		public function StandardRenderer($target:DisplayObjectContainer) {
			super();
			target = $target;
			Debug.output('partigen', 20002);
		}
		
		public override function addParticle($p:Particle):void {
			target.addChild($p);
			super.addParticle($p);
		}
	
	}

}
