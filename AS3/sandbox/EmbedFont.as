/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.system.*;
	import flash.sampler.getSize;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
	/**
	 * Embed fonts in many ways.
	 * @see http://www.zedia.net/2010/fonts-are-my-bane-not-anymore/
	 * @see http://rishida.net/scripts/uniview/conversion.php
	 * @see http://www.unicode.org/charts/
	 */
	public class EmbedFont extends Sprite
	{
		[Embed(source = "../assets/HGSeikaishotaiPRO.TTF", fontName = "HGSeikaishotaiPRO", unicodeRange = 'U+0020-U+007A, U+00C0-U+00F6, U+2019', mimeType = "application/x-font-truetype")]
		private var HGSeikaishotaiPRO_Some:Class;

		[Embed(source = "../assets/nrkis.ttf", fontFamily = "nrkis")]
		private var Nrkis:String;
		
		// Numbers only
		[Embed(source = "../assets/nrkis.ttf", fontFamily = "nrkisNumbers", unicodeRange = "U+0030-U+0039")]
		private var NrkisNumbers:String;
		
		[Embed(source = "../assets/epmgobld.ttf", fontFamily = "epmgobld", unicodeRange = "U+30A0-U+30FF")]
		private var Epmgobld:String;
		
		// Katakana only
		[Embed(source = "../assets/epmgobld.ttf", fontFamily = "epmgobldKatakana", unicodeRange = "U+30A0-U+30FF")]
		private var EpmgobldKatakana:String;
			
		[Embed(source = "../assets/Vera.ttf", fontFamily = "vera")]
		private var Vera:String;
		
		[Embed(source = "../assets/VeraSe.ttf", fontFamily = "verase")]
		private var VeraSe:String;
		
		[Embed(source = "../assets/papyrus.ttf", fontFamily = "papyrus")]
		private var Papyrus:String;
		
		/*
		U+0041-U+005A  Upper-Case [A..Z]
		U+0061-U+007A  Lower-Case a-z
		U+0030-U+0039  Numbers [0..9]
		U+002E-U+002E  Period [.]
		U+00A9-U+00A9  Copyright sign
		U+30A0-U+30FF  Katakana
		
		U+0020-U+007A = SPACE!"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz
		U+00C0-U+00F6 = ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö
		U+2019 = ’
		 */
		
		private var _field:TextField;
		private var _formats:Vector.<TextFormat>;
		private var _fontNames:Array = [
			"nrkis",
			"nrkisNumbers",
			"epmgobld",
			"epmgobldKatakana",
			"vera",
			"verase",
			"papyrus",
			"HGSeikaishotaiPRO"
		];
		private var _currentFormat:int = 0;
		private var _w:Number = 600;
		private var _h:Number = 400;
		private var _m:Number = 10;
		private var _embed:Boolean = false;

		public function EmbedFont()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			// Registers a font class in the global font list.
			Font.registerFont(HGSeikaishotaiPRO_Some);
			
			_formats = new Vector.<TextFormat>();
			var len:uint = _fontNames.length;
			for (var k:uint = 0; k < len; ++k)
			{
				_formats.push(createFormat(_fontNames[k]));
			}
			
			_field = new TextField();
			_field.background = true;
			_field.border = true;
			_field.multiline = true;
			_field.wordWrap = true;
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.text = "新しい薙刀"
				+ "\nJapanissa naisharrastajien määrä on noin 90%. Japanin ulkopuolella sanotaan sen olleen joskus toisinpäin, siis vain 10% olisi naisia."
				+ "Oman kokemukseni mukaan Euroopassa ja Yhdysvalloissa jakauma on tasaisen 50%-60%. Matti Nykänenkin sen tietää."
				+ "\n\nNaginata aseena on esiintynyt useissa paikoissa, taistelutantereella jalkasotilaan aseena, kotivaimon puolustusvälineenä miehen ollessa sotimassa, "
				+ "papilla temppelissä pitämässä varkaat loitolla...\n";
			addChild(_field);
			updateField();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			
			var fonts:Array = Font.enumerateFonts(true);
			// Get only Arial and Verdana types.
			fonts = fonts.filter(checkFont).sortOn("fontName", Array.CASEINSENSITIVE);
			for (var i:uint = 0; i < fonts.length; ++i)
			{
				var font:Font = fonts[i] as Font;
				_field.appendText("\n" + i + "\tfontName: " + font.fontName + ", fontType: " + font.fontType + ", fontStyle: " + font.fontStyle + ", hasGlyphs(な): " + font.hasGlyphs("な"));
			}
			
			
			trace("Capabilities.language: " + Capabilities.language);
		}
		
		private function updateField():void
		{
			_field.x = _m;
			_field.y = _m;
			_field.width = _w - _m * 2;
			_field.height = _h - _m * 2;
			
			if (_currentFormat < 0)
			{
				_currentFormat = 0;
			}
			else if (_currentFormat >= _formats.length)
			{
				_currentFormat = _formats.length - 1;
			}
			_field.setTextFormat(_formats[_currentFormat]);
			_field.embedFonts = _embed;
			
			trace("updateField. _currentFormat: " + _currentFormat + ", _embed: " + _embed + ", font: " + _field.getTextFormat().font);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DOWN)
			{
				--_currentFormat;
			}
			else if (event.keyCode == Keyboard.UP)
			{
				++_currentFormat;
			}
			else if (event.keyCode == Keyboard.SPACE)
			{
				_embed = !_embed;
			}
			updateField();
		}
		
		private function createFormat(font:String):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = font;
			format.color = 0x121212;
			format.size = 12;
			trace("createFormat. font: " + font + ", size: " + getSize(format));
			return format;
		}
		
		private function checkFont(item:Object, index:uint, arr:Array):Boolean
		{
			var font:Font = item as Font;
			//trace("Checking font: " + font.fontName);
			if (font.fontName.toLowerCase().indexOf("arial") > -1 || font.fontName.toLowerCase().indexOf("verdana") > -1)
			{
				return true;
			}
			return false;
		}
	}
}
