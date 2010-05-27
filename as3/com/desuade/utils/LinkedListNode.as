package com.desuade.utils {

	public class LinkedListNode {
		
		public var next:LinkedListNode;
		
		public var previous:LinkedListNode;
		
		public var data:*;
		
		public function LinkedListNode($data:*) {
			data = $data;
		}
		
		public function equals($node:LinkedListNode):Boolean {
			return (data == $node.data) ? true : false;
		}
	
	}

}

