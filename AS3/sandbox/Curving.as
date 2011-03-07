/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '900', height = '700')]

    public class Curving extends Sprite
	{
        public var Asset0:Shape;
		private var t:uint = 0;

        public function Curving()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			Asset0 = new Shape();
			addChild(Asset0);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

		private function onEnterFrame(event:Event):void
		{
			var gra:Graphics = Asset0.graphics;

			var radius:uint = 100; 					// radius of arc
			var thickness:uint = 10;				// thickness of arc
			var color:uint = 0xF15B40;				// arc color
			var alpha:Number = 1;					// arc transparency

			t++;
			if (t > 360)
			{
				t = 0;
			}// positions of animation (0 to 1)
			var speed:Number = 1;			   	// speed of animation

			// arc position on stage
			var centerX:Number = stage.stageWidth / 2 + radius;	// Stage Center X
			var centerY:Number = stage.stageHeight / 2;		  		// Stage Center Y

			// clear old line
			gra.clear();
			// define line style, last parameter makes line with no rounded corners (flash 8)
			gra.lineStyle(thickness, color, alpha);
			// move to centeer
			gra.moveTo(centerX, centerY);

			// reset to 0 at 1
			//t%=1;

			var steps:Number = (t / speed);					// number of steps needed to distance (from 0 to t)
			var tAngle:Number = (t*360);								// current t position in angles
			var iAngle:Number = (tAngle/steps);				   	// increment angle in degrees
			var iRad:Number =  (iAngle/180)*Math.PI;				// increment angle in radians

			// circle inner borders position
			var ox:Number = centerX-Math.cos(0)*radius;
			var oy:Number = centerY-Math.sin(0)*radius;

			// increment angle (in radians) and calculate curve at each iteration
			trace("steps: " + steps);
			for (var i:uint = 1; i <= steps; ++i)
			{
				var a:Number = i*iRad;
				// find middle point
				var midPoint:Number = a-(iRad/2);
				// set initial positon
				var bx:Number = ox+Math.cos(a)*radius;
				var by:Number = oy+Math.sin(a)*radius;
				// set Bezier control point position
				var cx:Number = ox+Math.cos(midPoint)*(radius/Math.cos(iRad/2));
				var cy:Number = oy+Math.sin(midPoint)*(radius/Math.cos(iRad/2));
				// draw curve
				trace(cx, cy, bx, by);
				gra.curveTo(cx, cy, bx, by);
			}
		}
	}
}
