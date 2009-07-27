/*
This software is distributed under the MIT License.

Copyright (c) 2009 Desuade (http://desuade.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.desuade.motion.tweens {
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.*;
	
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
		 *	<li>properties:Object – an object of properties and values to tween. Passing a Number will tween it to that absolute value, passing a String will use a relative value (target.property + value) - ie: <code>{x:100}</code> or <code>{y:"200"}</code></li>
		 *	<li>ease:Function – the easing function to use. Default is Linear.none.</li>
		 *	<li>duration:Number – how long in seconds for the tween to last</li>
		 *	<li>delay:Number – how long in seconds to delay starting the tween</li>
		 *	<li>position:Number – what position to start the tween at 0-1</li>
		 *	<li>round:Boolean – round the values on update (to an int)</li>
		 *	<li>relative:Boolean – this overrides the number/string check on the value to set the value relative to the current value</li>
		 *	</ul>
		 *	
		 *	<p>Example: <code>var mt:MultiTween = new MultiTween(myobj, {properties:{x:40, y:200}, duration:2, ease:Bounce.easeIn, delay:2, position:0, round:false, relative:true})</code></p>
		 *	
		 *	@param	target	 The target object to have it's property tweened
		 *	@param	tweenObject	 The config object that has all the values for the tween
		 *	
		 *	@see	PrimitiveTween#target
		 *	@see	PrimitiveTween#duration
		 *	@see	PrimitiveTween#ease
		 *	@see	BasicMultiTween
		 *	
		 */
		public function MultiTween($target:Object, $tweenObject:Object = null) {
			super($target, $tweenObject);
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
						var ftv:Object = target[p];
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
				pt = BasicTween._tweenholder[PrimitiveTween._count] = new PrimitiveMultiTween(target, _newproperties, $to.duration*1000, $to.ease);
				pt.endFunc = endFunc;
				if($to.position > 0) {
					pt.starttime -= ($to.position*$to.duration)*1000;
					if(_newvals.length > 0) {
						pt.arrayObject.startvalues = _startvalues;
						pt.arrayObject.difvalues = _difvalues;
					}
					Debug.output('motion', 40007, [$to.position]);
				}
				pt.updateFunc = updateListener;
				return pt.id;
			}
		}
		
		/**
		 *	@private
		 */
		protected override function endFunc($o:Object):void {
			if($o.arrayObject.props[0] != undefined){
				if($o.target[$o.arrayObject.props[0]] == $o.arrayObject.values[0]){
					_completed = true;
				}
			}
			super.endFunc($o);
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
		 *	@inheritDoc
		 */
		public override function toXML():XML {
			var txml:XML = super.toXML();
			delete txml.@properties;
			for (var r:String in _tweenconfig.properties) {
				txml.prependChild(<property />);
				txml.property[0].@name = r;
				txml.property[0].@value = (typeof _tweenconfig.properties[r] == 'string') ? "*" + _tweenconfig.properties[r] : _tweenconfig.properties[r];
			}
			return txml;
		}
		
		/**
		 *	@private
		 */
		protected override function roundTweenValue($i:Object):void {
			for (var p:String in $i.arrayObject.props) {
				$i.target[p] = int($i.target[p]);
			}
		}
		
		/**
		 *	@private
		 */
		protected override function setPauses():void {
			_pausepos = position;
			_startvalues = BasicTween._tweenholder[_tweenID].arrayObject.startvalues;
			_difvalues = BasicTween._tweenholder[_tweenID].arrayObject.difvalues;
		}
	
	}

}
