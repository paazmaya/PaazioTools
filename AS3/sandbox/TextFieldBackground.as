/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '400', height = '200')]

	public class TextFieldBackground extends Sprite
	{

		private var format:TextFormat;
		private var field:TextField;
		private var background:Shape;

		public function TextFieldBackground()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
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
			field.autoSize = TextFieldAutoSize.LEFT;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.defaultTextFormat = format;
			field.type = TextFieldType.INPUT;
			field.multiline = true;
			field.text = "Ichiban ni narukoto wa kesshite kantan dewanai.\nThe best never comes easy.";
			field.x = background.x;
			field.y = background.y;
			
			// Best result with KEY_UP event.
			//field.addEventListener(TextEvent.TEXT_INPUT, onTextChange);
			//field.addEventListener(Event.CHANGE, onTextChange);
			field.addEventListener(KeyboardEvent.KEY_UP, onTextChange);
			
			addChild(field);

			drawBackground();
		}

		private function drawBackground():void
		{
			var rect:Rectangle = field.getRect(this);

			var gra:Graphics = background.graphics;
			gra.clear();
			gra.beginFill(0xFFFFFF);
			gra.lineStyle(1, 0x000000);
			gra.drawRoundRect(0, 0, rect.width, rect.height, 6, 6);
		}

		private function onTextChange(event:Event):void
		{
			drawBackground();
		}
	}
}
