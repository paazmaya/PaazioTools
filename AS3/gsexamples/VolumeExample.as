/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.VolumePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the Volume plugin with the random points.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class VolumeExample extends Sprite
	{
		private const AMOUNT:uint = 25;
		private const MEDIA:String = "http://paazio.nanbudo.fi/data/Dream.Theater-Awake-03-Innocence.Faded.short.mp3";
		
		private var _container:Sprite;
		private var _follower:Shape;
		private var _sound:Sound;

        public function VolumeExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([VolumePlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			_follower = new Shape();
			_follower.graphics.lineStyle(1, 0x121212);
			_follower.graphics.beginFill(0xFFFEE7);
			_follower.graphics.drawCircle(0, 0, 10);
			_follower.graphics.endFill();
			addChild(_follower);
			
			drawItems();
			
			_sound = new Sound();
			_sound.addEventListener(Event.COMPLETE, onSoundComplete);
			_sound.load(new URLRequest(MEDIA));
        }

		private function drawItems():void
		{
			_container.graphics.clear();
			_container.graphics.lineStyle(2, 0xE3E3C9);
			_container.graphics.moveTo(0, stage.stageHeight / 2);
			
			var num:uint = _container.numChildren;
			while (num > 0)
			{
				--num;
				_container.removeChildAt(num);
			}
			
			for (var i:uint = 0; i < AMOUNT; ++i)
			{
				var sh:Shape = new Shape();
				var gra:Graphics = sh.graphics;
				gra.lineStyle(1, 0x8B8C7D);
				gra.beginFill(0x961D18);
				gra.drawCircle(0, 0, 4);
				gra.endFill();
				sh.x = stage.stageWidth / AMOUNT * (i + 1);
				sh.y = Math.random() * stage.stageHeight;
				_container.addChildAt(sh, i);
			}
			
			_follower.x = 0;
			_follower.y = stage.stageHeight / 2;
		}
		
		private function onSoundComplete(event:Event):void
		{
			var channel:SoundChannel = _sound.play();
			var st:SoundTransform = channel.soundTransform;
			st.volume = 0.5;
			channel.soundTransform = st;
			
			var num:uint = _container.numChildren;
			var interval:Number = _sound.length / num / 1000;
			
			for (var i:uint = 0; i < num; ++i)
			{
				var sh:Shape = _container.getChildAt(i) as Shape;
				var vol:Number = 1 - sh.y / stage.stageHeight;
				var delay:Number = i * interval;
				TweenLite.to(channel, interval,
					{ volume: vol, onUpdate: onVolumeUpdate, onUpdateParams: [channel], delay: delay, overwrite: 0 }
				);
			}
		}
		
		private function onVolumeUpdate(channel:SoundChannel):void
		{
			_follower.x = channel.position / _sound.length * stage.stageWidth;
			_follower.y = (1 - channel.soundTransform.volume) * stage.stageHeight;
			
			var gra:Graphics = _container.graphics;
			gra.lineTo(_follower.x, _follower.y);
		}
    }
}
