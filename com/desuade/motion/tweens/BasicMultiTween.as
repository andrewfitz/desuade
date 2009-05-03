package com.desuade.motion.tweens {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *  This creates a BasicTween, but accepts a parameters object that can contain many properties and values.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicMultiTween extends BasicTween {
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>target:Object – an object to have it's property tweened</li>
		 *	<li>properties:Object – an object of properties and values to tween. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{x:100}</code> or <code>{y:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is a linear ease.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicMultiTween = new BasicMultiTween({target:myobj, properties:{x:200, y:'50', alpha:0.5}, duration:2, ease:Bounce.easeIn})</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function BasicMultiTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		/**
		 *	@private
		 */
		protected override function createTween($to:Object):int {
			for (var p:String in $to.properties) {
				$to.properties[p] = (typeof $to.properties[p] == 'string') ? $to.target[p] + Number($to.properties[p]) : $to.properties[p];
			}
			var pt:PrimitiveMultiTween = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween($to.target, $to.properties, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
			return pt.id;
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():* {
			return new BasicMultiTween(_tweenconfig);
		}

	}

}
