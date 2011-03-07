/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	import com.anttikupila.utils.*;

	/**
	 *
	 */
	public class ProgressiveImageLoad extends Sprite
	{
		/**
		 *
		 * @default
		 */
		public var imageData:ByteArray;

		/**
		 *
		 * @default
		 */
		public var jpegStream:JPGSizeExtractor;

		/**
		 *
		 * @default
		 */
		public var loader:Loader;

		// Progressive Image Loading
		// create by Ted Patrick ted@adobe.com

		// and then extended to get the jpeg size by using Antti Kupilas stuff

		/**
		 *
		 * @default
		 */
		private var imageUrl:String = "http://farm3.static.flickr.com/2389/2315608893_3d3db8a3c0.jpg";

		/**
		 *
		 */
		public function ProgressiveImageLoad()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			imageData = new ByteArray();
			
			loader = new Loader();
			addChild( loader );
			
			// JPGSizeExtractor extends URLStream
			jpegStream = new JPGSizeExtractor();
			jpegStream.addEventListener( JPGSizeExtractor.PARSE_COMPLETE, sizeHandler );
			jpegStream.addEventListener( JPGSizeExtractor.PARSE_FAILED, failHandler );
			jpegStream.addEventListener( ProgressEvent.PROGRESS, imageStreamProgress );
			jpegStream.addEventListener( Event.COMPLETE, imageStreamComplete );
			jpegStream.debug = true;
			jpegStream.extractSize( imageUrl, false );
		}

		/**
		 *
		 * @param event
		 */
		protected function failHandler( event:Event ):void
		{
			trace( "Size could not be obtained, file was not according to JFIF specification" );
		}

		/**
		 *
		 * @param event
		 */
		protected function sizeHandler( event:Event ):void
		{
			trace( "SIZE: " + event.target.width + " x " + event.target.height );
		}

		/**
		 *
		 * @param event
		 */
		private function imageStreamComplete( event:Event ):void
		{
			if ( jpegStream.connected )
			{
				jpegStream.readBytes( imageData, imageData.length );
				jpegStream.close();
			}

			loader.unload();
			loader.loadBytes( imageData );
		}

		/**
		 *
		 * @param event
		 */
		private function imageStreamProgress( event:Event ):void
		{
			if ( jpegStream.bytesAvailable == 0 )
			{
				return
			}

			processImageData();
		}

		/**
		 *
		 */
		private function processImageData():void
		{
			// if connected, read all the bytes that have been loaded into the aggregate bytearray
			if ( jpegStream.connected )
			{
				jpegStream.readBytes( imageData, imageData.length );
			}
			loader.unload();
			loader.loadBytes( imageData );
		}
	}
}
