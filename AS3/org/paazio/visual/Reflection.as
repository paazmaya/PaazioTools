package org.paazio.visual
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;

	/**
	 * <p>Original written by Dustin Andrew (www.flash-dev.com) 24/01/2006</p>
	 * <p>Modified to suit better the requirements of 3D world.</p>
	 */
	public class Reflection extends Sprite
	{
		
		private var _source:DisplayObject;
		private var _fadeBegin:Number = .3;
		private var _middle:Number = .5;
		private var _fadeEnd:Number = 0;
		private var _skewX:Number = 0;
		private var _scale:Number = 1;
		private var reflection:Bitmap;
		
		public function Reflection(source:DisplayObject, fadeBegin:Number, middle:Number, fadeEnd:Number, skewX:Number, scale:Number)
		{
			super();
			_source = source;
			_fadeBegin = fadeBegin;
			_middle = middle;
			_fadeEnd = fadeEnd;
			_skewX = skewX;
			_scale = scale;
			
			reflection = new Bitmap(new BitmapData(1, 1, true, 0));
			this.addChild(reflection);
			createReflection();
		}
		
		// Create reflection
		private function createReflection(event:Event = null):void
		{
			
			// Reflection
            var bmpDraw:BitmapData = new BitmapData(_source.width, _source.height, true, 0);
            var matSkew:Matrix = new Matrix(1, 0, _skewX, -1 * _scale, 0, _source.height);
            var recDraw:Rectangle = new Rectangle(0, 0, _source.width, _source.height * (2 - _scale));
            var potSkew:Point = matSkew.transformPoint(new Point(0, _source.height));
            matSkew.tx = potSkew.x * -1;
            matSkew.ty = (potSkew.y - _source.height) * -1;
            bmpDraw.draw(_source, matSkew, null, null, recDraw, true);

            // Fade
            var shpDraw:Shape = new Shape();
            var matGrad:Matrix = new Matrix();
            var arrAlpha:Array = new Array(_fadeBegin, (_fadeBegin - _fadeEnd) / 2, _fadeEnd);
            var arrMatrix:Array = new Array(0, 0xFF * _middle, 0xFF);
            matGrad.createGradientBox(_source.width, _source.height, 0.5 * Math.PI);
            shpDraw.graphics.beginGradientFill(GradientType.LINEAR, new Array(0,0,0), arrAlpha, arrMatrix, matGrad)
            shpDraw.graphics.drawRect(0, 0, _source.width, _source.height);
            shpDraw.graphics.endFill();
            bmpDraw.draw(shpDraw, null, null, BlendMode.ALPHA);

            reflection.bitmapData.dispose();
            reflection.bitmapData = bmpDraw;
            reflection.filters = _source.filters;

            this.x = _source.x;
            this.y = (_source.y + _source.height) - 1;
		}
	}
}
