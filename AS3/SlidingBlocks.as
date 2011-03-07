/**
 * @mxmlc -target-player=10.0.0 -source-path=D:/AS3libs -debug
 */
package
{
	import flash.display.*;
	import com.greensock.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF( backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600' )]
	
	public class SlidingBlocks extends Sprite
	{
		private const TWEEN_TIME:Number = 1.0;
		/**
		 * How much is scrolled of the viewable area in a step
		 */
		private const SCROLL_STEP:Number = 0.75;
		
		private var _blockMask:Shape;
		private var _blocks:Sprite;
		
		public function SlidingBlocks()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			_blocks = new Sprite();
			_blocks.name = "blocks";
			_blocks.x = 100;
			_blocks.y = 50;
			addChild(_blocks);
			
			createMask();
			_blocks.mask = _blockMask;
			
			for (var i:uint = 0; i < 10; ++i)
			{
				var box:Sprite = createBlock("box_" + i);
				box.y = _blocks.height;
				_blocks.addChild(box);
			}
			
			var tri90:Sprite = drawTriangle(180);
			tri90.x = 150;
			tri90.y = 20;
			addChild(tri90);
			
			var tri0:Sprite = drawTriangle(0);
			tri0.x = 150;
			tri0.y = 370;
			addChild(tri0);
		}
		
		private function createBlock(username:String):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.mouseChildren = false;
			sp.name = username;
			
			var gr:Graphics = sp.graphics;
			gr.beginFill(Math.random() * 0xFFFFFF);
			gr.drawRoundRect(0, 0, 100, 50, 10);
			gr.endFill();
			
			var field:TextField = new TextField();
			field.name = "field";
			field.defaultTextFormat = new TextFormat("Verdana", 12);
			field.embedFonts = true;
			field.width = sp.width;
			field.height = sp.height / 2;
			field.x = 0;
			field.y = 0;
			field.text = username;
			sp.addChild(field);
			
			var sh:Shape = new Shape();
			sh.name = "status";
			sh.x = sp.width / 2;
			sh.y = sp.height / 3 * 2;
			sp.addChild(sh);
			
			var gra:Graphics = sh.graphics;
			gra.beginFill(0xFF4400);
			gra.drawCircle(0, 0, 10);
			
			
			return sp;
		}
		
		/**
		 *
		 * @param	rotate
		 * @return
		 */
		private function drawTriangle(rotate:Number = 0):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.name = "triangle_" + rotate.toString();
			sp.addEventListener(MouseEvent.MOUSE_OVER, onArrowMouse);
			sp.addEventListener(MouseEvent.MOUSE_OUT, onArrowMouse);
			sp.addEventListener(MouseEvent.CLICK, onArrowMouse);
			sp.mouseChildren = false;
			
			var side:Number = 20;
			var rad:Number = Math.PI / 3;
			
			var gr:Graphics = sp.graphics;
			gr.beginFill(0xFFFFFF);
			var h:Number = Math.sqrt(Math.pow(side, 2) - Math.pow((side / 2), 2));
			gr.moveTo( -side / 2, - h / 2);
			gr.lineTo(0, h / 2);
			gr.lineTo(side / 2, -h / 2);
			gr.lineTo( -side / 2, -h / 2);
			gr.endFill();
			
			sp.rotation = rotate;
			
			var hit:Sprite = new Sprite();
			hit.name = "hit_" + rotate.toString();
			hit.graphics.beginFill(0, 0.0);
			hit.graphics.drawCircle(0, 0, 20);
			sp.addChild(hit);
			sp.hitArea = hit;
			
			return sp;
		}
		
		private function onArrowMouse(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			trace("onArrowMouse. " + sp.name + ", event: " + event.type);
			
			if (_blocks.height > _blockMask.height)
			{
				if (event.type == MouseEvent.MOUSE_OVER)
				{
					sp.addEventListener(Event.ENTER_FRAME, onArrowEnterFrame);
				}
				else if (event.type == MouseEvent.MOUSE_OUT || event.type == MouseEvent.MOUSE_DOWN)
				{
					if (sp.hasEventListener(Event.ENTER_FRAME))
					{
						sp.removeEventListener(Event.ENTER_FRAME, onArrowEnterFrame);
					}
				}
				
				var yPos:Number = 0;
				if (event.type == MouseEvent.CLICK)
				{
					if (sp.name == "triangle_180")
					{
						// Up
						yPos = _blocks.y + _blockMask.height * SCROLL_STEP;
						if (yPos > _blockMask.y)
						{
							yPos = _blockMask.y;
						}
					}
					else
					{
						// Down
						yPos = _blocks.y - _blockMask.height * SCROLL_STEP;
						if (yPos < _blockMask.y + _blockMask.height - _blocks.height)
						{
							yPos = _blockMask.y + _blockMask.height - _blocks.height;
						}
					}
					TweenLite.to(_blocks, TWEEN_TIME, { y: yPos } );
				}
			}
		}
		
		private function onArrowEnterFrame(event:Event):void
		{
			var sp:Sprite = event.target as Sprite;
			if (sp.name == "triangle_0")
			{
				// Upward
				_blocks.y -= 0.5;
			}
			else
			{
				// Downward
				_blocks.y += 0.5;
			}
			
			if (_blocks.y < _blockMask.y + _blockMask.height - _blocks.height)
			{
				_blocks.y = _blockMask.y + _blockMask.height - _blocks.height;
			}
			else if (_blocks.y > _blockMask.y)
			{
				_blocks.y = _blockMask.y;
			}
		}
		
		private function createMask():void
		{
			_blockMask = new Shape();
			_blockMask.name = "blockMask";
			_blockMask.x = 100;
			_blockMask.y = 100;
			addChild(_blockMask);
			
			var gr:Graphics = _blockMask.graphics;
			gr.beginFill(0x121212);
			gr.drawRect(0, 0, 100, 220);
			gr.endFill();
		}
	}
}
