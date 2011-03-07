/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	
	[SWF(backgroundColor = '0x006599', frameRate = '33', width = '200', height = '400')]
	
	public class Sliding extends Sprite
	{
		
		private var slider:Sprite;
		private var area:Shape;
		private var field:TextField;
		private var sliderDragged:Boolean = false;
		
		public var currentValue:int;
		
		public function Sliding()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			area = new Shape();
			area.graphics.beginFill(0xFF6633);
			area.graphics.drawRoundRect(0, 0, 4, 370, 4, 4);
			area.graphics.endFill();
			area.x = 25;
			area.y = 5;
			addChild(area);
			
			slider = new Sprite();
			slider.buttonMode = true;
			slider.graphics.beginFill(0xFF9966);
			slider.graphics.drawRoundRect(-8, 0, 20, 6, 6, 6);
			slider.graphics.endFill();
			slider.y = area.y;
			slider.x = area.x;
			slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderMouse);
			slider.addEventListener(MouseEvent.MOUSE_UP, onSliderMouse);
			addChild(slider);
			
			createField();
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
				
		private function onStageAdded(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
		}
		
		private function onStageMouseUp(event:MouseEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE)
			{
				return;
			}

			if (sliderDragged)
			{
				slider.stopDrag();
				sliderDragged = false;
			}
		}
		
		private function onSliderMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				var rect:Rectangle = area.getRect(this);
				rect.bottom -= slider.height;
				rect.right = rect.left;
				slider.startDrag(false, rect);
				sliderDragged = true;
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				slider.stopDrag();
				sliderDragged = false;
			}
		}
		
		private function createField():void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.font = "Arial";
			fmt.size = 12;
			fmt.color = 0xFFFFFF;
			fmt.align = TextFormatAlign.CENTER;
			
			field = new TextField();
			field.defaultTextFormat = fmt;
			field.multiline = true;
			field.selectable = false;
			field.width = 50;
			field.height = 22;
			field.y = stage.stageHeight - 23;
			field.x = 1;
			field.border = true;
			addChild(field);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var pos:Number = slider.y * 10;
			field.text = pos.toFixed(2);
			
			currentValue = Math.round(pos);
		}
	}
}
