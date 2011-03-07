package org.paazio.visual
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;

	/**
	 * TextField extension
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.1
	 */
	public class PTextField extends TextField
	{
		private var _format:TextFormat;

		[Embed(source = "../../../assets/nrkis.ttf", fontFamily = "nrkis", unicodeRange = "U+0030-U+0039")]
		private var Nrkis:String;
		
		public function PTextField()
		{
			_format = new TextFormat();
			_format.align = TextFormatAlign.JUSTIFY;
			_format.color = 0x121212;
			_format.font = "nrkis";
			_format.size = 12;
			
			defaultTextFormat = _format;
			//embedFonts = true;
			autoSize = TextFieldAutoSize.LEFT;
			antiAliasType = AntiAliasType.ADVANCED;
		}
	}
}
