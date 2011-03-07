/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.ui.Mouse;

	import org.paazio.visual.Reflect;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '900', height = '700')]

	public class ReflectTest extends Sprite
	{
		private var image:String = "ItPuzzlesMe1.jpg";

		private var loader:Loader;
		private var original:Bitmap;
		private var reflect:Reflect;

		public function ReflectTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			if (loaderInfo.parameters.image != undefined)
			{
				image = String(loaderInfo.parameters.image);
			}
			loadImage(image);
		}

		private function addReflection():void
		{
			var args:Object = {
				alpha: 0.5, // the alpha level of the reflection
				ratio: 50, // the ratio opaque color used in the gradient mask
				distance: 0, // the distance the reflection is vertically from the original
				updateTime: -1, // update time interval, -1 for never
				reflectionDropoff: 1,
				width: original.width,
				height: original.height
			};
			reflect = new Reflect(original, args);
			//reflect.x = original.x + original.width;
			reflect.y = original.y + original.height;
			this.addChild(reflect);
			trace("reflect.x: " + reflect.x + ", reflect.y: " + reflect.y);
		}

		private function loadImage(url:String):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
			loader.load(new URLRequest(url));
		}

		private function onImageLoaded(event:Event):void
		{
			trace("Image loaded.");
			original = event.target.loader.content as Bitmap;
			original.smoothing = true;
			original.scaleX = 0.5;
			original.scaleY = 0.5;
			original.x = 20;
			original.y = 20;
			this.addChild(original);
			addReflection();
		}

		private function onImageError(event:IOErrorEvent):void
		{
			trace("Unable to load image: " + image);
		}
	}
}
