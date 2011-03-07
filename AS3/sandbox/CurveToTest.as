/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	
	// Uncompressed sizes (compressed)
	// 18,935 (10754) bytes with default plugins
	// 13,045  (7963) bytes with all plugins disabled
	import com.greensock.TweenLite;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class CurveToTest extends Sprite
    {
		private var _bitmap:Bitmap;
		private var _timer:Timer;
		private var _interval:Number = 2;
		
        public function CurveToTest()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_bitmap = new Bitmap();
			addChild(_bitmap);
			
			_timer = new Timer(_interval * 1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				if (_timer.running)
				{
					_timer.stop();
				}
				else {
					_timer.start();
				}
			}
			trace("onKeyUp. keyCode: " + event.keyCode + ", timer is running: " + _timer.running);
		}
		
		/**
		 * Draw the earlier lines to the bitmap which is faded away.
		 * @param	event
		 */
		private function onTimer(event:TimerEvent):void
		{
			var w:uint = Math.round(stage.stageWidth);
			var h:uint = Math.round(stage.stageHeight);
			var bmd:BitmapData = new BitmapData(w, h, false, 0xFF668822);
			bmd.draw(this);
			
			_bitmap.bitmapData = bmd;
			_bitmap.alpha = 1.0;
			
			var color:uint = Math.random() * 0xFFFFFF;
			var gra:Graphics = graphics;
			gra.clear();
			gra.lineStyle(1, color, 0.5);
			
			for (var i:uint = 0; i < 100; ++i)
			{
				var cX:Number = Math.random() * w;
				var cY:Number = Math.random() * h;
				var aX:Number = Math.random() * w;
				var aY:Number = Math.random() * h;
				gra.curveTo(cX, cY, aX, aY);
			}
			
			TweenLite.to(_bitmap, _interval, { alpha: 0 } );
        }
    }
}
