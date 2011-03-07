package org.paazio.utils {

	import flash.utils.ByteArray;
	
	/**
	 * Unpacks the data according to the compression format.
	 */
    public class Unpacker {
		/**
		 * unpack the given bytearray.
		 * @param ba ByteArray Compressed data.
		 * @return ByteArray Uncompressed data.
		 */
		public static function un(ba:ByteArray):ByteArray {
			var header:String = ba.readUTF();
			trace("Header: " + header);
			return new ByteArray();
		}
	}
}