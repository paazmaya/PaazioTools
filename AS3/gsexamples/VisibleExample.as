/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.VisiblePlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * An example to tint an item and then set the visibility off.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class VisibleExample extends Sprite
	{
		private const AMOUNT:uint = 400;
		
		private var _container:Sprite;
		
        public function VisibleExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([TintPlugin, VisiblePlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			drawItems();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
				var sh:Shape = new Shape();
				var gra:Graphics = sh.graphics;
				gra.beginFill(Math.random() * 0xFFFFFF);
				gra.drawCircle(0, 0, Math.random() * 20 + 10);
				gra.endFill();
				sh.x = Math.random() * stage.stageWidth;
				sh.y = Math.random() * stage.stageHeight;
				_container.addChild(sh);
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			tweenItem();
		}
		
		private function tweenItem():void
		{
			if (_container.numChildren == 0)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			var index:uint = Math.round(Math.random() * (_container.numChildren - 1));
			var sh:Shape = _container.getChildAt(index) as Shape;
			if (sh.visible)
			{
				if (TweenLite.masterList[sh] == null)
				{
					_container.setChildIndex(sh, _container.numChildren - 1);
					TweenLite.to(sh, 1, { tint: 0xFFFFFF, visible: false } );
				}
			}
			else
			{
				_container.removeChild(sh);
				tweenItem();
			}
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
