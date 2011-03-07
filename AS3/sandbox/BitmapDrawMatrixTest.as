/**
 * @mxmlc -target-player=10.0.0
 */
package sandbox
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '1000', height = '800')]
	
	public class BitmapDrawMatrixTest extends Sprite
	{
		
		[Embed(source = "../assets/apina.jpg")]
		private var Apina:Class;
		
		private var _box:Shape;
		private var _photo:Bitmap;
		private var _snap:Bitmap;
		private var _fill:Shape;
		private var _field:TextField;
		
		private var w:Number = 240;
		private var h:Number = 180;
		private var m:Number = 10;
		
		public function BitmapDrawMatrixTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_photo = new Apina() as Bitmap;
			_photo.x = stage.stageWidth - (_photo.width + m);
			_photo.y = m;
			addChild(_photo);
			
			createField();
			
			_box = new Shape();
			_box.addEventListener(Event.ENTER_FRAME, onBoxEnterFrame);
			addChild(_box);
			drawBox();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function drawBox():void
		{
			var gra:Graphics = _box.graphics;
			gra.clear();
			gra.lineStyle(1, 0xCCCCCC, 0.5);
			gra.drawRect(0, 0, w + Math.random() * 30 - 30, h + Math.random() * 40 - 40);
		}
		
		private function createField():void
		{
			var format:TextFormat = new TextFormat();
			format.size = 14;
			
			_field = new TextField();
			_field.border = true;
			_field.background = true;
			_field.defaultTextFormat = format;
			_field.x = m;
			_field.y = stage.stageHeight / 3 * 2 - m;
			_field.multiline = true;
			_field.wordWrap = true;
			_field.width = stage.stageWidth - m * 2;
			_field.height = stage.stageHeight / 3;
			addChild(_field);
		}
		
		private function drawSnapshot():void
		{
			var bgColor:uint = 0x010101;
			var rect:Rectangle = _box.getBounds(_photo);
			
			var bmd:BitmapData = new BitmapData(w * 1.5, h * 2, false, bgColor);
			
			var xScale:Number = bmd.width / _box.width;
			var yScale:Number = bmd.height / _box.height;
			var scale:Number = 1;
			if (xScale < yScale)
			{
				scale = xScale;
			}
			else
			{
				scale = yScale;
			}
			var horizontal:Number = (bmd.width - _box.width * scale);
			var vertical:Number = (bmd.height - _box.height * scale);
				
			var matrix:Matrix = new Matrix();
			matrix.tx = -(rect.x);
			matrix.ty = -(rect.y);
			matrix.scale(scale, scale);
			matrix.tx += horizontal / 2;
			matrix.ty += vertical / 2;
			
			_field.text = "rect: " + rect + "\n" + "matrix: " + matrix + "\nscale: " + scale + "\nxScale: " + xScale + "\nyScale: " + yScale
				+ "\nScaled: " + _box.width * scale + " x " + _box.height * scale + "\nbmd: " + bmd.width + " x " + bmd.height
				+ "\nvertical: " + vertical + "\nhorizontal: " + horizontal;
				
			bmd.draw(_photo, matrix);
			
			// Fill non used
			var areaTop:Rectangle = new Rectangle(0, 0, bmd.width, vertical / 2);
			var areaBottom:Rectangle = new Rectangle(0, bmd.height - vertical / 2, bmd.width, vertical / 2);
			var areaLeft:Rectangle = new Rectangle(0, 0, horizontal / 2, bmd.height);
			var areaRight:Rectangle = new Rectangle(bmd.width - horizontal / 2, 0, horizontal / 2, bmd.height);
			
			bmd.fillRect(areaTop, bgColor);
			bmd.fillRect(areaBottom, bgColor);
			bmd.fillRect(areaLeft, bgColor);
			bmd.fillRect(areaRight, bgColor);
			
			_field.appendText("\nareaTop: " + areaTop);
			_field.appendText("\nareaBottom: " + areaBottom);
			_field.appendText("\nareaLeft: " + areaLeft);
			_field.appendText("\nareaRight: " + areaRight);
			
			if (_snap == null)
			{
				_snap = new Bitmap(bmd);
				_snap.x = m;
				_snap.y = m;
				addChild(_snap);
			}
			else
			{
				_snap.bitmapData = bmd;
			}
			
			// Other way achieving the same:
			if (_fill == null)
			{
				_fill = new Shape();
				_fill.x = _snap.x + _snap.width + m;
				_fill.y = m;
				addChild(_fill);
			}
			var gr:Graphics = _fill.graphics;
			gr.clear();
			gr.beginFill(bgColor, 1.0);
			gr.drawRect(0, 0, bmd.width, bmd.height);
			gr.endFill();
			gr.beginBitmapFill(_photo.bitmapData, matrix, false);
			gr.drawRect(horizontal / 2, vertical / 2, _box.width * scale, _box.height * scale);
			gr.endFill();
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawSnapshot();
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				drawBox();
			}
		}
		
		private function onBoxEnterFrame(event:Event):void
		{
			_box.x = stage.mouseX - _box.width / 2;
			_box.y = stage.mouseY - _box.height / 2;
			swapChildrenAt(getChildIndex(_box), numChildren - 1);
		}
	}
}
