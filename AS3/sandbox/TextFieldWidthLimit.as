/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '400', height = '200')]

	public class TextFieldWidthLimit extends Sprite
	{
		/*
		 * Word warp before the limit is reached
		 */
		private const WIDTH_LIMIT:Number = 320;

		private var format:TextFormat;
		private var field:TextField;
		private var background:Shape;

		// -----
		private var lines:TextField;
		// -----
		
		/**
		 * Adjust the size of the text field according to the maximum width given.
		 */
		public function TextFieldWidthLimit()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			background = new Shape();
			background.x = 10;
			background.y = 10;
			addChild(background);

			format = new TextFormat();
			format.font = "Verdana";
			format.color = 0x000000;
			format.bold = true;
			format.size = 12;
			format.align = TextFormatAlign.LEFT;

			field = new TextField();
			//field.autoSize = TextFieldAutoSize.LEFT;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.defaultTextFormat = format;
			field.type = TextFieldType.INPUT;
			field.multiline = true;
			field.wordWrap = true;
			field.width = WIDTH_LIMIT; // initial width must be set before the initial text
			field.text = "Advanced anti-aliasing allows font faces to be rendered at very high quality at small sizes.\n\nAdvanced anti-aliasing is not recommended for very large fonts (larger than 48 points).";
			field.x = background.x;
			field.y = background.y;
			//field.addEventListener(TextEvent.TEXT_INPUT, onTextChange);
			//field.addEventListener(Event.CHANGE, onChange);
			field.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addChild(field);

			graphics.lineStyle(1, 0xFFFFFF, 0.5);
			graphics.moveTo(WIDTH_LIMIT + background.x, 0);
			graphics.lineTo(WIDTH_LIMIT + background.x, stage.stageHeight);
			
			// -----
			lines = new TextField();
			lines.autoSize = TextFieldAutoSize.RIGHT;
			lines.border = true;
			lines.borderColor = 0x000000;
			lines.background = true;
			lines.backgroundColor = 0xFFFFFF;
			lines.x = stage.stageWidth - 8;
			lines.y = 10;
			addChild(lines);
			// -----

			drawBackground();
		}

		private function drawBackground():void
		{
			var w:Number = 0;
			
			// For some reason these should be set before the calculations.
			field.width = WIDTH_LIMIT;
			field.text = field.text;
			
			for (var i:uint = 0; i < field.numLines; ++i)
			{
				var metr:TextLineMetrics = field.getLineMetrics(i);
				if (metr.width > w)
				{
					w = metr.width;
				}
				//trace("Line " + i + " width: " + metr.width);
			}

			if (w >= WIDTH_LIMIT)
			{
				w = WIDTH_LIMIT;
			}
			
			// -----
			lines.text = "lines: " + field.numLines.toString() + "\nw: " + w.toString();
			// -----

			field.width = w;
			field.height = field.textHeight + 4;

			var gra:Graphics = background.graphics;
			gra.clear();
			gra.beginFill(0xFFFFFF);
			gra.lineStyle(1, 0x000000);
			gra.drawRoundRect(0, 0, field.width + 2, field.height + 2, 6, 6);
			gra.endFill();
		}

		private function onChange(event:Event):void
		{
			trace("onChange. ");
			drawBackground();
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			trace("onKeyUp. ");
			drawBackground();
		}

		private function onTextChange(event:TextEvent):void
		{
			trace("onTextChange. ");
			drawBackground();
		}
	}
}
