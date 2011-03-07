package org.paazio.visual
{
	import flash.geom.*;
	import flash.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class Warholizer
	{

		private var _source:Bitmap;
		private var _destination:Bitmap;

		public function Warholizer(source:Bitmap, destination:Bitmap) : void
		{
			_source = source;
			_destination = destination;
		}



		public function extractBitmapData () : void
		{
			var destinationBmd:BitmapData = _destination.bitmapData;
			
			//var outputBMP:Bitmap = new Bitmap(new BitmapData (_source.width*2 + 10, _source.height*2 + 10), "auto", true);

			var sourceRect:Rectangle = new Rectangle(0,0,_source.width, _source.height);

			var blueTransform:ColorTransform = new ColorTransform(1,1,10);
			var yellowTransform:ColorTransform = new ColorTransform(10,10,1);
			var greenTransform:ColorTransform = new ColorTransform(1,10,1);
			var redTransform:ColorTransform = new ColorTransform(10,1,1);

			destinationBmd.copyPixels(_source.bitmapData, sourceRect, new Point(0,0));
			destinationBmd.copyPixels(_source.bitmapData, sourceRect, new Point(0, _source.height + 10));
			destinationBmd.copyPixels(_source.bitmapData, sourceRect, new Point(_source.width + 10, 0));
			destinationBmd.copyPixels(_source.bitmapData, sourceRect, new Point(_source.width + 10, _source.height + 10));

			destinationBmd.colorTransform(new Rectangle(0,0, _source.width, _source.height), blueTransform);
			destinationBmd.colorTransform(new Rectangle(_source.width+10, 0, _source.width, _source.height), yellowTransform);
			destinationBmd.colorTransform(new Rectangle(0,_source.height + 10, _source.width, _source.height), redTransform);
			destinationBmd.colorTransform(new Rectangle(_source.width+10,_source.height+10, _source.width, _source.height), greenTransform);
		}

		public function drawArrow () : Sprite
		{
			var targetSprite:Sprite = new Sprite();
			targetSprite.graphics.beginFill(0x000000);
			targetSprite.graphics.lineTo(10,20);
			targetSprite.graphics.lineTo(0,40);
			targetSprite.graphics.lineTo(0,0);
			targetSprite.graphics.endFill();
			return targetSprite;
		}
	}
}
