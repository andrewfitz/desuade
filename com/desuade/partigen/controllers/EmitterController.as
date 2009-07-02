package com.desuade.partigen.controllers {

	public dynamic class EmitterController extends Object {
		
		/**
		 *	@private
		 */
		protected var _emitter:Emitter;
	
		public function EmitterController($emitter:Emitter) {
			super();
			_emitter = $emitter;
		}
		
		public function addTween($property:String, $duration:Number):void {
			this[$property] = new EmitterTweenController(_emitter, $property, $duration, KeyframeContainer, Partigen.tweenClass);
		}
		
		public function addPhysics($property:String, $duration:Number, $flip:Boolean = false):void {
			this[$property] = new EmitterPhysicsController(_emitter, $property, $duration, KeyframeContainer, Partigen.physicsClass);
			this[$property].physics.flip = $flip;
		}
		
		/**
		 *	This starts all the ValueControllers at once.
		 */
		public function startAll():void {
			for (var p:String in this) {
				this[p].start();
			}
		}
		
		/**
		 *	This stops all the ValueControllers at once.
		 */
		public function stopAll():void {
			for (var p:String in this) {
				this[p].stop();
			}
		}
	
	}

}

