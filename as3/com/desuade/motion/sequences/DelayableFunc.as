package com.desuade.motion.sequences {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import com.desuade.debugging.*
	import com.desuade.motion.events.*
	
	/**
	 *  An object used to create delayed functions, mostly for Sequences.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  29.07.2009
	 */
	public class DelayableFunc extends EventDispatcher {
		
		/**
		 *	@private
		 */
		protected var _completed:Boolean = false;
		
		/**
		 *	@private
		 */
		protected var _delayTimer:Timer = null;
		
		/**
		 *	@private
		 */
		protected var _funcconfig:Object;
		
		/**
		 *	If the function returns a value, it is assigned here.
		 */
		public var returned:*;
		
		/**
		 *	<p>This creates a simple object that runs a function after an optionable delay.</p>
		 *	
		 *	<p>Paramaters for the funcObject:</p>
		 *	<ul>
		 *	<li>func:Function – the function to call (without "()")</li>
		 *	<li>args:Array – an array of arguments to pass to the function.</li>
		 *	<li>delay:Number – the amount of seconds to delay the function call</li>
		 *	</ul>
		 */
		public function DelayableFunc($funcObject:Object) {
			super();
			_funcconfig = $funcObject;
		}
		
		/**
		 *	Gets the config object that was passed in the constructor. The properties in this object can be modified.
		 */
		public function get config():Object{
			return _funcconfig;
		}
		
		/**
		 *	Returns true if the function completed.
		 */
		public function get completed():Boolean{
			return _completed;
		}
		
		/**
		 *	Runs the function with a delay (if provided).
		 *	
		 *	@return		The DelayableFunc (for chaining)
		 */
		public function start():DelayableFunc {
			dispatchEvent(new MotionEvent(MotionEvent.STARTED, {delableFunc:this}));
			returned = null;
			if(_funcconfig.delay != undefined && _funcconfig.delay > 0) {
				doDelay(_funcconfig.delay);
			} else {
				runFunc(_funcconfig);
			}
			return this;
		}
		
		/**
		 *	Stops the DelayableFunc only if it's waiting on a delay.
		 */
		public function stop():void {
			if(!_completed) end();
		}
		
		/**
		 *	@private
		 */
		protected function runFunc($to:Object):void {
			$to.func.apply(null, ($to.args || []));
			end();
		}
		
		/**
		 *	@private
		 */
		protected function end():void {
			if(_delayTimer != null){
				_delayTimer.removeEventListener(TimerEvent.TIMER, dtFunc);
				_delayTimer.stop();
				_delayTimer = null;
			}
			_completed = true;
			dispatchEvent(new MotionEvent(MotionEvent.ENDED, {delableFunc:this}));
		}
		
		/**
		 *	@private
		 */
		protected function doDelay($delay:Number):void {
			_delayTimer = new Timer($delay*1000);
			_delayTimer.addEventListener(TimerEvent.TIMER, dtFunc, false, 0, false);
			_delayTimer.start();
		}
		
		/**
		 *	@private
		 */
		protected function dtFunc($i:Object):void {
			returned = runFunc(_funcconfig);
		}
	
	}

}
