package org.paazio {

	/**
	 * Holds the data for each item in a subtitle.
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.1.0
	 */
	public class SubtitleItem {
		public var text:String = "";
		public var a:Number = 0;
		public var b:Number = 0;
		public var x:Number = 0;
		public var y:Number = 0;

		public function SubtitleItem(text:String, startTime:Number, endTime:Number, xPos:Number = 0, yPos:Number = 0) {
			this.text = text;
			this.a = startTime;
			this.b = endTime;
			this.x = xPos;
			this.y = yPos;
		}

		/**
		 * Check for existense of an item for a given time.
		 * @param	time	Given time of the playhead for which to check the existense of an item
		 * @return	True or False depending if a match is found.
		 */
		public function check(time:Number):Boolean {
			if (time >= a && time <= b) {
				return true;
			}
			return false;
		}

		/**
		 * Simply returns a string including all properties of the current SubtitleItem.
		 */
		public function toString():String {
			return "SubtitleItem {a: " + a.toFixed(2) + ", b: " + b.toFixed(2) + ", text: " + text + ", x: " + x.toString() + ", y: " + y.toString() + "}";
		}
	}
}