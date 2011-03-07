/**
 * Strings
 */
package org.paazio.utils
{
	import flash.utils.ByteArray;

	/**
	 * "Strings" provides many static tools for working with text.
	 */
	public class Strings
	{
		/**
		 * @see http://www.moock.org/blog/archives/000288.html
		 * @param	s
		 * @return
		 */
		public static function getNumBytesUTF8(s:String):Number
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(s);
			return byteArray.length;
		}

	}
}
