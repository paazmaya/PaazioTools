/**
 * @mxmlc -target-player=10.0.0 -source-path=D:/AS3libs -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.media.*;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import tsuka.VideoConnector;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '1200', height = '900')]
	
	/**
	 * ...
	 * @author Juga
	 */
	public class VideoConnectorMaskTest extends Sprite
	{
		private const MEDIA:String = "O:/www/paazio.nanbudo.fi/15kumite.South-Africa.2007-08-subtitled.mp4";
		private const AMOUNT:uint = 25;
		private const INTERVAL:uint = 25;
		
		private var _connector:VideoConnector;
		private var _mask:Sprite;
		private var _bytedata:ByteArray;
		private var _timer:Timer;
		
		public function VideoConnectorMaskTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			_bytedata = new ByteArray();
			
			_connector = new VideoConnector(800, 600);
			addChild(_connector);
			
			_mask = new Sprite();
			addChild(_mask);
			
			var i:uint = 0;
			while (i < AMOUNT)
			{
				var sh:Shape = new Shape();
				sh.name = "sh_" + i;
				_mask.addChild(sh);
				++i;
			}
			
			_connector.mask = _mask;
			
			_connector.volume = 0.2;
			stage.addEventListener(Event.RESIZE, _connector.onStageResize);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_timer = new Timer(INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			var area:Rectangle = _connector.getBounds(this);
			
			var sh:Shape = _mask.getChildAt(0) as Shape;
			//trace(sh.name);
			_mask.setChildIndex(sh, _mask.numChildren - 1);
			sh.alpha = 1.0;
			
			var gr:Graphics = sh.graphics;
			gr.clear();
			gr.beginFill(0x3377DD, 1.0);
			
			var s:ByteArray = _bytedata;
			var n:uint = 256;
			var w:Number = area.width / n;
			var h:Number = area.height / n;
			
			// If you set the stretchFactor  value to 0, data is sampled at 44.1 KHz; with a value of 1, data is sampled at 22.05 KHz; with a value of 2, data is sampled 11.025 KHz; and so on.
			var factor:uint = 1;
			if (_connector.currentMeta.audiosamplerate != null)
			{
				factor = Math.round(44100 / _connector.currentMeta.audiosamplerate) - 1;
			}
			//trace(factor);
			SoundMixer.computeSpectrum(s, true, factor);
			
			var i:uint = 0;
			/*
			while (i < n)
			{
				w = s.readFloat() * area.width / 2;
				gr.drawRect(area.x + area.width / 2 - w, area.y + h * i, w, h);
				++i;
			}
			i = 0;
			while (i < n)
			{
				w = s.readFloat() * area.width / 2;
				gr.drawRect(area.x + area.width / 2, area.y + h * i, w, h);
				++i;
			}
			*/
			while (i < n)
			{
				h = s.readFloat() * area.height / 2;
				gr.drawRect(area.x + w * i, area.y + area.height / 2 - h, w, h);
				++i;
			}
			i = 0;
			while (i < n)
			{
				h = s.readFloat() * area.height / 2;
				gr.drawRect(area.x + w * i, area.y + area.height / 2, w, h);
				++i;
			}
			gr.endFill();
			TweenLite.to(sh, INTERVAL / 1000 * AMOUNT, { alpha: 0 } );
			
			_connector.mask = _mask;
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			trace("Before. scale: " + _connector.scale + ", time: " + _connector.time);
			if (event.keyCode == Keyboard.ENTER)
			{
				_connector.load(MEDIA);
				_connector.timePosition = 0.4;
			}
			else if (event.keyCode == Keyboard.UP)
			{
				_connector.scale += 0.1;
			}
			else if (event.keyCode == Keyboard.DOWN)
			{
				_connector.scale -= 0.1;
			}
			else if (event.keyCode == Keyboard.LEFT)
			{
				_connector.seek(-5);
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				_connector.seek(5);
			}
			else if (event.keyCode == Keyboard.SPACE)
			{
				_connector.togglePause();
				trace("_connector.playing: " + _connector.playing);
			}
			else if (event.keyCode == Keyboard.HOME)
			{
				trace("trackinfo start ----------");
				traceData(_connector.currentMeta.trackinfo);
				trace("trackinfo end ----------");
			}
			else if (event.keyCode == Keyboard.END)
			{
				trace("seekpoints start ----------");
				traceData(_connector.currentMeta.seekpoints);
				trace("seekpoints end ----------");
			}
			trace("After. scale: " + _connector.scale + ", time: " + _connector.time);
		}
		
		private function traceData(data:Object):void
		{
			var seekpoints:Array = data as Array;
			var len:uint = seekpoints.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var obj:Object = seekpoints[i];
				for (var key:Object in obj)
				{
					trace("traceData[" + i + "]: " + key + " (" + typeof obj[key] + ") = " + obj[key]);
				}
			}
		}
	}
	
}
