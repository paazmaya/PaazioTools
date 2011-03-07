/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.system.Capabilities;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.SoundTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the Volume plugin with the random points.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class SoundTransformExample extends Sprite
	{
		private const TWEEN_TIME:Number = 1;
		private const MEDIA:String = "http://paazio.nanbudo.fi/data/Disturbed-Criminal.mp4";
		
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _container:Shape;
		private var _bytedata:ByteArray;

        public function SoundTransformExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([SoundTransformPlugin]);
			
			trace("version: " + Capabilities.version);
			
			_container = new Shape();
			addChild(_container);
			
			_bytedata = new ByteArray();
			
			_connection = new NetConnection();
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_connection.connect(null);
		}
		
		private function connectStream():void
		{
			_stream = new NetStream(_connection);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_stream.bufferTime = 4;
			// In order to be able to use the spectrum data, policy file is needed
			_stream.checkPolicyFile = true;
			
			var st:SoundTransform = _stream.soundTransform;
			st.volume = 0.5;
			_stream.soundTransform = st;
			
			_stream.play(MEDIA);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			var st:SoundTransform = _stream.soundTransform;
			var options:Object;
			
			if (event.keyCode == Keyboard.LEFT && event.shiftKey)
			{
				options = { leftToLeft: "-0.2" };
			}
			else if (event.keyCode == Keyboard.RIGHT && event.shiftKey)
			{
				options = { leftToLeft: "+0.2" };
			}
			else if (event.keyCode == Keyboard.LEFT && !event.shiftKey)
			{
				options = { pan: "-0.1" };
			}
			else if (event.keyCode == Keyboard.RIGHT && !event.shiftKey)
			{
				options = { pan: "+0.1" };
			}
			else if (event.keyCode == Keyboard.UP)
			{
				options = { volume: "+0.1" };
			}
			else if (event.keyCode == Keyboard.DOWN)
			{
				options = { volume: "-0.1" };
			}
			
			if (options != null)
			{
				TweenLite.to(_stream, TWEEN_TIME, { soundTransform: options, onComplete: onTweenComplete } );
			}
		}
		
		private function onTweenComplete():void
		{
			var st:SoundTransform = _stream.soundTransform;
			trace("onTweenComplete. volume: " + st.volume + ", pan: " + st.pan + ", leftToLeft: " + st.leftToLeft + ", leftToRight: " + st.leftToRight + ", rightToLeft: " + st.rightToLeft + ", rightToRight: " + st.rightToRight);
		}
		
		private function onEnterFrame(event:Event):void
		{
			var percent:Number = _stream.bytesLoaded / _stream.bytesTotal;
			if (percent != 1)
			{
				trace("percent: " + percent);
			}
			var st:SoundTransform = _stream.soundTransform;
			
			var xPos:Number = 0;
			var yPos:Number = 0;
			var w:Number = 0;
			var h:Number = 40;
			var gr:Graphics = _container.graphics;
			gr.clear();
			
			// Left -> Right
			xPos = stage.stageWidth / 2 - stage.stageWidth / 2 * st.leftToLeft;
			yPos = 100;
			w = stage.stageWidth / 2 - xPos + stage.stageWidth / 2 * st.leftToRight;
			gr.beginFill(0xFF3366, 0.6);
			gr.drawRect(xPos, yPos, w, h);
			gr.endFill();
			
			// Right -> Left
			xPos = stage.stageWidth / 2 * (1 - st.rightToLeft);
			yPos = 200;
			w = stage.stageWidth / 2 - xPos + stage.stageWidth / 2 * st.rightToRight;
			gr.beginFill(0xFF4488, 0.6);
			gr.drawRect(xPos, yPos, w, h);
			gr.endFill();
			
			// Pan
			xPos = stage.stageWidth / 2 + st.pan * stage.stageWidth / 2;
			yPos = 300;
			gr.beginFill(0x88FF66, 0.6);
			gr.moveTo(0, yPos + h / 2);
			gr.lineTo(xPos, yPos);
			gr.lineTo(stage.stageWidth, yPos + h / 2);
			gr.lineTo(xPos, yPos + h);
			gr.lineTo(0, yPos + h / 2);
			gr.endFill();
			
			// Volume
			h = stage.stageHeight / 2 * st.volume;
			yPos = stage.stageHeight - h;
			gr.beginFill(0x9966FF, 0.6);
			gr.drawRect(0, yPos, stage.stageWidth, h);
			gr.endFill();
			
			// Axis
			gr.beginFill(0);
			gr.drawRect(stage.stageWidth / 2 - 1, 0, 2, stage.stageHeight);
			gr.drawRect(0, stage.stageHeight / 2 - 1, stage.stageWidth, 2);
			gr.endFill();
			
			var s:ByteArray = _bytedata;
			var n:uint = 512;
			var sHeight:Number = stage.stageHeight / 2;
			w = stage.stageWidth / n;
			// If you set the stretchFactor value to 0, data is sampled at 44.1 KHz;
			// with a value of 1, data is sampled at 22.05 KHz;
			// with a value of 2, data is sampled 11.025 KHz; and so on.
			SoundMixer.computeSpectrum(s, false, 1);
			gr.beginFill(0xF4F4F4, 0.4);
			for (var i:uint = 0; i < n; ++i)
			{
				h = s.readFloat() * sHeight;
				gr.drawRect(w * i, stage.stageHeight - h, w, h);
			}
			gr.endFill();
		}
		
		private function onAsyncError(event:AsyncErrorEvent):void
		{
			trace("onAsyncErrorEvent: " + event.toString());
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			trace("onIOErrorEvent: " + event.toString());
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			//trace("onNetStatusEvent: " + event.toString());
			trace("onNetStatusEvent. event.info.code: " + event.info.code);
			if (event.info.code == "NetConnection.Connect.Success")
			{
				connectStream();
			}
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			trace("onSecurityErrorEvent: " + event.toString());
		}
    }
}
