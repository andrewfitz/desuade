package {

	import flash.display.*;
	
	public dynamic class CircleParticle extends Sprite {

		public function CircleParticle() {
			super();
			this.graphics.beginFill(0x999999);
			this.graphics.drawCircle(0,0,5);
		}

	}
}