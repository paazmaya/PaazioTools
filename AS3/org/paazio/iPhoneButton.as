package org.paazio {
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;

	/**
	 * The iPhoneButton creates a button presenting the late trend of copying the success of iPhone from Apple.
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.1.9
	 */
	public class iPhoneButton extends Sprite
	{
		private var color:uint = 0x009933;
		private var w:Number = 120;
		private var h:Number = 80;
		private var r:Number = 20;
		private var drawBorder:Boolean = false;

		public function iPhoneButton(color:uint, w:Number = 120, h:Number = 80, r:Number = 20, drawBorder:Boolean = true) {
			this.color = color;
			this.w = w;
			this.h = h;
			this.r = r;
			this.drawBorder = drawBorder;
			
			drawButton();
		}

		public function drawButton():void 
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, Math.PI / 2);

			var base:Shape = new Shape();
			base.graphics.beginFill(color);
			base.graphics.drawRoundRect(0, 0, w, h, r, r);
			base.graphics.endFill();
			addChild(base);

			if (drawBorder) {
				var border:Shape = new Shape();
				border.graphics.lineStyle(1, 0xffffff, 1);
				border.graphics.lineGradientStyle(GradientType.LINEAR, [0xffffff, 0xffffff, 0xffffff], [1, 0.3, 1], [0, 128, 255], matrix);
				border.graphics.drawRoundRect(1, 1, w - 2, h - 2, r, r);
				border.blendMode = BlendMode.OVERLAY;
				addChild(border);
			}


			var glowTop:Shape = new Shape();
			glowTop.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xffffff], [1, 0.2], [0, 128], matrix);
			glowTop.graphics.drawEllipse(-w / 2, -h / 2, w * 2, h);
			glowTop.graphics.endFill();
			glowTop.blendMode = BlendMode.OVERLAY;
			addChild(glowTop);

			var masker:Shape = new Shape();
			masker.graphics.beginFill(0);
			masker.graphics.drawRoundRect(0, 0, w, h, r, r);
			masker.graphics.endFill();
			addChild(masker);
			glowTop.mask = masker;

			var glowBottom:Shape = new Shape();
			glowBottom.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xffffff], [0, 1], [224, 255], matrix);
			glowBottom.graphics.drawRoundRect(0, 0, w, h, r, r);
			glowBottom.graphics.endFill();
			glowBottom.blendMode = BlendMode.OVERLAY;
			addChild(glowBottom);

			var filter:DropShadowFilter = new DropShadowFilter(2, 90, 0x000000, 0.7);
			base.filters = [filter];
		}
	}
}
