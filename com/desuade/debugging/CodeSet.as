package com.desuade.debugging {

	/**
	 *  CodeSet is a base class used by the Debug class to load all the debug codes and text.
	 *	
	 *	DebugCodesMotion and DebugCodesPartigen extend this class. See the source files for more information.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class CodeSet extends Object {
		
		/**
		 *	The name of the code set.
		 */
		public var setname:String;
		
		/**
		 *	The text for debug codes.
		 */
		public var codes:Object;
		
		/**
		 *	Constructor for a code set. This should only be called once.
		 */
		public function CodeSet() {
			super();
		}
	
	}

}

