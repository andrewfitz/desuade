package com.desuade.motion.tweens {

	//Easing functions can be included with import fl.motion.easing.*
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *  A very basic tween that allows you to tween a given value on any object to a new value.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  01.05.2009
	 */
	public class BasicTween extends EventDispatcher {
		
		/**
		 *	@private
		 */
		protected static var _tweenholder:Object = {};
		
		/**
		 *	@private
		 */
		protected var _tweenconfig:Object;
		
		/**
		 *	@private
		 */
		protected var _tweenID:int = 0;
		
		/**
		 *	@private
		 */
		protected var _active:Boolean = false;
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>target:Object – an object to have it's property tweened</li>
		 *	<li>property:String – the property to tween</li>
		 *	<li>value:* – the new (end) value. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{value: 100}</code> or <code>{value:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:BasicTween = new BasicTween({target:myobj, property:'x', value:.5, duration:2, ease:Bounce.easeIn})</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#property
		 *	@see	PrimitiveTween#value
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public function BasicTween($tweenObject:Object) {
			super();
			_tweenconfig = $tweenObject;
			Debug.output('motion', 40001);
		}
		
		//args need to be in here for overriding - delay and position
		
		/**
		 *	This starts the tween. Delay and position are used for Tween and passing them here will do nothing.
		 *	
		 *	@return		True all the time since the tween can always start.
		 */
		public function start($delay:Number = -1, $position:Number = -1):Boolean {
			if(!_active){
				_active = true;
				dispatchEvent(new TweenEvent(TweenEvent.STARTED, {tween:this}));
				_tweenID = createTween(_tweenconfig);
			}
			return true;
		}
		
		/**
		 *	This stops the tween.
		 *	
		 *	@return		True if the tween could be stopped.
		 */
		public function stop():Boolean {
			if(_tweenID != 0) {
				_tweenholder[_tweenID].end();
				return true;
			} else return false;
		}
		
		/**
		 *	If the tween is currently active and running.
		 */
		public function get active():Boolean{
			return _active;
		}
		
		/**
		 *	Gets the tween config object that was passed in the constructor (target, value, ease, etc). The properties in this object can be modified.
		 */
		public function get config():Object{
			return _tweenconfig;
		}
		
		/**
		 *	This creates a new tween that is a duplicate clone of this.
		 *	
		 *	@return		A new copy of the current tween.
		 */
		public function clone():* {
			return new BasicTween(_tweenconfig);
		}
		
		/**
		 *	@private
		 */
		protected function createTween($to:Object):int {
	      var newval:Number = (typeof $to.value == 'string') ? $to.target[$to.property] + Number($to.value) : $to.value;
	      var pt:PrimitiveTween = _tweenholder[PrimitiveTween._count] = new PrimitiveTween($to.target, $to.property, newval, $to.duration*1000, $to.ease);
	      pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
	      return pt.id;
		}
		
		/**
		 *	@private
		 */
		protected function endFunc($o:Object):void {
			dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this, primitiveTween:_tweenholder[_tweenID]}));
			_active = false;
			_tweenholder[_tweenID].removeEventListener(TweenEvent.ENDED, endFunc);
			_tweenholder[_tweenID] = null;
			delete _tweenholder[_tweenID];
			_tweenID = 0;
		}

	}

}
