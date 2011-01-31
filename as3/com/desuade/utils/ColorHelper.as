/*
This software is distributed under the MIT License.

Copyright (c) 2009-2011 Desuade (http://desuade.com/)

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

	/**
	 *  This is a static class that provides methods to help with tweening and working with colors.
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Andrew Fitzgerald
	 *  @since  18.04.2009
	 */
	public class ColorHelper {
		
		/**
		 *	Converts a String-based hex value into a decimal
		 *	@param	hex	 A string-hex value - ie: "FF00AA"
		 *	@return		A decimal equivalent as an int - ie: 104901
		 *	@see	#decToHexString()
		 */
		public static function hexStringToDec($hex:String):int {
			return parseInt($hex, 16);
		}
		
		/**
		 *	Converts a decimal to a String-based hex
		 *	@param	dec	 A decimal to convert - ie: 104901
		 *	@return		A string version of the hex value - ie: "FF00AA"
		 *	@see	#hexStringToDec()
		 */
		public static function decToHexString($dec:int):String {
			return Number($dec).toString(16);
		}
		
		/**
		 *	Creates an rgb object from a hex value
		 *	@param	color	 A color such as 0xff0044 or "#FF00FF"
		 *	@return		An object containg r,g,b - ie: {r:0, g:0, b:0}
		 *	@see	#RGBToHex()
		 */
		public static function hexToRGB($color:*):Object {
			var cc:uint = cleanColorValue($color);
			var ob:Object = {r:0, g:0, b:0};
			ob.r = (cc >> 16);;
			ob.g = ((cc >> 8) & 0xFF);
			ob.b = (cc & 0xFF);
			return ob;
		}
		
		/**
		 *	Takes a red, blue, and green and converts into a uint hex value
		 *	@param	r	 Red value 0-255
		 *	@param	g	 Green value 0-255
		 *	@param	b	 Blue value 0-255
		 *	@return		A uint hex value
		 *	@see	#hexToRGB()
		 */
		public static function RGBToHex(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}
		
		/**
		 *	Takes any kind of color representation and makes it into a clean uint.
		 *	@param	rgb	 Any kind of color value - ie: "#FFFF00", "DDDDDD", 0xf7f7f7, 108475
		 *	@return		A uint that's a clean hex value
		 */
		public static function cleanColorValue($rgb:*):uint {
			if (typeof $rgb == 'string') {
				if ($rgb.charAt(0) == '#') $rgb = $rgb.slice(1);
				$rgb = (($rgb.charAt(1)).toLowerCase()!='x') ? ('0x'+$rgb) : ($rgb);
			}
			return uint($rgb);
		}
		
		/**
		 *	This returns an object used for color transformations. This is mostly used for ColorTweening.
		 *	
		 *	<p>There are a number of "types" to choose from:</p>
		 *	<code>brightness</code>: amt:-1=black, 0=normal, 1=white<br />
		 *	<code>brightOffset</code>: amt:-1=black, 0=normal, 1=white<br />
		 *	<code>contrast</code>: amt:0=gray, 1=normal, 2=high-contrast, higher=posterized<br />
		 *	<code>invert</code>: amt:0=normal, .5=gray, 1=photo-negative<br />
		 *	<code>tint</code>: amt:0=none, 1=solid color (&gt;1=posterized to tint, &lt;0=inverted posterize to tint)<br />
		 *	<code>clear</code>: clears and clears the object<br /><br />
		 *	
		 *	@param	type	 What type of color transformation to perform. See above for a list of available types.
		 *	@param	amount	 How much of the transformation to perform (0-1). This varies for each type.
		 *	@param	rgb	 A color value - ie: "#FF00AA"
		 *	@param	cco	 This is the base (current) transformation object to use. For example, the current ColorTransformation of a MovieClip.
		 *	@return		A color transformation object.
		 */
		public static function getColorObject(type:String, amount:Number = 1, rgb:* = null, cco:Object = null):Object {
			var cr:Number; var cg:Number; var cb:Number; var cr2:Number; var cg2:Number; var cb2:Number;
			if(cco != null){
				cr = cco.redOffset;
				cb = cco.blueOffset;
				cg = cco.greenOffset;
				cr2 = int(cr*.5);
				cb2 = int(cb*.5);
				cg2 = int(cg*.5);
			} else {
				cr = cb = cg = 255;
				cr2 = cb2 = cg2 = 128;
			}
			switch (type) {
				case 'brightness':
					var percent:Number = (1-Math.abs(amount));
					var offset:Number = ((amount > 0) ? (255*amount) : 0);
					return {redMultiplier:percent, redOffset:offset, greenMultiplier:percent, greenOffset:offset, blueMultiplier:percent, blueOffset:offset};
				break;
				case 'brightOffset':
					return {redMultiplier:1, redOffset:(cr*amount), greenMultiplier:1, greenOffset:(cg*amount), blueMultiplier:1, blueOffset:(cb*amount)};
				break;
				case 'contrast':
					return {redMultiplier:amount, redOffset:(cr2-(cr2*amount)), greenMultiplier:amount, greenOffset:(cg2-(cg2*amount)), blueMultiplier:amount, blueOffset:(cb2-(cb2*amount))};
				break;
				case 'invert':
					return {redMultiplier:(1-2*amount), redOffset:(amount*(cr)), greenMultiplier:(1-2*amount), greenOffset:(amount*(cg)), blueMultiplier:(1-2*amount), blueOffset:(amount*(cb))};
				break;
				case 'tint':
					var rgbnum:int = cleanColorValue(rgb);
					return {redMultiplier:(1-amount), redOffset:(rgbnum >> 16)*amount, greenMultiplier:(1-amount), greenOffset:((rgbnum >> 8) & 0xFF)*amount, blueMultiplier:(1-amount), blueOffset:(rgbnum & 0xFF)*amount};
				break;
				case 'clear':
					return {redOffset:0, redMultiplier:1, greenOffset:0, greenMultiplier:1, blueOffset:0, blueMultiplier:1};
				break;
			}
			return {};
		};
	
	}

}
