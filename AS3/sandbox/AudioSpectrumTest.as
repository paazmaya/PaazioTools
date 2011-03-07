/**
 * @mxmlc -target-player=10.0 -debug -source-path=O:/www/Tsuka_SVN/trunk/actionscript3
 *
 * Spectrum by Grant Skinner. Jul 9, 2009
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import tsuka.VideoConnector;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]
	
	public class AudioSpectrumTest extends Sprite
	{
		public static const BASS_COUNT:uint = 24;
		
		private var soundChannel:SoundChannel;
		private var spectrum:ByteArray;
		private var bars:Array;
		private var holder:Sprite;
		
		private var vizBmp:BitmapData;
		private var dispBmp:BitmapData;
		private var pt:Point;
		private var blurF:BlurFilter;
		
		private var dispMap:Sprite;
		private var dmF:DisplacementMapFilter;
		
		private var barCount:uint;
		private var rvel:Number=0;
		
		private var vConnector:VideoConnector;
		
		public function AudioSpectrumTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			vConnector = new VideoConnector(300, 200);
			vConnector.load("assets/kamnisko_sedlo2007-05-11.mp4");
			addChild(vConnector);
			
			spectrum = new ByteArray();
			
			setup();
			
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		private function setup():void
		{
			bars = [];
			holder = new Sprite();
			//addChild(holder);
			holder.x = holder.y = 250;
			
			barCount = (512-BASS_COUNT*2)>>2;
			
			for (var i:uint=0; i<barCount*2; ++i)
			{
				var h:Sprite = new Sprite();
				h.rotation = (i+0.5)/barCount*180;
				holder.addChild(h);
				var bar:Sprite = new Sprite();
				h.addChild(bar);
				bar.graphics.beginFill(0xFFFFFF,1);
				bar.graphics.drawRect(-60,10,1,80);
				bars.push(bar);
			}
			
			
			vizBmp = new BitmapData(600,600,false,0);
			dispBmp = vizBmp.clone();
			
			pt = new Point();
			blurF = new BlurFilter(16,16,2);
			
			addChild(new Bitmap(vizBmp));
			
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(0,0xFFFFFF,1);
			border.graphics.drawRect(0,0,499,499);
			addChild(border);
			
			/*
			
			var dot:Sprite = new Sprite();
			dot.graphics.beginFill(0xFFFFFF,1);
			dot.graphics.drawCircle(holder.x,holder.y,80);
			addChild(dot);
			
			dispMap = new Sprite();
			//addChild(dispMap);
			var gradMtx:Matrix = new Matrix();
			gradMtx.createGradientBox(600,600,0,0,0);
			var vertGrad:Sprite = new Sprite();
			vertGrad.graphics.beginGradientFill("linear",[0,0xFF00],[1,1],[0,255],gradMtx);
			vertGrad.graphics.drawRect(0,0,600,600);
			dispMap.addChild(vertGrad);
			
			gradMtx.rotate(Math.PI/2);
			var horizGrad:Sprite = new Sprite();
			horizGrad.graphics.beginGradientFill("linear",[0,0xFF0000],[1,1],[0,255],gradMtx);
			horizGrad.graphics.drawRect(0,0,600,600);
			horizGrad.blendMode = "add";
			dispMap.addChild(horizGrad);
			
			dispBmp.perlinNoise(16,16,2,1,true,false);
			dispBmp.draw(dispMap,dispMap.transform.matrix,new ColorTransform(1,1,1,1));
			dmF = new DisplacementMapFilter(dispBmp,pt,1,2,-50,-50);
			*/
		}
		
		
		private function tick(p_evt:Event):void
		{
			var s:ByteArray = spectrum;
			SoundMixer.computeSpectrum(s, true, 1);
			
			var level:Number = 0;
			var i:uint;
			var bar:Sprite;
			
			// left bass:
			var lBass:Number=0;
			for (i = 0; i < BASS_COUNT; ++i)
			{
				lBass += s.readFloat();
			}
			
			// left channels:
			for (i = 0; i < barCount; ++i)
			{
				level = (s.readFloat() + s.readFloat()) * (i + 15) / 4 + 0.02 + i / 500;
				bar = bars[i];//bars[((i>=BAR_COUNT/2)?BAR_COUNT*1.5-i-1:i)];
				bar.scaleY += (level - bar.scaleY) / 5;
			}
			
			// right bass:
			var rBass:Number=0;
			for (i = 0; i < BASS_COUNT; ++i)
			{
				lBass += s.readFloat();
			}
			
			// right channels:
			for (i = 0; i < barCount; ++i)
			{
				level = (s.readFloat()+s.readFloat())*(i+15)/4+0.02+i/500;
				bar = bars[i+barCount];//bars[((i>=BAR_COUNT/2)?BAR_COUNT*1.5-i-1:i)];
				bar.scaleY += (level - bar.scaleY) / 5;
			}
			
			
			//rvel += (((soundChannel.rightPeak + soundChannel.leftPeak) * 3 - 1) - rvel) / 10;
			//holder.rotation += rvel;
			holder.visible = true;
			
			//vizBmp.fillRect(vizBmp.rect,0);
			vizBmp.colorTransform(vizBmp.rect,new ColorTransform(0.88,0.93,0.97,1));
			vizBmp.draw(holder,holder.transform.matrix,new ColorTransform(1,1,1,Math.min(1,0.05+(lBass+rBass)/50)));
			
			vizBmp.applyFilter(vizBmp,vizBmp.rect,pt,blurF);
			//vizBmp.threshold(vizBmp,vizBmp.rect,pt,">",0xFF110000,0xFFFFFF);
			
			//vizBmp.applyFilter(vizBmp,vizBmp.rect,pt,dmF);
			
		}
		
		
	}
}
