/**
 * Flash Player version.
 */
package org.paazio.utils
{
	import flash.system.Capabilities;

	/**
	 * @version 1.0.0
	 */
	public class FlashVersion
	{
		public static var version:String = "0.0.0";
		public static var major:int = 0;
		public static var minor:int = 0;
		public static var patch:int = 0;
		public static var debug:Boolean = false;
		
		public static function init():void
		{
			var ver:Array = Capabilities.version.split(" ");
			ver = ver[ver.length - 1].split(",");
			major = parseInt(ver[0]);
			minor = parseInt(ver[1]);
			patch = parseInt(ver[2]);
			debug = Capabilities.isDebugger;
			version = major + "." + minor + "." + patch;
			
		}

		/**
		 * this == version
		 * @param	version
		 * @return
		 */
		public static function equals(version:String):Boolean
		{
			var ver:Array = version.split(".");
			if (ver.length >= 3 && major == parseInt(ver[0]) && minor == parseInt(ver[1]) && patch == parseInt(ver[2]))
			{
				return true;
			}
			return false;
		}
		
		/**
		 * this < version
		 * @param	version
		 * @return
		 */
		public static function smaller(version:String):Boolean
		{
			var ver:Array = version.split(".");
			var maj:int = parseInt(ver[0]);
			var min:int = parseInt(ver[1]);
			var pat:int = parseInt(ver[2]);
			if (ver.length >= 3 
				&& (major > maj || (major == maj && minor > min))
				&& (minor > min || (minor == min && patch > pat)))
			{
				return true;
			}
			return false;
		}
		
		/**
		 * this > version
		 * @param	version
		 * @return
		 */
		public static function bigger(version:String):Boolean
		{
			var ver:Array = version.split(".");
			var maj:int = parseInt(ver[0]);
			var min:int = parseInt(ver[1]);
			var pat:int = parseInt(ver[2]);
			if (ver.length >= 3 
				&& (major < maj || (major == maj && minor < min))
				&& (minor < min || (minor == min && patch < pat)))
			{
				return true;
			}
			return false;
		}
	}
}
