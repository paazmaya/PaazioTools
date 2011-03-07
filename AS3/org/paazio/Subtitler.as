package org.paazio {
	import flash.text.TextField;
	import org.paazio.SubtitleItem;

	/**
	 * Parses and displays the SRT subtitles for given TextField reference.
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.1.0
	 */
	public class Subtitler {

		/**
		 * Reference to the TextField which is used to show the subtitle text.
		 */
		private var field:TextField;

		/**
		 * Each of the subtitles stored as a SubtitleItem.
		 */
		private var data:Array = [];

		/**
		 * When playhead has not been seeked but the play has continued naturally,
		 * this variable stores the last found index of the data array which matched the playhead time.
		 * After seek, this is set to -1 so all items are iterated.
		 */
		private var current:int = -1;
		
		/**
		 * Save the previous checking time.
		 */
		private var previousSec:Number = 0;

		/**
		 * Usage: <code>var sr:Subtitler = new Subtitler(srt, field);</code>
		 * @param	srtText		SRT text to be used
		 * @param	textField	The field where the text is shown in the htmlText value.
		 */
		public function Subtitler(srtText:String, textField:TextField) {
			this.field = textField;

			parseSRT(srtText);
		}

		/**
		 * <p>Parses the given SRT string to an array which holds each subtitle item as SubtitleItem.</p>
		 * <p>The format has no header, and no footer. Each subtitle has four parts:<br />
		 * Line 1 is a sequential count of subtitles, starting with 1.<br />
		 * Line 2 is the start timecode, followed by the string " --> ", followed by the end timecode.
		 * Timecodes are in the format HH:MM:SS,MIL (hours, minutes, seconds, milliseconds).
		 * The end timecode can optionally be followed by display coordinates (example " X1:100 X2:600 Y1:050 Y2:100").
		 * Without coordinates displayed, each line of the subtitle will be centered and the block will appear at the bottom of the screen.<br />
		 * Lines 3 onward are the text of the subtitle. New lines are indicated by new lines (i.e. there's no "\n" code). The only formatting accepted are the following:<br />
		 * &lt;b&gt;text&lt;/b&gt;: put text in boldface<br />
		 * &lt;i&gt;text&lt;/i&gt;: put text in italics<br />
		 * &lt;u&gt;text&lt;/u&gt;: underline text<br />
		 * &lt;font color="#00FF00"&gt;text&lt;/font&gt;: apply green color formatting to the text (you can use the font tag only to change color)<br />
		 * Tags can be combined (and should be nested properly). Note that the SubRip code appears to prefer whole-line formatting (no underlining just one word in the middle of a line).<br />
		 * Finally, successive subtitles are separated from each other by blank lines.</p>
		 * <p>Here is an example of an SRT file:</p>
		 * <code>
		 * 1<br />
		 * 00:02:26,407 --> 00:02:31,356 X1:100 X2:100 Y1:100 Y2:100<br />
		 * &lt;font color="#00FF00"&gt;Detta handlar om min storebrors&lt;/font&gt;<br />
		 * &lt;b&gt;&lt;i&gt;&lt;u&gt;kriminella beteende och foersvinnade.&lt;/u&gt;&lt;/i&gt;&lt;/b&gt;<br />
		 * <br />
		 * 2<br />
		 * 00:02:31,567 --> 00:02:37,164<br />
		 * Vi talar inte laengre om Wade. Det aer<br />
		 * som om han aldrig hade existerat.
		 * </code>
		 * <p>Luckily the <code>TextField.htmlText</code> supports the given html tags, so only positioning needs to be checked.</p>
		 * @see http://matroska.org/technical/specs/subtitles/srt.html
		 * @see http://en.wikipedia.org/wiki/SubRip
		 */
		private function parseSRT(srt:String):void 
		{
			// Replace Mac / Win type new lines with Unix ones...
			var pcLB:RegExp = /\r\n/g;
			var macLB:RegExp = /\r/g;
			var unixLB:RegExp = /\n/g;

			srt = srt.replace(pcLB, "\n");
			srt = srt.replace(macLB, "\n");

			// Clean spaces between two line ends.
			srt = srt.replace(/^\n\s+\n$/g, "\n\n");
			srt = srt.replace("\n\n\n", "\n\n");

			var ar:Array = srt.split("\n\n");
			var len:uint = ar.length;
			for (var i:uint = 0; i < len; i++) {
				var st:String = String(ar[i]);
				var a:Array = st.split("\n");
				if (a.length > 2) {
					var index:uint = parseInt(a[0]);
					var times:Array = String(a[1]).split("-->");
					var start:Number = parseTime(times[0]);
					var end:Number = parseTime(times[1]);

					// Remove used items an join the rest.
					var text:String = a.slice(2).join("\n");
					
					var si:SubtitleItem = new SubtitleItem(text, start, end);
					data.push(si);
					
					trace(si.toString());
				}
				else {
					trace("parseSRT. item " + i + " was in wrong format. " + st);
				}
			}
		}

		/**
		 * Parse the time of the start or the end of the given string.
		 * Input: <code>00:02:31,567</code> becomes out: <code>181.57</code>.
		 * @param	time	Time in the format used in SRT files
		 * @return	Time in seconds
		 */
		private function parseTime(time:String):Number
		{
			var ar:Array = trim(time).split(":");
			//trace("parseTime. ar: " + ar.toString());
			if (ar.length != 3) {
				trace("parseTime: Wrong time format used in [" + time + "]");
				return -1;
			}

			var sec:Number = 0;
			sec += parseInt(ar[0]) * 60 * 60; // Hours
			sec += parseInt(ar[1]) * 60; // Minutes
			//trace("parseTime. sec before seconds: " + sec.toString());

			var a:Array = String(ar[2]).split(",");
			if (a.length != 2) {
				trace("parseTime: Wrong time format used in [" + time + "]");
				return -1;
			}

			sec += parseInt(a[0]); // Seconds
			sec += parseInt(a[1]) / 1000; // Milliseconds

			//trace("parseTime. sec after seconds: " + sec.toString());

			return sec;
		}

		/**
		 * <p>Manually update the text of the designated TextField to match the current subtitle for the given time in seconds.</p>
		 * <code>
		 * var sr:Subtitler = new Subtitler(srt, field);<br />
		 * onEnterFrame = function () 
		{<br />
		 *     sr.update(stream.time);<br />
		 * };
		 * </code>
		 * @param	timeSec Current location of the playhead in seconds.
		 */
		public function update(timeSec:Number):void 
		{
			var it:SubtitleItem = null;
			var tx:String = "";
			var len:uint = data.length;
			var i:int = 0;
			if (previousSec > timeSec) {
				current = 0;
			}
			if (current > 0) {
				i = current;
			}
			while (i < len) {
				it = data[i] as SubtitleItem;
				if (it.check(timeSec)) {
					tx = it.text;
					current = i - 1;
					break;
				}
				i++;
			}
			field.htmlText = tx;
			previousSec = timeSec;
		}

		/**
		 * Trimmer for strings. Should be a native AS3 function but it is not...
		 */
		private function trim(string:String):String {
			if (string == null) {
				return '';
			}
			return string.replace(/^\s+|\s+$/g, '');
		}
	}
}