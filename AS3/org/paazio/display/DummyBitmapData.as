package org.paazio.display
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.*;
	import flash.events.*;
	
	import org.paazio.utils.Numbers;
	
	/**
	 * A bitmap data to be used when no official exists.
	 * @author Jukka Paasonen
	 */
	public class DummyBitmapData extends BitmapData
	{
		/**
		 *
		 * @param	w	Width
		 * @param	h	Height
		 * @param	t	Transparent
		 * @param	c	Color (ARGB)
		 * @param	label	Text to place in the center
		 */
		public function DummyBitmapData(w:uint = 800, h:uint = 600, t:Boolean = false, c:Number = 0xCCF39631, label:String = "Empty item")
		{
			super(w, h, t, c);
			//perlinNoise(0, 0, 8, 5, true, true, 7, true);
			
			var sh:Shape = new Shape();
			var gra:Graphics = sh.graphics;
			
			var total:uint = Math.round((w * h) / 1200);
			for (var i:uint = 0; i < total; ++i)
			{
				var xPos:Number = Math.random() * (w - 20) + 10;
				var yPos:Number = Math.random() * (h - 20) + 10;
				var radius:Number = Math.random() * 20 + 2;
				var color:uint = Numbers.rgb(Math.random() * 88 + 127, Math.random() * 88 + 127, Math.random() * 88 + 127);
				gra.lineStyle(1, color);
				gra.drawCircle(xPos, yPos, radius);
			}
			
			draw(sh);
			
			var tf:TextField = new TextField();
			tf.text = label;
			tf.multiline = true;
			
			var mt:Matrix = new Matrix();
			mt.tx = (w - tf.width) / 2;
			mt.ty = (h - tf.height) / 2;
			
			draw(tf, mt);
		}
	}
}
