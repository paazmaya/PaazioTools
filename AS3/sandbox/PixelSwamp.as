/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.text.*;
	import flash.system.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	import org.paazio.ProgressiveLoader;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '1000', height = '375')]
	
	public class PixelSwamp extends Sprite
	{
		
		
		[Embed(source = "../assets/2842053827_d8eeb8a373.jpg", mimeType = "image/jpeg")]
		private var ImageOne:Class;
		[Embed(source = "../assets/2842932256_7126d56177.jpg", mimeType = "image/jpeg")]
		private var ImageTwo:Class;

		private var image1:String = "../assets/2842053827_d8eeb8a373.jpg";
		private var image2:String = "../assets/2842932256_7126d56177.jpg";
		//private var image1:String = "http://farm4.static.flickr.com/3249/2842053827_d8eeb8a373.jpg";
		//private var image2:String = "http://farm4.static.flickr.com/3159/2842932256_7126d56177.jpg";

		//private var bm1:Bitmap;
		//private var bm2:Bitmap;
		private var donePoints:Vector.<Point>;
			
		private var loaded:Array = [];
				
		public function PixelSwamp()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			donePoints = new Vector.<Point>();
			/*
			createCont(image1, 0);
			
			
			createCont(image2, 500);
			 */
			var bm1:Bitmap = new ImageOne() as Bitmap;
			bm1.name = image1;
			addChild(bm1);
			
			var bm2:Bitmap = new ImageTwo() as Bitmap;
			bm2.name = image2;
			bm2.x = 500;
			addChild(bm2);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			/*
			_bm1 = new Bitmap(new BitmapData(500, 375, true, 0x00000000));
			addChild(_bm1);
			
			_bm2 = new Bitmap(new BitmapData(500, 375, true, 0x00000000));
			_bm2.x = 500;
			addChild(_bm2);
			 */
		}
		
		private function createCont(url:String, xPos:Number):void
		{
			
			var context:LoaderContext = new LoaderContext();
			//context.checkPolicyFile = true;
			
			var loader:ProgressiveLoader = new ProgressiveLoader();
			loader.name = url;
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.load(new URLRequest(url), context);
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			var counter:uint = 0;
			var point:Point;
			while (!isNotUsedPoint(point))
			{
				point = new Point(random(0, 500), random(0, 375));
				++counter;
			}
			donePoints.push(point);
			trace(point + ", checked against " + counter);
			
			var bm1:Bitmap = getChildByName(image1) as Bitmap;
			var bm2:Bitmap = getChildByName(image2) as Bitmap;
			
			var px1:uint = bm1.bitmapData.getPixel32(point.x, point.y);
			var px2:uint = bm2.bitmapData.getPixel32(point.x, point.y);
			
			bm1.bitmapData.setPixel(point.x, point.y, px2);
			bm2.bitmapData.setPixel(point.x, point.y, px1);
		}
		
		private function isNotUsedPoint(point:Point):Boolean
		{
			if (point == null)
			{
				return false;
			}
			var len:uint = donePoints.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var check:Point = donePoints[i];
				if (point.equals(check))
				{
					return false;
				}
			}
			return true;
		}
				
		
		private function random(min:int, max:int):int
		{
			return Math.round(Math.random() * (max - min) + min);
		}
		
		private function onLoaderComplete(event:Event):void
		{
			trace("onLoaderComplete");
			var loader:ProgressiveLoader = event.target as ProgressiveLoader;
			loaded.push(loader.name);
			
			var bmp:BitmapData = new BitmapData(500, 375, true, 0x33000000);
			bmp.draw(loader);
			
			var bm:Bitmap = new Bitmap(bmp);
			bm.name = name;
			addChild(bm);
			
			if (loaded.length > 1)
			{
				bm.x = 500;
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onLoaderError(event:ErrorEvent):void
		{
			trace("onLoaderError");
		}
	
	}
}
