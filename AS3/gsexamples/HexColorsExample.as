/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
	import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.HexColorsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * An example to tween the components of a color.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class HexColorsExample extends Sprite
	{
		private const AMOUNT:uint = 400;
		private const INTERVAL:uint = 100;
		
		private var _container:Sprite;
		private var _timer:Timer;
		
        public function HexColorsExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([HexColorsPlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			drawItems();
			
			_timer = new Timer(INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
        }
		
		private function drawItems():void
		{
			var num:uint = _container.numChildren;
			while (num > 0)
			{
				--num;
				_container.removeChildAt(num);
			}
			
			for (var i:uint = 0; i < AMOUNT; ++i)
			{
				var sp:Sprite = new Sprite();
				
				var gra:Graphics = sp.graphics;
				gra.beginFill(0);
				gra.drawCircle(0, 0, Math.random() * 20 + 10);
				gra.endFill();
				sp.x = Math.random() * stage.stageWidth;
				sp.y = Math.random() * stage.stageHeight;
				
				var ct:ColorTransform = new ColorTransform();
				ct.color = 0xF4EEF4;
				sp.transform.colorTransform = ct;
				
				_container.addChild(sp);
			}
		}
		
		private function onTimer(event:TimerEvent):void
		{
			var index:uint = Math.round(Math.random() * (_container.numChildren - 1));
			var sp:Sprite = _container.getChildAt(index) as Sprite;
			_container.setChildIndex(sp, _container.numChildren - 1);
			var ct:ColorTransform = sp.transform.colorTransform;
			TweenLite.to(ct, 2, {
				hexColors: { color: Math.random() * 0xFFFFFF, alphaOffset: Math.random() * 510 - 255 },
				onUpdate: onUpdateColor,
				onUpdateParams: [sp, ct]
			} );
		}
		
		private function onUpdateColor(sp:Sprite, ct:ColorTransform):void
		{
			sp.transform.colorTransform = ct;
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawItems();
			}
		}
    }
}
