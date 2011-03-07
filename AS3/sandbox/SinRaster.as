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
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '900', height = '500')]
	
	public class SinRaster extends Sprite
	{
		
		private var _timer:Timer;
		private var _bitmap:Bitmap;
		
		private var _step:uint = 5;
		private var _amplitude:uint = 10;
		private var _colour:uint = 0xFF121212;
		private var _point:Point;
		
		private var _start:uint = 0;
		
		public function SinRaster()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			_bitmap = new Bitmap(new BitmapData(Math.round(stage.stageWidth), Math.round(stage.stageHeight), true, 0x00123456));
			addChild(_bitmap);
			
			Raster.aaCircle(_bitmap.bitmapData, 100, 100, 44, _colour);
			Raster.circle(_bitmap.bitmapData, 200, 100, 44, _colour);
			Raster.filledTri(_bitmap.bitmapData, 100, 200, 100, 200, 200, 150, _colour);
			Raster.triangle(_bitmap.bitmapData, 300, 200, 400, 200, 350, 300, _colour);
			Raster.quadBezier(_bitmap.bitmapData, 100, 300, 50, 50, 200, 200, _colour, 4);
			Raster.aaLine(_bitmap.bitmapData, 100, 30, 400, 10, _colour);
			Raster.line(_bitmap.bitmapData, 100, 60, 400, 30, _colour);
			Raster.cubicBezier(_bitmap.bitmapData, 100, 400, 300, 300, 500, 300, 700, 400, _colour, 600);
			
			_point = new Point(100, 100);
		
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			var dummy:Shape = new Shape();
			dummy.x = 100;
			dummy.y = 100;
			addChild(dummy);
			_start = getTimer();
			//TweenLite.to(dummy, 6, { x: "+600", y: "+100", onUpdate: onTweenUpdate, onUpdateParams: [dummy] } );
		}
		
		private function onTweenUpdate(target:Shape):void
		{
			var x0:Number = _point.x;
			var y0:Number = _point.y;
			var x1:Number = target.x;
			var y1:Number = Sine.easeIn(getTimer() - _start, 100, target.y, 6000);
			Raster.line(_bitmap.bitmapData, x0, y0, x1, y1, _colour);
			_point.x = x1;
			_point.y = y1;
		}
		
		private function onTimer(event:TimerEvent):void
		{
			var x0:Number = _point.x;
			var y0:Number = _point.y;
			var x1:Number = 0;
			var y1:Number = 0;
			var bmd:BitmapData = _bitmap.bitmapData;
			
			for (var i:uint = 0; i < _step; ++i)
			{
				y1 = Sine.easeInOut(i, y0, y0 + _step, _step);
				//y1 = _amplitude * Math.sin( ( ( x1 / (x0 + _step) ) * ( Math.PI * _step ) ) + i );
				Raster.line(bmd, x0, y0, x1, y1, _colour);
				++x1;
				y0 = y1;
			}
			
			_bitmap.bitmapData = bmd;
			_point.x = x1;
			_point.y = y1;
		}
	}
}
