/**
 * @mxmlc -target-player=10.0.0 -debug -source-path+=D:/coordy/src
 */
package sandbox
{
	import flash.display.*;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.*;
	import flash.printing.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	
	import org.paazio.utils.Numbers;
	
	import com.somerandomdude.coordy.layouts.twodee.*;
	import com.somerandomdude.coordy.constants.*;
	
	import com.somerandomdude.coordy.layouts.threedee.*;
	import com.somerandomdude.coordy.proxyupdaters.InvalidationZSortProxyUpdater;

	[SWF(backgroundColor = '0xFFFFFF', frameRate = '33', width = '800', height = '900')]

	/**
	 * Get a list of techniques (kata) in Budo and randomly set them in the days of a year.
	 */
	public class TechniqueCalendar extends Sprite
	{
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
		 *
			A4
			printPages. orientation: portrait
			printPages. pageWidth: 595
			printPages. pageHeight: 842
			printPages. paperWidth: 595
			printPages. paperHeight: 842
		 */
		private const A4:Rectangle = new Rectangle(0, 0, 842, 595);
		private const PAGE:Rectangle = new Rectangle(10, 10, 822, 575);
		private const DAYS_IN_YEAR:uint = 365;
		private const MILLISECONDS_IN_DAY:uint = 1000 * 60 * 60 * 24;

		[Embed(source = "../assets/HGMaruGothicMPRO.ttf", fontFamily = "maru")]
		private var HGMaruGothicMPRO:String;

		private var _data:XML =
			<techniques>
				<school name="ryukyu kobujutsu" japanese="琉球古武術">
					<item japanese="津堅志多伯の釵">tsukenshitahaku no sai</item>
					<item japanese="北谷屋良の釵">chatanyara no sai</item>
					<item japanese="浜比嘉の釵">hamahiga no sai</item>
					<item japanese="周氏の棍小">shuji no kon sho</item>
					<item japanese="周氏の棍大">shuji no kon dai</item>
					<item japanese="周氏の棍古式">shuji no kon koshiki</item>
					<item japanese="佐久川の棍小">sakugawa no kon sho</item>
					<item japanese="佐久川の棍中">sakugawa no kon chu</item>
					<item japanese="佐久川の棍大">sakugawa no kon dai</item>
					<item japanese="添石の棍大">soeishi no kon dai</item>
					<item japanese="末吉の棍">sueyoshi no kon</item>
					<item japanese="金剛の棍">kongo no kon</item>
					<item japanese="北谷屋良の棍">chatanyara no kon</item>
					<item japanese="浜比嘉のトンファー">hamahiga no tonfa</item>
					<item japanese="鐘川の二丁鎌大">kanigawa no kama dai</item>
					<item japanese="当山の二丁鎌">tozan no kama</item>
					<item japanese="前里の鉄甲">maezato no tekko</item>
					<item japanese="練習型小">nunchaku sho</item>
					<item japanese="米川">yonekawa no kon</item>
				</school>
				<school name="yuishinkai karatejutsu" japanese="唯心会空手術">
					<item japanese="平安弐段">pinan nidan</item>
					<item japanese="平安初段">pinan shodan</item>
					<item japanese="平安三段">pinan sandan</item>
					<item japanese="平安四段">pinan yondan</item>
					<item japanese="平安五段">pinan godan</item>
					<item japanese="拔塞大">bassai dai</item>
					<item japanese="拔塞小">bassai sho</item>
					<item japanese="拔塞">tawata no bassai</item>
					<item japanese="小">kushanku sho</item>
					<item japanese="大">kushanku dai</item>
					<item japanese="北谷屋良の公相君">chatanyara no kushanku</item>
					<item japanese="弐段">naihanchi nidan</item>
					<item japanese="松村派">matsumura no rohai</item>
					<item japanese="鎮東">chinto</item>
					<item japanese="碎破">saifa</item>
					<item japanese="">sanchin</item>
				</school>
				<school name="taniha shitoryu karatedo" japanese="谷派糸東流空手道">
					<item japanese="浜比嘉のトンファー">hamahiga no tonfa</item>
					<item japanese="情的">anan</item>
					<item japanese="亞男宮">ananku</item>
					<item japanese="碎破">saifa</item>
					<item japanese="鎮東">chinto</item>
					<item japanese="古式の">koshiki no rohai</item>
				</school>
				<school name="nanbudo" japanese="南武道">
					<item japanese="南部初段">nanbu shodan</item>
					<item japanese="南部弐段">nanbu nidan</item>
					<item japanese="南部三段">nanbu sandan</item>
					<item japanese="南部四段">nanbu yondan</item>
					<item japanese="南部五段">nanbu godan</item>
					<item japanese="一極">ikkyoku</item>
					<item japanese="せいパイ">seipai</item>
					<item japanese="セイエンチン">seienchin</item>
					<item japanese="百八">hyaku hachi</item>
					<item japanese="三歩小">sampo sho</item>
					<item japanese="新">shin tajima</item>
				</school>
				<school name="shotokan karatedo" japanese="空手道">
					<item japanese="二十四歩">nijushiho</item>
					<item japanese="慈恩">jion</item>
					<item japanese="燕飛">empi</item>
					<item japanese="五十四歩小">gojushiho sho</item>
				</school>
				<school name="jodo" japanese="杖道">
					<item japanese="制定型：一。。。七">seitei kata 1...7</item>
					<item japanese="制定型：八。。。十二">seitei kata 8...12</item>
					<item japanese="一心流鎖鎌術">kusarigama omote 1...6</item>
					<item japanese="一心流鎖鎌術">kusarigama omote 7...12</item>
					<item japanese="神道夢想流">smr omote 2,6,9...12</item>
					<item japanese="神道流剣術">kenjutsu omote 1...7</item>
					<item japanese="短杖術">tanjo</item>
				</school>
				<school name="atarashii naginatado" japanese="新しい薙刀道">
					<item japanese="仕掛け"></item>
					<item japanese=""></item>
				</school>
				<school name="iaido" japanese="居合道">
					<item japanese="制定型：一。。。六">seitei kata 1...6</item>
					<item japanese="制定型：七。。。十二">seitei kata 7...12</item>
				</school>
				<school name="kendo" japanese="剣道">
					<item japanese="全剣形"></item>
					<item japanese="全剣形"></item>
				</school>
			</techniques>;

		private var _grid:Sprite;
		private var _format:TextFormat;
		private var _pages:Array = [];
		private var _layout2d:ILayout2d;
		private var _layout3d:ILayout3d;

		/**
		 * http://www.mitsubachi.ee/?page_id=988
		 * http://www.tallinksilja.com/fi/trips/routeTrips/hel-tal/default.htm
		 *
		 * Lauantaiksi Ilpon leirille Tallinnaan.
		 * 9.1.2010 11:30 - 17:30
		 *
		 * 08:30->10:30 29€
		 * 21:00->23:00 29€
		 * meno-paluumatka: -15%
		 */
		public function TechniqueCalendar()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.BEST;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			//XML.setNotification(onXmlNotify);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			_format = new TextFormat();
			_format.font = "maru";
			_format.color = 0x000000;
			//_format.bold = true;
			_format.align = TextFormatAlign.LEFT;
			_format.size = 16;
			
			_grid = new Sprite();
			_grid.name = "grid";
			//_grid.x = (stage.stageWidth - PAGE.width) / 2;
			//_grid.y = (stage.stageHeight - PAGE.height) / 2;
			addChild(_grid);

			
			
			
			/*
			_layout2d = new VerticalLine();
			_layout2d.x = PAGE.width / 2;
			*/
			
			/*
			_layout2d = new Spiral(15, .13);
			Spiral(_layout2d).alignType = PathAlignType.ALIGN_PARALLEL;
			_layout2d.x = PAGE.width / 2;
			_layout2d.y = PAGE.height / 2;
			*/
			
			/*
			_layout2d = new Grid(PAGE.width - 40, PAGE.height - 40, 10, 10);
			_layout2d.x = _grid.x;
			_layout2d.y = _grid.y;
			*/
			
			/*
			_layout3d = new Wave3d(PAGE.width - 40, PAGE.height - 80, 350);
			Wave3d(_layout3d).frequency = 2;
			_layout3d.proxyUpdater = new InvalidationZSortProxyUpdater(this, _layout3d);
			_layout3d.x = 20;
			_layout3d.y = PAGE.height / 2;
			*/
			
			/*
			_layout3d = new Stack3d(20);
			_layout3d.proxyUpdater = new InvalidationZSortProxyUpdater(this, _layout3d);
			_layout3d.x = 200;
			_layout3d.y = 120;
			*/
			/*
			_layout3d = new Spheroid3d(PAGE.width - 80, PAGE.height - 40, 300);
			_layout3d.proxyUpdater = new InvalidationZSortProxyUpdater(this, _layout3d);
			_layout3d.x = PAGE.width / 2;
			_layout3d.y = PAGE.height / 2;
			*/
			/*
			_layout3d = new Scatter3d(PAGE.width - 40, PAGE.height - 40, 350);
			Scatter3d(_layout3d).jitterRotation = true;
			_layout3d.proxyUpdater = new InvalidationZSortProxyUpdater(this, _layout3d);
			_layout3d.x = PAGE.width / 2;
			_layout3d.y = PAGE.height / 2;
			*/
			/*
			_layout3d = new Grid3d(PAGE.width - 10, PAGE.height - 10, 350, 50, 5, 5);
			_layout3d.proxyUpdater = new InvalidationZSortProxyUpdater(this, _layout3d);
			_layout3d.x = 0;
			_layout3d.y = 0;
			*/
			/*
			_layout3d = new Ellipse3d(PAGE.width - 40, PAGE.height - 40, 350);
			_layout3d.x = PAGE.width / 2;
			_layout3d.y = PAGE.height / 2;
			Ellipse3d(_layout3d).rotationY = -20;
			_layout3d.proxyUpdater = new InvalidationZSortProxyUpdater(this, _layout3d);
			*/
			
			var cont:Sprite = new Sprite();
			var initDate:Date = new Date(2010, 0, 1, 12);
			var colorRatio:Number = 255 / 365;
			var len:uint = _data..item.length() - 1;
			trace("len: " + len);
			for (var i:uint = 0; i < DAYS_IN_YEAR; ++i)
			{
				if (_pages.indexOf(cont) == -1)
				{
					_pages.push(cont);
				}
				
				var color:uint = Numbers.rgb(0xCC, 0xBB, 0xAA);
				
				var index:uint = Math.round(Math.random() * len);
				//trace(i + ", index: " + index);
				var tech:String = _data..item[index].@japanese.toString();
				var school:String = _data..item[index].parent().@japanese.toString();
				
				var item:Sprite = createItem(initDate, color, school + "\t" + tech);
				item.name = "day_" + (i + 1);
				item.x = 10;
				item.y = cont.height;
				cont.addChild(item);
				initDate.time += MILLISECONDS_IN_DAY;
				
				if (cont.height > PAGE.height)
				{
					cont = new Sprite();
				}
				
				
				//_layout2d.addNode(item);
				//_layout3d.addNode(item);
			}
			
			//Spheroid3d(_layout3d).distributeNodes(15);
			
			drawGrid();
		}
		
		private function drawGrid():void
		{
			var xPos:Number = 0;
			var yPos:Number = 0;
			var len:uint = _pages.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var cont:Sprite = _pages[i] as Sprite;
				var mat:Matrix = new Matrix();
				mat.scale(0.25, 0.25);
				var bmd:BitmapData = new BitmapData(A4.width / 4, A4.height / 4, true, 0x00121212);
				bmd.draw(cont, mat);
				var bm:Bitmap = new Bitmap(bmd);
				bm.x = xPos;
				bm.y = yPos;
				_grid.addChild(bm);
				
				xPos += bm.width + 4;
				
				if (i % 4 == 3)
				{
					yPos += bm.height + 4;
					xPos = 0;
				}
			}
		}
		
		/**
		 *
		 * @param	date
		 * @param	color
		 * @param	data
		 * @return
		 */
		private function createItem(date:Date, color:uint, data:String):Sprite
		{
			var m:String = String(date.getMonth() + 1);
			var d:String = date.getDate().toString();
			if (m.length < 2)
			{
				m = "0" + m;
			}
			if (d.length < 2)
			{
				d = "0" + d;
			}
			
			var w:Number = PAGE.width - 50;
			var h:Number = 20;
			
			var sp:Sprite = new Sprite();
			sp.cacheAsBitmap = true;
			sp.mouseChildren = false;
			
			var field:TextField = new TextField();
			field.defaultTextFormat = _format;
			field.embedFonts = true;
			field.selectable = false;
			field.background = false;
			field.multiline = true;
			field.width = w - 20;
			field.height = h;
			field.text = m + "月" + d + "日" + "\t" + data;
			field.x = 5;
			field.y = 5;
			sp.addChild(field);
			
			/*
			var bmd:BitmapData = new BitmapData(Math.ceil(w), Math.ceil(h), true, 0x00121212);
			bmd.draw(field);
			
			var bm:Bitmap = new Bitmap(bmd);
			bm.x = 5;
			bm.y = 5;
			sp.addChild(bm);
			*/
			
			var gr:Graphics = sp.graphics;
			gr.lineStyle(1, 0x000000, 0.4);
			gr.beginFill(color, 0.4);
			gr.drawRoundRectComplex(0, 0, w, h + 10, 0, 10, 10, 10);
			gr.endFill();
			
			return sp;
		}

		/**
		 * @see http://www.docsultant.com/site2/articles/flex_internals.html#xmlNotify
		 */
		private function onXmlNotify(targetCurrent:Object, command:String, target:Object, value:Object, detail:Object):void
		{
		}

		/**
		 * Print pages
		 */
		private function printPages():void
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
				
				var len:uint = _pages.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var cont:Sprite = _pages[i] as Sprite;
					print.addPage(cont);
				}
				
				print.send();
			}
			else
			{
				trace("printPages. print canceled.");
			}
		}

		/**
		 * @param	event
		 */
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				printPages();
			}
		}
	}
}
