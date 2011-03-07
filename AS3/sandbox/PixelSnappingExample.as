/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.events.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	public class PixelSnappingExample extends Sprite
	{
		
		private var _snaps:Array =
		[
			PixelSnapping.ALWAYS,
			PixelSnapping.AUTO,
			PixelSnapping.NEVER
		];
		
		private var _buttons:Sprite;
	
		public function PixelSnappingExample() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
			
			_buttons = new Sprite();
			addChild(_buttons);
			
			drawGrid();
			
			var len:uint = _snaps.length;
			for (var i:uint = 0; i < len; ++i) 
			{
				var sp:Sprite = createButton(_snaps[i] as String);
				sp.y = 2 + i * (sp.height + 2);
				sp.x = 12;
				_buttons.addChild(sp);
			}
			
			drawDraggables();
		}
		
		private function onButtonMouse(event:MouseEvent):void 
		{
			var sp:Sprite = event.target as Sprite;
			
			for (var i:uint = 0; i < _buttons.numChildren; ++i)
			{
				var ch:Sprite = _buttons.getChildAt(i) as Sprite;
				drawButtonBg(ch);
			}
			drawButtonBg(sp, true);
		}
		
		private function onDragMouse(event:MouseEvent):void 
		{
			var sp:Sprite = event.target as Sprite;
			var bounds:Rectangle = new Rectangle(60, 60, stage.stageWidth - 60, stage.stageHeight - 60);
			
			if (event.type == MouseEvent.MOUSE_DOWN) 
			{
				sp.startDrag(false, bounds);
				swapChildrenAt(getChildIndex(sp), numChildren - 1);
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				sp.stopDrag();
			}
		}
		
		private function drawDraggables():void 
		{
			for (var i:uint = 0; i < 25; ++i) 
			{
				var sp:Sprite = new Sprite();
				sp.mouseChildren = false;
				sp.x = Math.random() * (stage.stageWidth - 60) + 30;
				sp.y = Math.random() * (stage.stageHeight - 60) + 30;
				sp.addEventListener(MouseEvent.MOUSE_DOWN, onDragMouse);
				sp.addEventListener(MouseEvent.MOUSE_UP, onDragMouse);
				addChild(sp);
				
				var bm:Bitmap = new Bitmap(new BitmapData(60, 60));
				bm.bitmapData.noise(Math.round(Math.random() * (i + 2)), 8, 128, 7, true);
				sp.addChild(bm);
			}
		}
		private function drawGrid():void 
		{
			var commands:Vector.<int> = new Vector.<int>();
			var coord:Vector.<Number> = new Vector.<Number>();
			
			for (var i:uint = 5; i < stage.stageWidth; i += 10)
			{
				commands.push(1); // moveto
				commands.push(2); // lineto
				
				// Move to
				coord.push(i); //x
				coord.push(0); //y
				
				// Line to
				coord.push(i);
				coord.push(stage.stageHeight);
			}
			for (var j:uint = 5; j < stage.stageHeight; j += 10) 
			{
				commands.push(1); // moveto
				commands.push(2); // lineto
				
				// Move to
				coord.push(0); //x
				coord.push(j); //y
				
				// Line to
				coord.push(stage.stageWidth);
				coord.push(j);
			}
			
			var gra:Graphics = graphics;
			gra.clear();
			gra.lineStyle(1, 0x88AA44);
			gra.drawPath(commands, coord);
		}
		
		private function createButton(text:String):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.name = text;
			sp.mouseChildren = false;
			sp.addEventListener(MouseEvent.MOUSE_UP, onButtonMouse);
			var tf:TextField = createField();
			tf.text = text;
			sp.addChild(tf);
			drawButtonBg(sp);
			return sp;
		}
		
		private function createField():TextField
		{
			var tf:TextField = new TextField();
			tf.textColor = 0xFAFAFA;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = 2;
			tf.y = 2;
			return tf;
		}
		
		private function drawButtonBg(sp:Sprite, current:Boolean = false):void 
		{
			var color:uint = 0x121212;
			if (current)
			{
				color = 0x656565;
			}
			var gra:Graphics = sp.graphics;
			gra.clear();
			gra.beginFill(color);
			gra.drawRoundRect(0, 0, sp.width + 2, sp.height + 2, 10, 10);
			gra.endFill();
		}
	}
}
