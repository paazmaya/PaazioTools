package org.paazio.display
{
	import flash.display.*;

	/**
	 * Arc drawing class.
	 * <code>Arc.draw(sprite.graphics, 128, 256, 100, 45, 180);</code>
	 * This class is based on code written by Ric Ewing (www.ricewing.com).
	 * @see http://www.adobe.com/devnet/flash/articles/adv_draw_methods.html.
	 */
	public class Arc
	{
		/**
		 * Draw and arc between the starting angle and the given arc + staring angle.
		 * @param	gra			Graphics of an display object
		 * @param	startX		Arc starting position
		 * @param	startY		Arc starting position
		 * @param	radius		Radius of the circle
		 * @param	arc			The angle of the drawable area
		 * @param	startAngle	Starting from this angle, defaults to zero.
		 */
		public static function draw(gra:Graphics, startX:Number, startY:Number, radius:Number, arc:Number, startAngle:Number = 0):void
		{
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			var cos:Number;
			
			// Move the pen
			gra.moveTo(startX, startY);
		
			// No need to draw more than 360
			if (Math.abs(arc) > 360)
			{
				arc = 360;
			}
		
			numOfSegs = Math.ceil(Math.abs(arc) / 45);
			segAngle = arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (startAngle / 180) * Math.PI;
			cos = (radius / Math.cos(segAngle / 2));
			
			// Calculate the start point
			ax = startX - Math.cos(angle) * radius;
			ay = startY - Math.sin(angle) * radius;
		
			for (var i:int = 0; i < numOfSegs; ++i)
			{
				// Increment the angle
				angle += segAngle;
				
				// The angle halfway between the last and the new
				angleMid = angle - segAngle / 2;
				
				// Calculate the end point
				bx = ax + Math.cos(angle) * radius;
				by = ay + Math.sin(angle) * radius;
				
				// Calculate the control point
				cx = ax + Math.cos(angleMid) * cos;
				cy = ay + Math.sin(angleMid) * cos;

				// Draw out the segment
				gra.curveTo(cx, cy, bx, by);
			}
		}
	}
}
