package com.desuade.motion.controllers {

	public dynamic class MetaController extends Object {
		
		protected var _target:Object;
		protected var _properties:Array;
		protected var _duration:Object;
	
		public function MetaController($target:Object, $properties:Array, $duration:Number, $containerclass:Class = null) {
			super();
			_target = $target;
			_properties = $properties;
			_duration = $duration;
			for (var i:int = 0; i < $properties.length; i++) {
				this[$properties[i]] = new MotionController($target, $properties[i], $duration, $containerclass);
			}
		}
		
		public function get target():Object{
			return _target;
		}
		public function set target($value:Object):void {
			_target = $value;
		}
		
		public function get properties():Array{
			return _properties;
		}
		
		public function get duration():Number{
			return _duration;
		}
		public function set duration($value:Number):void {
			_duration = $value;
		}
		
		public function get active():Boolean{
			for (var p:String in this) {
				if(this[p].active) return true
			}
			return false;
		}
		
		public function addController($property:String, $containerclass:Class = null):void {
			_properties.push($property);
			this[$property] = new MotionController(_target, $property, _duration, $containerclass);
		}
		
		public function addKeyframes($position:Number, $keyframes:Object):void {
			for (var i:int = 0; i < _properties.length; i++) {
				var found:Boolean = false;
				for (var p:String in $keyframes) {
					var kp:Object = $keyframes[p];
					if(p == _properties[i]){
						this[p].keyframes.add(new Keyframe($position, kp.value, kp.ease, kp.spread, kp.extras));
						delete $keyframes[p];
						found = true;
						continue;
					}
				}
				if(!found){
					_properties[i].keyframes.add(new Keyframe($position, null));
				}
			}
		}
		
		public function start():void {
			for (var p:String in this){
				this[p].start();
			}
		}
		
		public function stop():void {
			for (var p:String in this){
				this[p].stop();
			}
		}
	
	}

}

