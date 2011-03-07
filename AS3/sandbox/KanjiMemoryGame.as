/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.printing.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	
	[SWF(backgroundColor = '0xFFFFFF', frameRate = '33', width = '800', height = '900')]
	
	public class KanjiMemoryGame extends Sprite
	{
		private const KANJI_URL:String = "http://paazio.nanbudo.fi/kanji-list.php";
		private const PAIRS:uint = 6;
		
		private const ITEM_WIDTH:Number = 120;
		private const ITEM_HEIGHT:Number = 180;
		private const MARGIN:Number = 10;
			
		[Embed(source = "../assets/HGMaruGothicMPRO.ttf", fontFamily = "maru")]
		private var HGMaruGothicMPRO:String;
		
		private var _loader:URLLoader;
		private var _data:XML;
		private var _grid:Sprite;

		public function KanjiMemoryGame()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.addEventListener(Event.OPEN, onOpen);
			_loader.load(new URLRequest(KANJI_URL));
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function drawRandowGrid():void
		{
			_grid = new Sprite();
			_grid.name = "grid";
			addChild(_grid);
			
			var kanjis:Array = []; // indexes of the kanji
			var len:uint = _data.item.length();
			var items:Array = []; // Sprites
			var k:uint = 0;
			while ( k < PAIRS )
			{
				var inx:int = Math.round(Math.random() * (len - 1));
				while (kanjis.indexOf(inx) != -1)
				{
					inx = Math.round(Math.random() * (len - 1));
				}
				kanjis.push(inx);
				var item:XML = _data.item[inx];
				items.push(drawItem(item));
				items.push(drawItem(item, 2));
				++k;
			}
				
			var sideOne:Number = Math.sqrt(PAIRS * 2); // the amount of items per side if square.
			trace("sideOne: " + sideOne);
			
			var itemsH:int = Math.round(stage.stageWidth / stage.stageHeight * sideOne);
			var itemsV:int = Math.ceil(sideOne * 2) - itemsH;
			trace("itemsH: " + itemsH + ", itemsV: " + itemsV);
			
			var numH:Number = stage.stageWidth / itemsH;
			var numV:Number = stage.stageHeight / itemsV;
			trace("numH: " + numH + ", numV: " + numV);
			
			var points:Array = [];
			for (var i:uint = 0; i < itemsH; ++i)
			{
				for (var j:uint = 0; j < itemsV; ++j)
				{
					var point:Point = new Point((i + 0.5) * numH - ITEM_WIDTH, (j + 0.5) * numV - ITEM_HEIGHT);
					points.push(point);
				}
			}
			
			k = 0;
			len = items.length;
			
			while (k < len)
			{
				var sp:Sprite = items[k] as Sprite;
				
				var pos:Point = points.shift();
				sp.x = pos.x;
				sp.y = pos.y;
				_grid.addChild(sp);
				
				++k;
			}
		}
		
		private function drawItem(item:XML, counter:uint = 1):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.name = item.@id.toString() + "_" + counter;
			sp.mouseChildren = false;
			
			var format:TextFormat = new TextFormat("maru", ITEM_HEIGHT / 2, 0x121212, true);
			format.align = TextFormatAlign.CENTER;
			
			var field:TextField = new TextField();
			field.name = "field";
			field.defaultTextFormat = format;
			field.embedFonts = true;
			field.cacheAsBitmap = true;
			field.width = ITEM_WIDTH;
			field.height = ITEM_HEIGHT / 3 * 2;
			field.y = ITEM_HEIGHT / 4;
			field.text = item.kanji.text();
			sp.addChild(field);
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(ITEM_WIDTH, ITEM_HEIGHT, Math.random() * 360);
			
			var gr:Graphics = sp.graphics;
			gr.lineStyle(2, 0x121212, 1.0);
			gr.beginFill(0xF2F2F2, 1.0);
			gr.drawRoundRectComplex(0, 0, ITEM_WIDTH, ITEM_HEIGHT, 0, 12, 12, 12);
			gr.endFill();
			
			var sh:Shape = new Shape();
			sh.name = "overlay";
			sp.addChild(sh);
			
			gr = sh.graphics;
			gr.lineStyle(2, 0x121212, 1.0);
			gr.beginGradientFill(
				GradientType.RADIAL,
				[0xFFFFFF, 0xF2F2F2, 0xCCCCCC],
				[1.0, 1.0, 1.0],
				[0, 100, 244],
				mat
			);
			gr.drawRoundRectComplex(0, 0, ITEM_WIDTH, ITEM_HEIGHT, 0, 12, 12, 12);
			gr.endFill();
			
			return sp;
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawRandowGrid();
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			var w:Number = stage.stageWidth / 2;
			var h:Number = 100;
			var xPos:Number = (stage.stageWidth - w) / 2;
			var yPos:Number = (stage.stageHeight - h) / 2;
			var ratio:Number = _loader.bytesLoaded / _loader.bytesTotal;
			if (isNaN(ratio))
			{
				ratio = 0;
			}
			trace(_loader.bytesLoaded + "/" + _loader.bytesTotal);
			
			var gr:Graphics = graphics;
			gr.clear();
			gr.lineStyle(2, 0x121212);
			gr.drawRect(xPos, yPos, w, h);
			gr.lineStyle();
			gr.beginFill(0xCCCCCC);
			gr.drawRect(xPos, yPos, ratio * w, h);
			gr.endFill();
		}
		
		private function onOpen(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onComplete(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var gr:Graphics = graphics;
			gr.clear();
			
			_data = new XML(_loader.data);
			//trace("onComplete. _data: " + _data);
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
