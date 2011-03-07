package sandbox
{
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class LiveShape extends Shape
	{
		private var _timer:Timer;
		private var _width:Number;
		private var _height:Number;
		private var _corner:Number;
		
		/**
		 * Create rounded corner shape.
		 * @param	w	Width
		 * @param	h	Height
		 * @param	r	Corner radius
		 */
		public function LiveShape(w:Number, h:Number, r:Number)
		{
			_width = w;
			_height = h;
			_corner = r;
			
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onAdded(event:Event):void
		{
			_timer.start();
		}
		
		private function onRemoved(event:Event):void
		{
			_timer.stop();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			var colors:Array = [random(0x121212, 0x131313), random(0xF2F2F2, 0xF3F3F3)];
			var alphas:Array = [random(0.4, 0.6), random(0.8, 1.0)];
			var ratios:Array = [random(25, 50), random(210, 230)];
			
			var gra:Graphics = graphics;
			gra.clear();
			gra.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios);
			gra.drawRoundRect(0, 0, _width, _height, _corner, _corner);
			gra.endFill();
		}
		
		private function random(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
	}
}
