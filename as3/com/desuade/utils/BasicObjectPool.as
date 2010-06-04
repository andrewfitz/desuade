package com.desuade.utils {

	public class BasicObjectPool {
		
		public var size:int = 0;
		public var startSize:int;
		public var length:int = 0;
		public var objectClass:Class;
		public var clean:Function;
		
		protected var _list:Array = [];

		public function BasicObjectPool($objectClass:Class, $clean:Function = null, $startSize:int = 50) {
			objectClass = $objectClass;
			clean = $clean;
			startSize = $startSize;
			for(var i:int = 0;i < startSize; i++) make();
		}
	
		public function make():void {
			_list[length++] = new objectClass();
			size++;
		}

		public function checkOut():* {
			if(length == 0) {
				size++;
				return new objectClass();
			}
			return _list[--length];
		}

		public function checkIn($item:*):void {
			if(clean != null) {
				clean($item);
				if($item.isclean != undefined) $item.isclean = true;
			} else {
				if($item.isclean != undefined) $item.isclean = false;
			}
			_list[length++] = $item;
		}

		public function dispose():void {
			objectClass = null;
			clean = null;
			_list = null;
		}
	}
}