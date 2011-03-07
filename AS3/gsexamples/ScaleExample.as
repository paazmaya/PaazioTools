/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.ScalePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the Scale plugin to adjust the visibility of an item.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class ScaleExample extends Sprite
	{
		private const AMOUNT:uint = 600;
		
		private var _container:Sprite;

        public function ScaleExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([ScalePlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			drawItems();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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
				sp.addEventListener(MouseEvent.MOUSE_OVER, onBallMouseOver);
				var gra:Graphics = sp.graphics;
				gra.beginFill(Math.random() * 0xFFFFFF);
				gra.drawCircle(0, 0, Math.random() * 20 + 10);
				gra.endFill();
				sp.x = Math.random() * stage.stageWidth;
				sp.y = Math.random() * stage.stageHeight;
				_container.addChild(sp);
			}
		}
		
		private function onBallMouseOver(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			TweenLite.to(sp, Math.random() * 2 + 1, { scale: Math.random() * 2 } );
		}
		
		private function onEnterFrame(event:Event):void
		{
			var n:uint = _container.numChildren - 1;
			var i:uint = Math.round(Math.random() * n);
			
			var sp:Sprite = _container.getChildAt(i) as Sprite;
			TweenLite.to(sp, Math.random() * 2 + 1, { scale: Math.random() * 2 } );
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
