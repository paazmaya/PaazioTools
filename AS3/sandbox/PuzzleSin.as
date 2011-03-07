/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;

	[SWF( backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300' )]

	public class PuzzleSin extends Sprite
	{
		private var _width:Number = 400;
		private var _height:Number = 400;
		
		/**
		 * The height of ONE side of the wave (the total height is double this, because the wave arcs downward)
		 */
		private var _amplitude:Number = 20;
		
		private var _waveLength:Number = 66;
		
		
		private var _mask:Sprite;
		
		private var _original:Bitmap;

		/**
		 * The frequency of the wave i.e. how many full sin waves to draw.
		 */
		private var _wavesPerSide:uint = 3;

		public function PuzzleSin()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			
			_original = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight));
			_original.bitmapData.perlinNoise(4, 7, 2, 9, true, true);
			
			var w:uint = 10;
			var h:uint = 10;
			_width = stage.stageWidth / w;
			_height = stage.stageHeight / h;
			for (var i:uint = 0; i < w; ++i)
			{
				for (var j:uint = 0; j < h; ++j)
				{
					var left:Boolean = (i == 0) ? true : false;
					var right:Boolean = (i == (w - 1)) ? true : false;
					var top:Boolean = (j == 0) ? true : false;
					var bottom:Boolean = (j == (h - 1)) ? true : false;
					var sp:Sprite = createPiece(new Point(_width * i, _height * j), left, right, top, bottom);
					sp.name = "mask_" + i + "_" + j;
					
					var bmd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00121212);
					var cont:Sprite = new Sprite();
					cont.addChild(_original);
					cont.addChild(sp);
					cont.mask = sp;
					
					bmd.draw(cont);
					
					var bm:Bitmap = new Bitmap(bmd);
					bm.x = (stage.stageWidth - _width) * Math.random();
					bm.y = (stage.stageHeight - _height) * Math.random();
					addChild(bm);
				}
			}
		}
		
		/**
		 * Draw a mask to be used for a puzzle piece.
		 * True parametres are meant for direct line.
		 * @param	initPos
		 * @param	left
		 * @param	right
		 * @param	top
		 * @param	bottom
		 * @return
		 */
		private function createPiece(initPos:Point, left:Boolean = false, right:Boolean = false, top:Boolean = false, bottom:Boolean = false):Sprite
		{
			var sp:Sprite = new Sprite();
			
			var hor:Number = _wavesPerSide / _width * Math.PI * 2;
			var ver:Number = _wavesPerSide / _height * Math.PI * 2;
			var amplitude:Number = _width / 25;
			
			var gr:Graphics = sp.graphics;
			//gr.lineStyle(2, 0xFFFFFF);
			gr.moveTo(initPos.x, initPos.y);
			gr.beginFill(0x121212);
			
			var i:uint = 0;
			var j:uint = 0;
			var offset:Number = 0; // Math.PI;
			if (!top)
			{
				while (i < _width)
				{
					gr.lineTo(initPos.x + i, initPos.y + Math.sin(i * hor + offset) * amplitude);
					++i;
				}
			}
			else
			{
				i = _width;
				gr.lineTo(initPos.x + i, initPos.y);
			}
			if (!right)
			{
				while (j < _height)
				{
					gr.lineTo(initPos.x + Math.sin(j * ver + offset) * amplitude + _width, initPos.y + j);
					++j;
				}
			}
			else
			{
				j = _height;
				gr.lineTo(initPos.x + _width, initPos.y + j);
			}
			if (!bottom)
			{
				while (i > 0)
				{
					gr.lineTo(initPos.x + i, initPos.y + Math.sin(i * hor + offset) * amplitude + _height);
					--i;
				}
			}
			else
			{
				i = 0;
				gr.lineTo(initPos.x + i, initPos.y + _height);
			}
			if (!left)
			{
				while (j > 0)
				{
					gr.lineTo(initPos.x + Math.sin(j * ver + offset) * amplitude, initPos.y + j);
					--j;
				}
			}
			else
			{
				j = 0;
				gr.lineTo(initPos.x, initPos.y + j);
			}
			gr.endFill();
			
			return sp;
		}

	}
}

