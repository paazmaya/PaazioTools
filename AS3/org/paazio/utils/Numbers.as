/**
 * Numbers
 */
package org.paazio.utils
{
	
	/**
	 * "Numbers" provides many static tools for working with numbers.
	 */
	public class Numbers
	{
		public static function deg2rad(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		public static function rad2deg(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Gives the combined value of the given components. White by default.
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @return
		 */
		public static function rgb(red:uint = 0xFF, green:uint = 0xFF, blue:uint = 0xFF):uint
		{
			return red << 16 | green << 8 | blue;
		}
	

/*
http://lab.polygonal.de/2007/05/10/bitwise-gems-fast-integer-math/

Extracting color components

Not really a trick, but the regular way of extracting values using bit masking and shifting.

//24bit
var color:uint = 0x336699;
var r:uint = color >> 16;
var g:uint = color >> 8 & 0xFF;
var b:uint = color & 0xFF;

//32bit
var color:uint = 0xff336699;
var a:uint = color >>> 24;
var r:uint = color >>> 16 & 0xFF;
var g:uint = color >>>  8 & 0xFF;
var b:uint = color & 0xFF;

*/
		/**
		 * Gives the combined value of the given components including alpha. White by default.
		 * @param	red
		 * @param	green
		 * @param	blue
		 * @param	alpha
		 * @return
		 */
		public static function argb(red:uint = 0xFF, green:uint = 0xFF, blue:uint = 0xFF, alpha:uint = 0xFF):uint
		{
			return alpha << 24 | red << 16 | green << 8 | blue;
		}
		
		/**
		 * Adds the alpha channel to color code.
		 * @see http://www.zedia.net/2008/converting-a-rgb-color-and-alpha-to-argb-in-actionscript-3/
		 * @param	rgb
		 * @param	alpha
		 * @return
		 */
		public static function rgb2argb(rgb:uint, alpha:uint = 255):uint
		{
			var argb:uint = 0;
			argb += (alpha << 24);
			argb += (rgb);
			return argb;
		}
		
		/**
		 * Removes alpha channel
		 * @see http://paazio.nanbudo.fi
		 * @param	rgb
		 * @param	alpha
		 * @return
		 */
		public static function argb2rgb(argb:uint):uint
		{
			var alpha:Number = argb >> 24 & 0xFF;
			return (red(argb) | green(argb) | blue(argb));
		}
		
		/**
		 * Get the Alpha value for a given ARGB color.
		 * @param	rgb
		 * @return
		 */
		public static function alpha(argb:uint):uint
		{
			return argb >> 24 & 0xFF;
		}
		
		/**
		 * Get the Red value for a given (A)RGB color.
		 * @param	rgb
		 * @return
		 */
		public static function red(rgb:uint):uint
		{
			return rgb >> 16 & 0xFF;
		}
		
		/**
		 * Get the Green value for a given (A)RGB color.
		 * @param	rgb
		 * @return
		 */
		public static function green(rgb:uint):uint
		{
			return rgb >> 8 & 0xFF;
		}
		
		/**
		 * Get the Blue value for a given (A)RGB color.
		 * @param	rgb
		 * @return
		 */
		public static function blue(rgb:uint):uint
		{
			return rgb & 0xFF;
		}
		
		/**
		 * @see http://lab.polygonal.de/2007/05/10/bitwise-gems-fast-integer-math/
		 * @param	value
		 * @return
		 */
		public static function abs(value:Number):Number
		{
			return (value ^ (value >> 31)) - (value >> 31);
		}
		
		/**
		 * Random number from between the given range.
		 * @param	min
		 * @param	max
		 * @return
		 */
		public static function random(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
		
	}
}
