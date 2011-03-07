/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '600')]

	public class SankukaiCircles extends Sprite
	{
		public var circles:Shape;

		private var ratio1:Number = 2.4;
		private var ratio2:Number = 1.7;
		private var margin:Number = 10;

		private var red:uint = 0xEA1919;
		private var white:uint = 0xFFFFFF;

		public function SankukaiCircles()
		{
			stage.quality = StageQuality.MEDIUM;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			circles = new Shape();
			circles.name = "circles";
			addChild(circles);
			
			draw();
		}

		private function draw():void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;

			var gra:Graphics = circles.graphics;

			gra.beginFill(red);
			gra.drawCircle(w / 2, h / 2, Math.max(w / 2, h / 2) - margin);
			gra.endFill();

			gra.beginFill(white);
			gra.drawCircle(w / 3, h / 3, Math.max(w / 4, h / 4) - margin);
			gra.endFill();

			gra.beginFill(red);
			gra.drawCircle(w / 4, h / 4, Math.max(w / 8, h / 8) - margin);
			gra.endFill();
		}
	}
}
