package com.desuade.motion.tweens {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.desuade.debugging.*
	import com.desuade.utils.*
	import com.desuade.motion.events.*
	
	/**
	 *  This is the same as the Tween class, except it can tween multiple properties at once, and offers no bezier.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  02.05.2009
	 */
	public class MultiTween extends Tween {
		
		/**
		 *	@private
		 */
		protected var _newvals:Array = [];
		
		/**
		 *	@private
		 */
		protected var _startvalues:Array = [];
		
		/**
		 *	@private
		 */
		protected var _difvalues:Array = [];
		
		/**
		 *	@private
		 */
		protected var _newproperties:Object = {};
		
		/**
		 *	<p>The constructor accepts an object that has all the paramaters needed to create a new tween.</p>
		 *	<p>Paramaters for the tween object:</p>
		 *	<ul>
		 *	<li>target:Object – an object to have it's property tweened</li>
		 *	<li>properties:Object – an object of properties and values to tween. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{x:100}</code> or <code>{y:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>delay:Number – how long in seconds to delay starting the tween</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	<li>round:Boolean – round the values on update (to an int)</li>
		 *	<li>relative:Boolean – this overrides the number/string check on the value to set the value relative to the current value</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:MultiTween = new MultiTween({target:myobj, properties:{x:40, y:200}, duration:2, ease:Bounce.easeIn, delay:2, position:0, round:false, relative:true})</code></p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	BasicMultiTween
		 *	
		 */
		public function MultiTween($tweenObject:Object) {
			super($tweenObject);
		}
		
		/**
		 *	<p>This is a static method that creates and starts a tween with a strict syntax.</p>
		 *	
		 *	@param	target	an object to have it's property tweened
		 *	@param	properties	an object of properties and values to tween. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{x:100}</code> or <code>{y:"200"}</code>
		 *	@param	duration	how long in seconds for the tween to last
		 *	@param	ease	the easing function to use. Default is Linear.none.
		 *	@param	delay	how long in seconds to delay starting the tween
		 *	@param	round	round the values on update (to an int)
		 *	@param	position	what position to start the tween at 0-1
		 *	
		 *	<p>example: MultiTween.tween(myobj, {x:200, y:'400'}, 2.5, null, 0, false, false, 0)</p>
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	
		 */
		public static function tween($target:Object, $properties:Object, $duration:Number, $ease:Function = null, $delay:Number = 0, $round:Boolean = false, $position:Number = 0):MultiTween {
			var st:MultiTween = new MultiTween({target:$target, properties:$properties, duration:$duration, ease:$ease, delay:$delay, round:$round, position:$position});
			st.start();
			return st;
		}
		
		/**
		 *	@private
		 */
		protected override function createTween($to:Object):int {
			if($to.func != undefined){
				$to.func.apply(null, $to.args);
				_completed = true;
				dispatchEvent(new TweenEvent(TweenEvent.ENDED, {tween:this}));
				return 0;
			} else {
				var pt:PrimitiveMultiTween;
				if(_newvals.length == 0){
					var t:Object = $to.properties;
					for (var p:String in t) {
						var ftv:Object = $to.target[p];
						var tp:* = t[p];
						var ntval:*;
						var newvaly:Number;
						if(tp is Random) ntval = tp.randomValue;
						else ntval = tp;
						if($to.relative === true) newvaly = ftv + Number(ntval);
						else if($to.relative === false) newvaly = Number(ntval);
						else newvaly = (typeof ntval == 'string') ? ftv + Number(ntval) : ntval;
						_newvals.push(newvaly);
						_newproperties[p] = newvaly;
					}
				}
				//no bezier tweens for multitweening
				pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween($to.target, _newproperties, $to.duration*1000, $to.ease);
				pt.addEventListener(TweenEvent.ENDED, endFunc, false, 0, true);
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(_newvals.length > 0) {
						pt.arrayObject.startvalues = _startvalues;
						pt.arrayObject.difvalues = _difvalues;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.addEventListener(TweenEvent.UPDATED, updateListener, false, 0, true);
				if($to.round) addEventListener(TweenEvent.UPDATED, roundTweenValue, false, 0, true);
				return pt.id;
			}
		}
		
		/**
		 *	@private
		 */
		protected override function endFunc($o:Object):void {
			if($o.info.primitiveTween.arrayObject.props[0] != undefined){
				if($o.info.primitiveTween.target[$o.info.primitiveTween.arrayObject.props[0]] == $o.info.primitiveTween.arrayObject.values[0]){
					_completed = true;
				}
			}
			super.endFunc($o);
		}
		
		/**
		 *	@inheritDoc
		 */
		public override function clone():* {
			return new MultiTween(_tweenconfig);
		}
		
		////new methods
		
		/**
		 *	@inheritDoc
		 */
		public override function reset():void {
			_pausepos = undefined;
			_newvals = [];
			_difvalues = [];
			_startvalues = [];
			_newproperties = {};
			_completed = false;
			_tweenconfig.position = 0;
		}
		
		/**
		 *	@private
		 */
		protected override function roundTweenValue($i:Object):void {
			var pt:Object = $i.info.primitiveTween;
			for (var p:String in pt.arrayObject.props) {
				pt.target[p] = int(pt.target[p]);
			}
			Debug.output('motion', 50003, [pt.id, pt.target[pt.property], int(pt.target[pt.property])]);
		}
		
		/**
		 *	@private
		 */
		protected override function setpauses():void {
			_pausepos = position;
			_startvalues = BasicTween._tweenholder[_tweenID].arrayObject.startvalues;
			_difvalues = BasicTween._tweenholder[_tweenID].arrayObject.difvalues;
		}
	
	}

}
