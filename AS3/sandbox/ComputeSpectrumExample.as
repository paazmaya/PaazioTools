/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.events.*
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]
		
	public class ComputeSpectrumExample extends Sprite
	{
		private var visualizerWidth:Number = stage.stageWidth;
		private var visualizerHeight:Number = stage.stageHeight;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		private var _motionTrails:Sprite;
		private var _finalVisualizerDisplay:Sprite
		
		private var _leftChannelHolder:Sprite;
		private var _leftLine:Sprite;
		private var _leftTrail:Sprite;
		
		private var _rightChannelHolder:Sprite;
		private var _rightLine:Sprite;
		private var _rightTrail:Sprite;
		
		public function ComputeSpectrumExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			_initView();
			
			var context:SoundLoaderContext = new SoundLoaderContext(200, true);
			
			_sound = new Sound();
			_sound.load(new URLRequest('../../public_html/data/01-disturbed-10000_fists-pte96.mp3'), context); // mp3 only
			_sound.addEventListener(IOErrorEvent.IO_ERROR, _handleIOError);
			
			_channel = _sound.play();
			var trans:SoundTransform = _channel.soundTransform;
			trans.volume = .6;
			_channel.soundTransform = trans;
			
			addEventListener(Event.ENTER_FRAME, _enterFrame);
		}
		
		private function _handleIOError(event:IOErrorEvent):void
		{
			_sound.close();
		}
		
		private function _initView():void
		{
			//create hierarchy of left channel clips
			_leftTrail = new Sprite();
			_leftChannelHolder = new Sprite();
			_leftChannelHolder.addChild(_leftTrail);
			
			//create hierarchy of right channel clips
			_rightTrail = new Sprite();
			_rightChannelHolder = new Sprite();
			_rightChannelHolder.addChild(_leftTrail);
				
			//sprite to hold each line and it's trail effect
			_motionTrails = new Sprite();
			_motionTrails.addChild(_leftChannelHolder);
			_motionTrails.addChild(_rightChannelHolder);
		
			//sprite attached to stage that will display the end result of the visualizations
			_finalVisualizerDisplay = new Sprite();
			_finalVisualizerDisplay.x = 0;
			_finalVisualizerDisplay.y = 0;
			
			addChild(_finalVisualizerDisplay);
		}
		
		private function _enterFrame(event:Event):void
		{
			_updateLines();
			_blitTrails()
			_updateStage();
		}
		
		private function _updateLines():void
		{
			var spectrum:ByteArray = new ByteArray();
			var pointWidth:Number = visualizerWidth / 256;
			
			SoundMixer.computeSpectrum(spectrum);
			
			//--------------------- LEFT CHANNEL LINE DRAWING STUFF -------------------------------\\
			//clear the _leftChannelHolder
			if(_leftChannelHolder.numChildren > 0) _leftChannelHolder.removeChildAt(0);
			
			//overwrite _leftLine as a new, empty Sprite
			_leftLine = new Sprite();
			
			//draw the line
			_leftLine.graphics.clear();
			_leftLine.graphics.lineStyle(2, 0x00CC00, 1, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND, 3);
			_leftLine.graphics.moveTo(0, spectrum[0] + visualizerHeight / 2);
			for (var i:uint = 0; i < 256; ++i)
			{
				_leftLine.graphics.lineTo(i * pointWidth, spectrum.readFloat() * 350 + visualizerHeight / 2);
			}
			
			_leftChannelHolder.addChild(_leftLine);
			
			
			//--------------------- RIGHT CHANNEL LINE DRAWING STUFF -------------------------------\\
			//clear the _righttChannelHolder
			if(_rightChannelHolder.numChildren > 0) _rightChannelHolder.removeChildAt(0);
			
			//overwrite _rightLine as a new, empty Sprite
			_rightLine = new Sprite();
			
			//draw the line
			_rightLine.graphics.clear();
			_rightLine.graphics.lineStyle(2, 0x996600, 1, true, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND, 3);
			_rightLine.graphics.moveTo(0, spectrum[0] + visualizerHeight / 2);
			for(i=0; i<256; ++i)
			{
				_rightLine.graphics.lineTo(i * pointWidth, spectrum.readFloat() * 350 + visualizerHeight / 2);
			}
			
			_rightChannelHolder.addChild(_rightLine);
		}
		
		private function _blitTrails():void
		{
			//------------------ LEFT CHANNEL LINE BLITTING/TRAIL STUFF ----------------------\\
			var leftBlitData:BitmapData = new BitmapData(visualizerWidth, visualizerHeight, true, 0x00000000);
			leftBlitData.draw(_leftChannelHolder);
			
			var leftBitmap:Bitmap = new Bitmap(leftBlitData);
			leftBitmap.alpha = .9;
			leftBitmap.y -= 1;
			leftBitmap.x += .5;
			
			if(_leftChannelHolder.numChildren > 1) _leftChannelHolder.removeChildAt(1)
			_leftChannelHolder.addChild(leftBitmap);
			
			
			//------------------ RIGHT CHANNEL LINE BLITTING/TRAIL STUFF ----------------------\\
			var rightBlitData:BitmapData = new BitmapData(visualizerWidth, visualizerHeight, true, 0x00000000);
			rightBlitData.draw(_rightChannelHolder);
			
			var rightBitmap:Bitmap = new Bitmap(rightBlitData);
			rightBitmap.alpha = .9;
			rightBitmap.y += 1;
			rightBitmap.x -= .5;
			
			if(_rightChannelHolder.numChildren > 1) _rightChannelHolder.removeChildAt(1)
			_rightChannelHolder.addChild(rightBitmap);
		}

		private function _updateStage():void
		{
			var viewableBitmapData:BitmapData = new BitmapData(visualizerWidth, visualizerHeight, true, 0x00000000);
			viewableBitmapData.draw(_motionTrails);

			var bf:BlurFilter = new BlurFilter();
			bf.blurX = 0;
			bf.blurY = 2;
				
			var viewableBitmap:Bitmap = new Bitmap(viewableBitmapData);
			viewableBitmap.filters = [bf];

			if(_finalVisualizerDisplay.numChildren > 0) _finalVisualizerDisplay.removeChildAt(0);
			_finalVisualizerDisplay.addChild(viewableBitmap);
		}
	}
}
