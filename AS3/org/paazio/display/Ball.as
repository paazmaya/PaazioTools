package org.paazio.display
{
	import flash.display.Shape;

	/**
	 * A round ball.
	 * @see http://www.hs.fi/fingerpori/1135231648133
	 */
	public class Ball extends Shape
	{
		public var vx : Number = 0;
		public var vy : Number = 0;

		/**
		 * A ball.
		 * @param	color
		 * @param	radius
		 */
		public function Ball(color:uint = 0x000000, radius:Number = 8)
		{
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
	}
}
