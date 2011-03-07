/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class BitmapDataExample extends Sprite
	{
        private var url:String = "assets/Apina.jpg";
        private var size:uint = 339;

        public function BitmapDataExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			
            configureAssets();
        }

        private function configureAssets():void
		{
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

            var request:URLRequest = new URLRequest(url);
            loader.x = size * numChildren;
            loader.load(request);
            addChild(loader);
        }

        private function duplicateImage(original:Bitmap):Bitmap {
            var image:Bitmap = new Bitmap(original.bitmapData.clone());
            image.x = size * numChildren;
            addChild(image);
            return image;
        }

        private function completeHandler(event:Event):void
		{
            var loader:Loader = Loader(event.target.loader);
            var image:Bitmap = Bitmap(loader.content);

            var duplicate:Bitmap = duplicateImage(image);
            var bitmapData:BitmapData = duplicate.bitmapData;
            var sourceRect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
            var destPoint:Point = new Point();
            var operation:String = ">=";
            var threshold:uint = 0xCCCCCCCC;
            var color:uint = 0xFFFFFF00;
            var mask:uint = 0x000000FF;
            var copySource:Boolean = true;

            bitmapData.threshold(bitmapData,
                                 sourceRect,
                                 destPoint,
                                 operation,
                                 threshold,
                                 color,
                                 mask,
                                 copySource);
        }

        private function ioErrorHandler(event:IOErrorEvent):void
		{
            trace("Unable to load image: " + url);
        }
    }
}
