package com.desuade.partigen.controllers {
	
	import com.desuade.debugging.*
	import com.desuade.motion.controllers.*
	import com.desuade.utils.*
	import com.desuade.partigen.emitters.*

	/**
	 *  This is a meta controller that's used to conveniently and directly control the emitter.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  06.05.2009
	 */
	public dynamic class EmitterController extends Object {
		
		/**
		 *	@private
		 */
		protected var _emitter:Emitter;
		
		/**
		 *	This creates a new EmitterController. This normally shouldn't be needed, as this is automatically created by default when an emitter is created.
		 *	
		 *	@param	emitter	 The emitter in which to control.
		 */
		public function EmitterController($emitter:Emitter) {
			super();
			_emitter = $emitter;
		}
		
		/**
		 *	<p>This sets a start value for an emitter's property, without creating a tween. Useful for setting a random start value without dealing with points.</p>
		 *	<p>Even though there is no tween, a ValueController is still created, and can easily be turned into a tween.</p>
		 *	
		 *	@param	property	 The proprty to assign the start value to.
		 *	@param	value	 The value the property will be when the emitter starts (or controllers get ran). This sets the 'begin point' value.
		 *	@param	spread	 If this is anything besides <code>'0'</code>, a random range of value will be created. This sets the 'begin point' spread.
		 *	@param	precision	 How many decimal points the random spread values have.
		 *	
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 */
		public function addStartValue($property:String, $value:*, $spread:* = '0', $precision:int = 2):void {
			var tp:ValueController = this[$property] = new ValueController(_emitter, $property, 0, $precision);
			tp.points.begin.value = $value;
			tp.points.begin.spread = $spread;
			tp.points.end.value = null;
			tp.points.end.spread = '0';
		}
		
		/**
		 *	<p>This creates a new ValueController for the emitter with a quick and easy syntax, rather than <code>emittercontroller.property = new ValueController()</code></p>
		 *	<p>See the docs on ValueController for more information.</p>
		 *	
		 *	@param	property	 The property of the emitter to tween.
		 *	@param	start	 The value the property will be when the emitter starts (or controllers get ran). This sets the 'begin point' value.
		 *	@param	startSpread	 If this is anything besides <code>'0'</code>, a random range of value will be created. This sets the 'begin point' spread.
		 *	@param	end	 The value of the property when the controller ends. This sets the 'end point' value.
		 *	@param	endSpread	 If this is anything besides <code>'0'</code>, a random range of value will be created. This sets the 'end point' spread.
		 *	@param	ease	 The ease used between start and end values. This sets the 'end point' ease.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds.
		 *	@param	precision	 How many decimal points the random spread values have.
		 *	
		 *	@see	com.desuade.motion.controllers.ValueController
		 *	@see	com.desuade.motion.controllers.PointsContainer
		 *	
		 */
		public function addBasicTween($property:String, $start:*, $startSpread:*, $end:*, $endSpread:*, $ease:* = null, $duration:Number = 0, $precision:int = 2):void {
			var tp:ValueController = this[$property] = new ValueController(_emitter, $property, $duration, $precision);
			tp.points.begin.value = $start;
			tp.points.end.value = $end;
			tp.points.begin.spread = $startSpread;
			tp.points.end.spread = $endSpread;
			if($ease != null) tp.points.end.ease = $ease;
		}
		
		/**
		 *	<p>This is a method to quickly create a PhysicsValueController, instead of <code>emittercontroller.property = new PhysicsValueController()</code></p>
		 *	<p>This uses physics instead of tweens to change an emitter's property, including those that aren't positional (x,y).</p>
		 *	<p>See the BasicPhysics documentation for more information on what each property does.</p>
		 *	
		 *	@param	property	 The property of the emitter to have it's value handled by physics.
		 *	@param	velocity	 The start velocity for the emitter's property. This is affected by all the other properties.
		 *	@param	acceleration	 The start acceleration for the property.
		 *	@param	friction	 The start friction for the property.
		 *	@param	angle	 The angle the BasicPhysics object will use to calculate initial velocity. Mostly used with position properties, such as x, y, z. This gets assigned by the emitter, so leave this null.
		 *	@param	flip	 The boolean flip (for cartesian reversal) for properties such as y.
		 *	@param	duration	 The duration of the entire sequence to last for in seconds. This affects length of the tweens of the internal ValueControllers, since the position is dependent on the the duration.
		 *	
		 *	@see com.desuade.motion.controllers.PhysicsValueController
		 *	@see com.desuade.motion.controllers.ValueController
		 *	@see com.desuade.motion.controllers.PointsContainer
		 *	@see com.desuade.motion.physics.BasicPhysics#velocity
		 *	@see com.desuade.motion.physics.BasicPhysics#acceleration
		 *	@see com.desuade.motion.physics.BasicPhysics#friction
		 *	@see com.desuade.motion.physics.BasicPhysics#angle
		 *	@see com.desuade.motion.physics.BasicPhysics#flip
		 */
		public function addBasicPhysics($property:String, $velocity:Number = 0, $acceleration:Number = 0, $friction:Number = 0, $angle:* = null, $flip:Boolean = false, $duration:Number = 0):void {
			this[$property] = new PhysicsValueController(_emitter, $property, $duration, $velocity, $acceleration, $friction, $angle, $flip);
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
