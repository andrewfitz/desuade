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

package com.desuade.partigen.pools {
	
	import flash.utils.Dictionary;
	
	import com.desuade.partigen.interfaces.*;
	import com.desuade.debugging.*;

	/**
	 *  These hold and manage the actual particle objects in memory. This handles the creation of particle objects and is controlled internally.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  07.05.2009
	 */
	public class Pool {
				
		/**
		 *	@private
		 */
		protected var _particles:Dictionary = new Dictionary(true);
		
		/**
		 *	@private
		 */
		protected var _particleClass:Class;
	
		/**
		 *	Creates a Pool to store particle objects. This base class should not be created, as it offers no direct functionality.
		 *	
		 *	@param	particleClass	 The class of particle the pool will create.
		 */
		public function Pool($particleClass:Class) {
			_particleClass = $particleClass;
			Debug.output('partigen', 20003);
		}
		
		/**
		 *	Gets the class of particle the pool creates.
		 */
		public function get particleClass():Class{
			return _particleClass;
		}
		
		/**
		 *	An object of all the current "living" particles, based on their unique id.
		 */
		public function get particles():Dictionary{
			return _particles;
		}
		
		/**
		 *	This sets the particleClass to the new class and deals with reseting the internal pool.
		 */
		public function setClass($particleClass:Class):void {
			_particleClass = $particleClass;
		}
		
		/**
		 *	Adds a new particle to the Pool.
		 *	
		 *	@return		The particle created.
		 */
		public function addParticle():IBasicParticle {
			Debug.output('partigen', 40003);
			return null;
		}
		
		/**
		 *	Removes a particle from the Pool.
		 *	
		 *	@param	particle	 The particle to remove.
		 */
		public function removeParticle($particle:*):void {
			Debug.output('partigen', 40005, [$particle.id]);
		}
		
		/**
		 *	This does nothing for Sweep and Null pools.
		 */
		public function purge():void {
			//nothing
		}
		
		/**
		 *	Returns the total amount of particles in the pool.
		 */
		public function get length():int {
			var l:int = 0;
			for (var t:* in particles) l++;
			return l; 
		}
	}

}
