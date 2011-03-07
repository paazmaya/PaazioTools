/**
 * @mxmlc -target-player=10.0.0
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
	public class NoiseTest extends Sprite
	{
		private var _bm:Bitmap;
		private var _field:TextField;
		private var _noise:Object = {
			randomSeed: 3,
			low: 60,
			high: 180,
			channelOptions: 7,
			grayScale: false
		};
		
		public function NoiseTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var m:uint = 60;
			var w:uint = Math.round(stage.stageWidth);
			var h:uint = Math.round(stage.stageWidth - m);
			
			_bm = new Bitmap(new BitmapData(w, h, true, 0x00121212));
			_bm.y = m;
			addChild(_bm);
			
			var format:TextFormat = new TextFormat("Verdana", 12, 0x121212);
			_field = new TextField();
			_field.defaultTextFormat = format;
			_field.multiline = true;
			_field.wordWrap = true;
			_field.background = true;
			_field.width = w;
			_field.height = m;
			addChild(_field);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			updateNoise();
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			trace(event.keyCode);
			switch(event.keyCode)
			{
				case Keyboard.UP :
					_noise.low += 1;
					break;
				case Keyboard.DOWN :
					_noise.low -= 1;
					break;
					
				case Keyboard.PAGE_UP :
					_noise.high += 1;
					break;
				case Keyboard.PAGE_DOWN :
					_noise.high -= 1;
					break;
					
				case Keyboard.HOME :
					_noise.randomSeed += 1;
					break;
				case Keyboard.END :
					_noise.randomSeed -= 1;
					break;
				
				case 71 : // g
					_noise.grayScale = !Boolean(_noise.grayScale);
					break;
					
				case Keyboard.F1 :
					_noise.channelOptions = BitmapDataChannel.RED; // 1
					break;
				case Keyboard.F2 :
					_noise.channelOptions = BitmapDataChannel.GREEN; // 2
					break;
				case Keyboard.F3 :
					_noise.channelOptions = BitmapDataChannel.BLUE; // 4
					break;
				case Keyboard.F4 :
					_noise.channelOptions = BitmapDataChannel.RED | BitmapDataChannel.GREEN;
					break;
				case Keyboard.F5 :
					_noise.channelOptions = BitmapDataChannel.GREEN | BitmapDataChannel.BLUE;
					break;
				case Keyboard.F6 :
					_noise.channelOptions = BitmapDataChannel.RED | BitmapDataChannel.BLUE;
					break;
				case Keyboard.F7 :
					_noise.channelOptions = BitmapDataChannel.RED | 
						BitmapDataChannel.GREEN | BitmapDataChannel.BLUE; // 7
					break;
			}
			
			updateNoise();
		}
		
		private function updateNoise():void
		{
			_bm.bitmapData.noise(
				_noise.randomSeed, _noise.low, _noise.high,
				_noise.channelOptions, _noise.grayScale
			);
			
			var texts:Array = [];
			for (var key:String in _noise)
			{
				texts.push(key + ":" + _noise[key]);
			}
			_field.text = texts.join(", ");
		}
	}
}
