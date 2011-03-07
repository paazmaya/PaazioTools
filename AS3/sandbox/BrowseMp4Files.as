/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class BrowseMp4Files extends Sprite
    {
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _video:Video;
		
		private var _files:Vector.<String>;
		
        public function BrowseMp4Files()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_connection = new NetConnection();
			_connection.client = {};
			_connection.connect(null);
			
			_stream = new NetStream( _connection );
			_stream.client = {};
			_stream.bufferTime = 6;
			
			_video = new Video( 640, 480 );
			_video.x = (stage.stageWidth - _video.width) / 2;
			_video.y = (stage.stageHeight - _video.height) / 2;
			_video.attachNetStream(_stream);
			_video.smoothing = true;
			addChild(_video);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function resizeVideo(w:Number, h:Number):void
		{
			_video.width = w;
			_video.height = h;
			_video.x = (stage.stageWidth - _video.width) / 2;
			_video.y = (stage.stageHeight - _video.height) / 2;
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				_stream.togglePause();
			}
		}
		

    }
}
