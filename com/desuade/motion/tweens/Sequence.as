package com.desuade.motion.tweens {
	
	import com.desuade.debugging.*
	import com.desuade.motion.events.*

	public dynamic class Sequence extends BasicSequence {
	
		public function Sequence(... args) {
			super();
			for (var i:int = 0; i < args.length; i++) {
				push(args[i]);
			}
		}
		
		protected override function play($position:int):void {
			Debug.output('motion', 40004, [$position]);
			_position = $position;
			_tween = new Tween(this[_position]);
			_tween.addEventListener(TweenEvent.ENDED, advance, false, 0, true);
			_tween.start();
		}
		
		public override function clone():* {
			var ns:Sequence = new Sequence();
			for (var i:int = 0; i < this.length; i++){
				ns.push(this[i]);
			}
			return ns;
		}
	
	}

}

