package com.desuade.motion.tweens {
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *  This creates a basic tween that changes a display object's color.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicColorTween extends BasicTween {
		
		/**
		 *	@private
		 */
		protected var _colorholder:Object;
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>target:Object – an object to have it's property tweened</li>
		 *	<li>type:String – the type of color transformation to apply. Defaults to 'tint', see ColorHelper for more types.</li>
		 *	<li>amount:int – The amount of transform to apply. Depends on 'type'</li>
		 *	<li>value:* – the new (end) color. A string or hex is accepted - ie: <code>{value: '#ff0038}</code> or <code>{value:0xff883a}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicColorTween = new BasicColorTween({target:myobj, value:0xff77d5, amount:0.8, duration:2})</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	com.desuade.utils.ColorHelper#getColorObject()
		 *	
		 */
		public function BasicColorTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():* {
			return new BasicColorTween(_tweenconfig);
		}
		
		/**
		 *	@private
		 */
		protected override function createTween($to:Object):int {
			_colorholder = $to.target.transform.colorTransform;
			var cpo:Object = ColorHelper.getColorObject($to.type || 'tint', $to.amount || 1, $to.value, _colorholder);
			var pt:PrimitiveMultiTween = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween(_colorholder, cpo, $to.duration*1000, $to.ease);
			pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
			pt.addEventListener(TweenEvent.UPDATED, colorupdater, false, 0, true);
			return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected function colorupdater($o:Object):void {
			_tweenconfig.target.transform.colorTransform = new ColorTransform(_colorholder.redMultiplier, _colorholder.greenMultiplier, _colorholder.blueMultiplier, _tweenconfig.target.alpha, _colorholder.redOffset, _colorholder.greenOffset, _colorholder.blueOffset);
		};
	
	}

}
