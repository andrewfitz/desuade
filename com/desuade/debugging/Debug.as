package com.desuade.debugging {

	/**
	 *  The Debug class is used throughout all Desuade classes to provide information to developers. It allows for optional inclusion of codes to minimize file size.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class Debug extends Object {
		
		/**
		 *	@private
		 */
		private static var _codes:Object = {};
		
		/**
		 *	Only trace the code of the error, not the entire error description from the given CodeSet.
		 */
		public static var onlyCodes:Boolean = false;
		
		/**
		 *	This enables or disables any debug output. Trace output is disabled by default, setting this to true will enable all Debug.output calls.
		 */
		public static var enabled:Boolean = false;
		
		/**
		 *	This defines up to what level of debug codes should be shown. Generally, the higher the level, the more information and the more specific events are shown.
		 */
		public static var level:int = 90000;
		
		/**
		 *	This loads a given CodeSet into the Debugger. Used to save file size and provide modularity.
		 *	@param	codeset	 This is the CodeSet to load - ie: <code>new DebugCodesMotion()</code> or <code>new DebugCodesPartigen()</code>
		 *	@see	CodeSet
		 */
		public static function load($codeset:CodeSet):void {
			_codes[$codeset.setname] = $codeset.codes;
		}
		
		/**
		 *	This is method called when requesting to show information. This traces the given debug code from a specific CodeSet, or just the code number.
		 *	@param	codeset	 A string representing the name of the CodeSet used to get the code text.
		 *	@param	code	 The code number to use from a CodeSet.
		 *	@param	props	 An array of properties to be passed into the code. These are respresented in the same order of "$" used in the CodeSet.
		 *	@see	CodeSet
		 */
		public static function output($codeset:String, $code:Number, $props:Array = null):void {
			
			if (enabled) {
				if($code < level) {
					if(_codes[$codeset] != undefined) {
						if(onlyCodes) trace("Debug: " + $codeset + " #" + $code);
						else trace(r(_codes[$codeset][$code], $props || []));
					} else trace("Debug: " + $codeset + "(missing) #" + $code);
				}
			}
		}
		
		/**
		 *	@private
		 */
		private static function r($str:String, $arr:Array):String {
			var ns:String = $str;
			for (var i:int = 0; i < $arr.length; i++) {
				ns = ns.replace("$", $arr[i]);
			}
			return ns;
		}
	}
}
