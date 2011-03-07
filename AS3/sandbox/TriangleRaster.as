/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.*;
	
	import com.foxaweb.utils.Raster;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '300')]
	
	public class TriangleRaster extends Sprite
	{
		private var _timer:Timer;
		private var _bitmap:Bitmap;
		
		private var _sideWidth:uint = 50;
		private var _colour:uint = 0xFF121212;
		
		/**
		 * The upper corner starting point from where the triangles begin.
		 */
		private var _point:Point;
		private var _angle:Number = 0;
		
		public function TriangleRaster()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			_bitmap = new Bitmap(new BitmapData(Math.round(stage.stageWidth), Math.round(stage.stageHeight), true, 0x00123456));
			addChild(_bitmap);
			
			_point = new Point();
		
			_timer = new Timer(50, 80);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}

		private function onTimer(event:TimerEvent):void
		{
			var x0:Number = _point.x;
			var y0:Number = _point.y;
			var x1:Number = _point.x + _sideWidth;
			var y1:Number = _point.y;
			var x2:Number = _point.x + _sideWidth / 2;
			var y2:Number = _point.y + _sideWidth;
			
			//Raster.filledTri(_bitmap.bitmapData, x0, y0, x1, y1, x2, y2, _colour);
			
			// Alternative 1
			var bmd:BitmapData = new BitmapData(_sideWidth, _sideWidth, true, 0x00223344);
			Raster.filledTri(bmd, 0, 0, _sideWidth, 0, _sideWidth / 2, _sideWidth, _colour);
			
			var bm:Bitmap = new Bitmap(bmd);
			bm.x = _point.x;
			bm.y = _point.y;
			bm.rotation = _angle;
			addChild(bm);
			
			
			/*
			// Alternative 2
			var sh:Shape = new Shape();
			triangle(sh.graphics, x0, y0, x1, y1, x2, y2, argb2rgb(_colour));
			_bitmap.bitmapData.draw(sh);
			 */
			
			_point.x += _sideWidth;
			if (_timer.currentCount % 10 == 0)
			{
				_point.x = 0;
				if (_angle == 0)
				{
					_angle = 180;
				}
				else
				{
					_angle = 0;
					_point.y += _sideWidth;
				}
			}
		}
		
		private function triangle(gra:Graphics, x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0xFF6600):void
		{
			gra.clear();
			gra.beginFill(color);
			gra.moveTo(x0, y0);
			gra.lineTo(x1, y1);
			if (_angle != 0)
			{
				y2 -= _sideWidth * 2;
			}
			gra.lineTo(x2, y2);
			gra.lineTo(x0, y0);
			gra.endFill();
		}
		
		private function argb2rgb(argb:uint):uint
		{
			var A:Number = argb >> 24 & 0xFF;
			var R:Number = argb >> 16 & 0xFF;
			var G:Number = argb >> 8 & 0xFF;
			var B:Number = argb & 0xFF;
			return (R << 16 | G << 8 | B);
		}
		
		/**
		 * @see http://blog.soulwire.co.uk/flash/actionscript-3/extract-average-colours-from-bitmapdata/
		 * @param	source
		 * @return
		 */
		public function averageColour( source:BitmapData ):uint
		{
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;
		
			var count:uint = 0;
			var pixel:uint;
		
			for (var i:uint = 0; i < source.width; ++i)
			{
				for (var j:uint = 0; j < source.height; ++j)
				{
					pixel = source.getPixel(i, j);
		
					red += pixel >> 16 & 0xFF;
					green += pixel >> 8 & 0xFF;
					blue += pixel & 0xFF;
		
					++count;
				}
			}
		
			red /= count;
			green /= count;
			blue /= count;
		
			return red << 16 | green << 8 | blue;
		}
		
		/**
		 * @see http://blog.soulwire.co.uk/flash/actionscript-3/extract-average-colours-from-bitmapdata/
		 * @param	source
		 * @param	colours
		 * @return
		 */
		public static function averageColours( source:BitmapData, colours:int ):Array
		{
			var averages:Array = [];
			var columns:int = Math.round( Math.sqrt( colours ) );
		
			var row:int = 0;
			var col:int = 0;
		
			var x:int = 0;
			var y:int = 0;
		
			var w:int = Math.round( source.width / columns );
			var h:int = Math.round( source.height / columns );
			
			var point:Point = new Point();
		
			for (var i:int = 0; i < colours; ++i)
			{
				var rect:Rectangle = new Rectangle( x, y, w, h );
		
				var box:BitmapData = new BitmapData( w, h, false );
				box.copyPixels( source, rect, point );
		
				averages.push( averageColour( box ) );
				box.dispose();
		
				col = i % columns;
		
				x = w * col;
				y = h * row;
		
				if ( col == columns - 1 )
				{
					++row;
				}
			}
		
			return averages;
		}
	}
}
