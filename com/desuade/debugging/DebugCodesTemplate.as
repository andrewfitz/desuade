package com.desuade.debugging {

	import com.desuade.debugging.*
	
	/**
	 *  This is a template of what a CodeSet should be formated like. Use this as a base when creating new CodeSets.
	 *	Naming convention is DebugCodes(MyPackageNameHere).as
	 *	
	 *	@private
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class DebugCodesTemplate extends CodeSet {
		
		/**
		 *	@private
		 */
		public function DebugCodesTemplate() {
			super();
			
			setname = 'template';
			codes = {
				10000: "Template debug codes for aiding in development.",
				10001: "Test code for $ and $"
			}
			
		}
	
	}

}
