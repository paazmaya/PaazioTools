/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	public class UniversalBalance extends Sprite
	{

		public function UniversalBalance()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			var grap:Graphics = graphics;
			grap.beginFill(0xFFFFFF);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 2, stage.stageHeight / 2);
			grap.endFill();



			/*

			var x = stage.stageWidth / 2
			var y = stage.stageHeight / 2
			var r = stage.stageHeight / 2;
			var theta = 45*Math.PI/180;
			var cr = stage.stageHeight / 2 / Math.cos(theta/2);
			var angle = 0;
			var cangle = -theta/2;
			grap.moveTo(stage.stageWidth / 2, stage.stageHeight / 2);
			grap.beginFill(0x000000);
			for (var i=0; i < 4; ++i)
			{
				angle += theta;
				cangle += theta;
				var endX = r*Math.cos (angle);
				var endY = r*Math.sin (angle);
				var cX = cr*Math.cos (cangle);
				var cY = cr*Math.sin (cangle);
				grap.curveTo(x+cX, y+cY, x+endX, y+endY);
			}
			grap.lineTo(stage.stageWidth / 2, 0);
			grap.endFill();





			grap.beginFill(0x000000);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 4, stage.stageHeight / 4);
			grap.endFill();

			grap.beginFill(0xFFFFFF);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 4 * 3, stage.stageHeight / 4);
			grap.endFill();

			grap.beginFill(0xFFFFFF);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 4, 10);
			grap.endFill();

			grap.beginFill(0x000000);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 4 * 3, 10);
			grap.endFill();
			 */
			
			drawArc(grap, 0, 0, 400, 50, 45, true);

			/*
			grap.lineStyle(1, 0x000000);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 2, stage.stageHeight / 2);

			grap.moveTo(stage.stageWidth / 2, 0);
			grap.curveTo(100, 50, stage.stageWidth / 4, stage.stageHeight / 4);

			grap.curveTo(100, 200, stage.stageWidth / 2, stage.stageHeight / 2);

			grap.curveTo(300, 200, stage.stageWidth / 4 * 3, stage.stageHeight / 4 * 3);

			grap.curveTo(300, 350, stage.stageWidth / 2, stage.stageHeight);

			//grap.beginFill(0x000000);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 4, 10);
			//grap.endFill();

			//grap.beginFill(0xFFFFFF);
			grap.drawCircle(stage.stageWidth / 2, stage.stageHeight / 4 * 3, 10);
			//grap.endFill();
			 */

		}

		public function drawArc(gra:Graphics, nX:Number, nY:Number, nRadius:Number, nArc:Number, nStartingAngle:Number = 0, bRadialLines:Boolean = false):void
		{

			// The angle of each of the eight segments is 45 degrees (360 divided by eight),
			// which equals p/4 radians.
			if (nArc > 360)
			{
				nArc = 360;
			}
			nArc = Math.PI / 180 * nArc;
			var nAngleDelta:Number = nArc / 8;

			// Find the distance from the circle's center to the control points
			// for the curves.
			var nCtrlDist:Number = nRadius / Math.cos(nAngleDelta / 2);

			nStartingAngle *= Math.PI / 180;

			var nAngle:Number = nStartingAngle;
			var nCtrlX:Number;
			var nCtrlY:Number;
			var nAnchorX:Number;
			var nAnchorY:Number;

			var nStartingX:Number = nX + Math.cos(nStartingAngle) * nRadius;
			var nStartingY:Number = nY + Math.sin(nStartingAngle) * nRadius;

			if (bRadialLines)
			{
				gra.moveTo(nX, nY);
				gra.lineTo(nStartingX, nStartingY);
			}
			else
			{
				// Move to the starting point, one radius to the right of the circle's center.
				gra.moveTo(nStartingX, nStartingY);
			}

			// Repeat eight times to create eight segments.
			for (var i:Number = 0; i < 8; ++i)
			{

				// Increment the angle by angleDelta (p/4) to create the whole circle (2p).
				nAngle += nAngleDelta;

				// The control points are derived using sine and cosine.
				nCtrlX = nX + Math.cos(nAngle-(nAngleDelta/2))*(nCtrlDist);
				nCtrlY = nY + Math.sin(nAngle-(nAngleDelta/2))*(nCtrlDist);

				// The anchor points (end points of the curve) can be found similarly to the
				// control points.
				nAnchorX = nX + Math.cos(nAngle) * nRadius;
				nAnchorY = nY + Math.sin(nAngle) * nRadius;

				// Draw the segment.
				gra.curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
			}
			if (bRadialLines)
			{
				gra.lineTo(nX, nY);
			}
		}
	}
}
