/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
	public class PixelDissolveTest extends Sprite
	{
		private var _bm:Bitmap;
		private var _field:TextField;
		
		public function PixelDissolveTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var m:uint = 60;
			var w:uint = Math.round(stage.stageWidth);
			var h:uint = Math.round(stage.stageWidth - m);
			
			_bm = new Bitmap(new BitmapData(w, h, false, 0x00CCCCCC));
			_bm.y = m;
			addChild(_bm);
			
			var format:TextFormat = new TextFormat("Verdana", 12, 0x121212);
			_field = new TextField();
			_field.defaultTextFormat = format;
			_field.multiline = true;
			_field.wordWrap = true;
			_field.background = true;
			_field.width = w;
			_field.height = m;
			addChild(_field);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE :
					var randomNum:Number = Math.floor(Math.random() * int.MAX_VALUE);
					dissolve(randomNum);
					_field.text = randomNum.toString();
					break;
			}
		}
		
		private function dissolve(randomNum:Number):void
		{
			var rect:Rectangle = _bm.bitmapData.rect;
			var pt:Point = new Point(0, 0);
			var numberOfPixels:uint = 10000;
			var red:uint = 0x00FF0000;
			_bm.bitmapData.pixelDissolve(_bm.bitmapData, rect, pt, randomNum, numberOfPixels, red);
			var grayRegion:Rectangle = _bm.bitmapData.getColorBoundsRect(0xFFFFFFFF, 0x00CCCCCC, true);
		}
	}
}
