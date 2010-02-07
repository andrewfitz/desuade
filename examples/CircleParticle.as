package {

	import com.desuade.partigen.particles.*;

	public dynamic class CircleParticle extends Particle {

		public function CircleParticle() {
			super();
			this.graphics.beginFill(0x999999);
			this.graphics.drawCircle(0,0,5);
		}

	}
}