/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	/**
	 * Calculation of an angle seems complicated but is rather trivial.
	 */
	public class AngleCalculationTest extends Sprite
	{
		private var _field:TextField;
		private var _shape:Shape;
		
		public function AngleCalculationTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_field = new TextField();
			_field.x = 10;
			_field.y = 10;
			_field.width = stage.stageWidth - 20;
			_field.height = 40;
			_field.selectable = false;
			_field.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFEE7);
			addChild(_field);
			
			_shape = new Shape();
			_shape.x = stage.stageWidth / 2;
			_shape.y = stage.stageHeight / 2;
			addChild(_shape);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function drawAngle():void
		{
			var aX:Number = stage.mouseX - _shape.x;
			var aY:Number = stage.mouseY - _shape.y;
			
			var angle:Number = Math.atan2(aY, aX);
			trace(angle);
			_field.text = "RAD: " + (Math.round(angle * 100) / 100) + ", DEC: " + Math.round(angle * 180 / Math.PI);
			
			var gr:Graphics = _shape.graphics;
			gr.clear();
			
			gr.beginFill(0xE3E3C9, 0.5);
			gr.lineStyle(1, 0x8B8C7D, 0.5);
			
			var len:uint = Math.round(Math.abs(angle));
			trace(len);
			for (var i:uint = 0; i < len; ++i)
			{
				var xPos:Number = Math.sin(i + angle) * 100;
				var yPos:Number = Math.cos(i + angle) * 100;
				gr.lineTo(xPos, yPos);
			}
			
			gr.endFill();
			gr.moveTo(0, 0);
			gr.lineTo(aX, aY);
			
			gr.lineStyle(0);
			gr.beginFill(0x961D18, 1.0);
			gr.drawCircle(aX, aY, 6);
			gr.drawCircle(0, 0, 6);
			gr.endFill();
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			drawAngle();
		}
	}
}
