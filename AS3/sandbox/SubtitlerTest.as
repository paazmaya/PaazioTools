/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.geom.Rectangle;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.filters.BlurFilter;
	import flash.system.Capabilities;
	
	import tsuka.VideoConnector;
	import org.paazio.Subtitler;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '700', height = '500')]
	
	public class SubtitlerTest extends Sprite
	{
		private var videoFile:String = "O:/www/paazio.nanbudo.fi/videos-moved-to-vimeo.com/kissamies2006-11-12.mp4";
		private var subtitleFile:String = "O:/www/paazio.nanbudo.fi/paaziofiles/kissamies2006-11-12.srt";

		private var movie:VideoConnector;
		private var subtitler:Subtitler;
		private var subtitleField:TextField;
		private var slider:Sliding;

		public function SubtitlerTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			movie = new VideoConnector(Math.round(stage.stageWidth), Math.round(stage.stageHeight));
			addChild(movie);
			movie.load(videoFile);

			createSubtitleField();
			
			if (subtitleFile != "")
			{
				getSubtitles();
				slider = new Sliding();
				addChild(slider);
			}
		}
		
		
		private function createSubtitleField():void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.font = "Arial";
			fmt.size = 12;
			fmt.color = 0xFFFFFF;
			fmt.align = TextFormatAlign.CENTER;
			
			subtitleField = new TextField();
			subtitleField.defaultTextFormat = fmt;
			subtitleField.htmlText = "Hoplaa";
			subtitleField.multiline = true;
			subtitleField.selectable = false;
			subtitleField.wordWrap = true;
			subtitleField.width = stage.stageWidth - 2;
			subtitleField.height = 40;
			subtitleField.y = stage.stageHeight - 42;
			subtitleField.x = 1;
			
			subtitleField.border = true;
			addChild(subtitleField);
		}
		
		private function getSubtitles():void
		{
			tracer("Loading subtitles: " + subtitleFile);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onSubtitleEvent);
			loader.addEventListener(Event.OPEN, onSubtitleEvent);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.load(new URLRequest(subtitleFile));
		}
		
		private function onSubtitleEvent(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			if (event.type == Event.COMPLETE)
			{
				var data:String = String(loader.data);
				tracer("Subtitles loaded. " + data);
				subtitler = new Subtitler(data, subtitleField);
			}
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			tracer("onSecurityErrorEvent: " + event.toString());
		}

		private function onAsyncError(event:AsyncErrorEvent):void
		{
			tracer("onAsyncErrorEvent: " + event.toString());
		}

		private function onIOError(event:IOErrorEvent):void
		{
			tracer("onIOErrorEvent: " + event.toString());
		}
		
		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			tracer("onHttpStatus: " + event.toString());
		}

		private function tracer(msg:Object):void
		{
			trace(msg.toString());
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", msg.toString());
			}
		}
	}
}
