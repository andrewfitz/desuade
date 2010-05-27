/*
This software is distributed under the MIT License.

Copyright (c) 2009-2010 Desuade (http://desuade.com/)

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

package com.desuade.utils {

	public class LinkedList {
		
		protected var _head:LinkedListNode = null;
		protected var _tail:LinkedListNode = null;
		
		public function get head():LinkedListNode{
			return _head;
		}
	
		public function LinkedList() {
			//
		}
		
		public function add($node:LinkedListNode):void {
			if(_head != null) {
				_tail.next = $node;
				$node.previous = _tail;
			} else {
				_head = $node;
				$node.previous = null;
			}
			$node.next = null;
			_tail = $node;
		}
		
		public function remove($node:LinkedListNode):void {
			if($node == _head){
				_head = $node.next;
			} else if($node == _tail){
				_tail.previous.next = null;
				_tail = _tail.previous;
			} else {
				$node.previous.next = $node.next;
				$node.next.previous = $node.previous;
			}
			$node = null;
		}
	
	}

}
