/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.*;
	import flash.printing.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	
	[SWF(backgroundColor = '0xFFFFFF', frameRate = '33', width = '800', height = '900')]
	
	public class KanjiPrinter extends Sprite
	{
		private const KANJI_URL:String = "http://paazio.nanbudo.fi/kanji-list.php";
		
		/**
		 * A rectangle's width and height are pixel values.
		 * A printer uses points as print units of measurement.
		 * Points are a fixed physical size (1/72 inch), but the size of a pixel, onscreen,
		 * depends on the resolution of the particular screen. So, the conversion rate
		 * between pixels and points depends on the printer settings and whether the sprite
		 * is scaled. An unscaled sprite that is 72 pixels wide will print out one inch wide,
		 * with one point equal to one pixel, independent of screen resolution.
		 * A twip is 1/20 of a point. 1 cm = 567 twips.
		 *
		 * These values have been got from the PDFcreator dialog.
		 * 595, 842 --> PAGE
		 *
		 * A5:
		 * printPages. orientation: landscape
		 * printPages. pageWidth: 595
		 * printPages. pageHeight: 420
		 * printPages. paperWidth: 595
		 * printPages. paperHeight: 420
		 */
		private const A5:Rectangle = new Rectangle(0, 0, 595, 420);
		private const PAGE:Rectangle = new Rectangle(10, 10, 575, 400);
		
		[Embed(source = "../assets/HGMaruGothicMPRO.ttf", fontFamily = "maru")]
		private var HGMaruGothicMPRO:String;
		
		private var _loader:URLLoader;
		private var _container:Sprite;
		private var _data:XML;
		private var _currentId:int = 0;

		public function KanjiPrinter()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_container = new Sprite();
			_container.name = "container";
			_container.x = (stage.stageWidth - PAGE.width) / 2;
			_container.y = (stage.stageHeight - PAGE.height) / 2;
			_container.visible = false;
			addChild(_container);
			
			var gra:Graphics = _container.graphics;
			gra.lineStyle(2, 0x000000, 0.6);
			gra.drawRoundRectComplex(PAGE.x, PAGE.y, PAGE.width, PAGE.height, 60, 0, 30, 30);
			
			var format:TextFormat = new TextFormat();
			format.font = "maru";
			format.color = 0x000000;
			//format.bold = true;
			
			var kanjiField:TextField = createField(format, PAGE.width / 2, PAGE.height / 2, 128, TextFormatAlign.CENTER);
			kanjiField.name = "kanjiField";
			kanjiField.y = 50;
			kanjiField.x = PAGE.x;
			kanjiField.scaleX = 2;
			kanjiField.scaleY = 2;
			kanjiField.text = "無";
			_container.addChild(kanjiField);
			
			var metr:TextLineMetrics = kanjiField.getLineMetrics(0);
			trace("metr.height: " + metr.height);
			
			var numbersField:TextField = createField(format, PAGE.width / 2, 100, 18, TextFormatAlign.RIGHT);
			numbersField.x = PAGE.x + PAGE.width / 2;
			numbersField.y = PAGE.y;
			numbersField.name = "numbersField";
			numbersField.text = "E1234\nS8\nJ3";
			_container.addChild(numbersField);
			
			// ON: katakana, kun: hiragana
			var readingsField:TextField = createField(format, PAGE.width - 100, 60, 20, TextFormatAlign.CENTER);
			readingsField.name = "readingsField";
			readingsField.x = (PAGE.width - readingsField.width) / 2;
			readingsField.y = PAGE.y + PAGE.height - readingsField.height;
			readingsField.text = "ム, フ";
			_container.addChild(readingsField);
			
			/*
			var exampleField:TextField = createField(format, PAGE.width, 28, 20, TextFormatAlign.CENTER);
			exampleField.name = "exampleField";
			exampleField.y = PAGE.height - exampleField.height;
			exampleField.text = "mugenno";
			_container.addChild(exampleField);
			*/
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			var req:URLRequest = new URLRequest(KANJI_URL);

			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.load(req);
			addEventListener(Event.ENTER_FRAME, onLoaderEnterFrame);
		}
		
		private function onLoaderEnterFrame(event:Event):void
		{
			trace("onLoaderEnterFrame. " + _loader.bytesLoaded + "/" + _loader.bytesTotal);
			var amount:Number = _loader.bytesLoaded / _loader.bytesTotal;
			var w:Number = stage.stageWidth / 3 * 2;
			var h:Number = 40;
			var xPos:Number = (stage.stageWidth - w) / 2;
			var yPos:Number = (stage.stageHeight - h) / 2;
			var gr:Graphics = graphics;
			gr.clear();
			
			if (!isNaN(_loader.bytesTotal) && _loader.bytesTotal)
			{
				gr.beginFill(0x00000, 0.6);
				gr.drawRect(xPos, yPos, (w * amount), h);
				gr.endFill();
			}
			
			gr.lineStyle(2, 0x000000);
			gr.drawRect(xPos, yPos, w, h);
			gr.lineStyle(0);
		}
		
		private function showCurrent():void
		{
			var item:XML;
			if (_data.item.(@id == _currentId).length() > 0)
			{
				item = _data.item.(@id == _currentId)[0];
			}
			//trace("showCurrent. _currentId: " + _currentId + ", item: " + item);
			setKanji(item);
		}
		
		private function setKanji(item:XML):void
		{
			var kanjiField:TextField = _container.getChildByName("kanjiField") as TextField;
			var numbersField:TextField = _container.getChildByName("numbersField") as TextField;
			var readingsField:TextField = _container.getChildByName("readingsField") as TextField;
			//var exampleField:TextField = _container.getChildByName("exampleField") as TextField;
			
			if (item != null)
			{
				kanjiField.text = item.kanji.text()[0].toString();
				numbersField.text = "E" + item.@id.toString()
					+ "\nS" + item.kanji.@strokes.toString() + "\nJ" + item.@jlpt.toString();
				readingsField.text = item.reading.@on[0].toString()
					+ "\n" + item.reading.@kun[0].toString();
				//exampleField.text = item.example.text()[0].toString();
			}
		}
		
		private function createField(format:TextFormat, w:Number, h:Number, size:Number, align:String):TextField
		{
			format.size = size;
			format.align = align;
			
			var field:TextField = new TextField();
			field.defaultTextFormat = format;
			field.embedFonts = true;
			field.cacheAsBitmap = true;
			field.width = w;
			field.height = h;
			field.selectable = false;
			field.multiline = true;
			return field;
		}
		
		/**
		 * Print pages
		 * @param	level	JLPT level, or 0 to print everything
		 */
		private function printPages(level:uint = 0):void
		{
			var options:PrintJobOptions = new PrintJobOptions();
			options.printAsBitmap = false; // default: false
			
			var print:PrintJob = new PrintJob();
			if (print.start())
			{
				trace("printPages. orientation: " + print.orientation);
				trace("printPages. pageWidth: " + print.pageWidth);
				trace("printPages. pageHeight: " + print.pageHeight);
				trace("printPages. paperWidth: " + print.paperWidth);
				trace("printPages. paperHeight: " + print.paperHeight);
				/*
				A4
				printPages. orientation: portrait
				printPages. pageWidth: 595
				printPages. pageHeight: 842
				printPages. paperWidth: 595
				printPages. paperHeight: 842
				
				A5
				printPages. orientation: landscape
				printPages. pageWidth: 595
				printPages. pageHeight: 420
				printPages. paperWidth: 595
				printPages. paperHeight: 420
				*/
				var items:XMLList;
				if (level > 0)
				{
					items = _data.item.(@jlpt == level);
				}
				else
				{
					items = _data.item;
				}
				var len:uint = items.length();
				for (var i:uint = 0; i < len; ++i)
				{
					var item:XML = items[i];
					setKanji(item);
					print.addPage(_container, A5, options);
				}
				print.send();
			}
			else
			{
				trace("printPages. print canceled.");
			}
		}
		
		/**
		 * Number 4 == Code 52
		 * Number 3 == Code 51
		 * Number 2 == Code 50
		 * Number 1 == Code 49
		 * @param	event
		 */
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				if (_data != null)
				{
					printPages();
				}
			}
			else if (event.keyCode == 52)
			{
				if (_data != null)
				{
					printPages(4);
				}
			}
			else if (event.keyCode == 51)
			{
				if (_data != null)
				{
					printPages(3);
				}
			}
			else if (event.keyCode == 50)
			{
				if (_data != null)
				{
					printPages(2);
				}
			}
			else if (event.keyCode == 49)
			{
				if (_data != null)
				{
					printPages(1);
				}
			}
			else if (event.keyCode == Keyboard.LEFT)
			{
				--_currentId;
				if (_currentId < 1)
				{
					_currentId = _data.item.length();
				}
				showCurrent();
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				++_currentId;
				if (_currentId > _data.item.length())
				{
					_currentId = 1;
				}
				showCurrent();
			}
		}
		
		private function onComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			_data = new XML(loader.data);
			//trace("onComplete. _data: " + _data);
			
			// http://en.wikipedia.org/wiki/Japanese_Language_Proficiency_Test
			var jlpt4:uint = _data.item.(@jlpt == 4).length();
			var jlpt3:uint = _data.item.(@jlpt == 3).length();
			var jlpt2:uint = _data.item.(@jlpt == 2).length();
			var jlpt1:uint = _data.item.(@jlpt == 1).length();
			
			trace("JLPT 4: " + jlpt4 + " items"); // 103 (103)
			trace("JLPT 3: " + (jlpt4 + jlpt3) + " items"); // 270 (284)
			trace("JLPT 2: " + (jlpt4 + jlpt3 + jlpt2) + " items"); // 606 (1023)
			trace("JLPT 1: " + (jlpt4 + jlpt3 + jlpt2 + jlpt1) + " items"); // 606 (1926)
			trace("All: " + _data.item.length() + " items"); // 648
			
			removeEventListener(Event.ENTER_FRAME, onLoaderEnterFrame);
			graphics.clear();
			_container.visible = true;
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			trace("onIOError");
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			trace("onSecurityError");
		}
	}
}
