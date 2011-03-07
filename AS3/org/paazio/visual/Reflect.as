package org.paazio.visual
{
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;

	/**
	 * Based on http://www.adobe.com/devnet/flash/articles/reflect_class_as3.html
	 * which is made by Ben Pritchard of Pixelfumes 2007
	 * and helped by Mim, Jasper, Jason Merrill.
	 */
	public class Reflect extends Bitmap
	{
		private var original:DisplayObject; // The original object of which the reflection is created.
		private var snapshot:BitmapData; // The BitmapData object that will hold a visual copy of the original.
		private var alphaMap:Bitmap; // Alpha mask, set once, used often.
		private var updateTimer:Timer;
		
		private var options:Object = 
		{
			alpha: 0.5, // the alpha level of the reflection
			ratio: 50, // the ratio opaque color used in the gradient mask
			distance: 0, // the distance the reflection is vertically from the original
			updateTime: 50, // update time interval, -1 for never
			reflectionDropoff: 1,
			width: 10, // these should be overwritten...
			height: 10
		};
	
		public function Reflect(orig:DisplayObject, args:Object) 
		{
			// The original which will be reflected and which will contain the reflection too.
			original = orig;
			
			// Update options.
			options = args;
			
			init();
		}
		
		private function init():void 
		{
			// Create the BitmapData that will hold a snapshot of the Sprite.
			try 
			{
				reDraw();
			}
			catch (e:Error) 
			{
				trace("Reflect init snapshot. " + e.toString());
			}
			
			createAlphaMask();
		
			// Create the BitmapData the will hold the reflection.
			try
			{
				this.bitmapData = snapshot.clone();
				this.scaleY = -1;
				this.y = options.distance + this.height;
			}
			catch (e:Error) 
			{
				trace("Reflect init reflected. " + e.toString());
			}
			updateMaskPosition();
			
			if (options.updateTime > -1)
			{
				updateTimer = new Timer(options.updateTime);
				updateTimer.addEventListener(TimerEvent.TIMER, update);
				updateTimer.start();
			}
		}
		
		private function createAlphaMask():void 
		{
		  	var matrix:Matrix = new Matrix();
			var h:Number;
			if (options.reflectionDropoff <= 0)
			{
				h = options.height;
			}
			else
			{
				h = options.height / options.reflectionDropoff;
			}
			matrix.createGradientBox(options.width, h, (90 / 180) * Math.PI, 0, 0);
			
			try {
				var gradient:Shape = new Shape();
				gradient.graphics.beginGradientFill(
					GradientType.LINEAR, 
					[0xFFFFFF, 0xFFFFFF],
					[options.alpha, 0],
					[0, options.ratio],
					matrix,
					SpreadMethod.PAD
				);  
				gradient.graphics.drawRect(0, 0, options.width, options.height);
				gradient.graphics.endFill();
				gradient.cacheAsBitmap = true;
			}
			catch (e:Error) {
				trace("Reflect createAlphaMask gradient. " + e.toString());
			}
			try {
				var bmpData:BitmapData = new BitmapData(options.width, options.height);
				bmpData.draw(gradient);
			}
			catch (e:Error) {
				trace("Reflect createAlphaMask gradient draw. " + e.toString());
			}
			
			try 
			{
				alphaMap = new Bitmap(bmpData);
				alphaMap.name = "alphaMap";
			}
			catch (e:Error) 
			{
				trace("Reflect createAlphaMask alphaMap. " + e.toString());
			}
		}
		
		public function updateMaskPosition():void 
		{
			alphaMap.x = this.x;
			alphaMap.y = this.y;
			this.mask = alphaMap;
		}
		
		public function reDraw():void 
		{
			// redraws the bitmap reflection - Mim Gamiet [2006]
			try {
				snapshot = new BitmapData(Math.ceil(options.width), Math.ceil(options.height), true, 0x00FFFFFF);
				snapshot.draw(original);
			}
			catch (e:Error) {
				trace("Reflect reDraw. " + e.toString());
			}
		}
		
		private function update(event:TimerEvent):void 
		{
			// Update the reflection to visually match the movie clip
			try {
				reDraw();
				this.bitmapData = snapshot;
			}
			catch (e:Error) {
				trace("Reflect update. " + e.toString());
			}
			updateMaskPosition();
		}
		
		public function destroy():void 
		{
			// provides a method to remove the reflection
			try {
				snapshot.dispose();
				if (updateTimer.running) {
					updateTimer.stop();
				}
			}
			catch (e:Error) {
				trace("Reflect destroy. " + e.toString());
			}
		}
	}
}