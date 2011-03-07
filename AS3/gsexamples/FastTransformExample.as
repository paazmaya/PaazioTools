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
	import com.greensock.plugins.FastTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the FastTransform plugin to perform better.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class FastTransformExample extends Sprite
	{
		private const AMOUNT:uint = 200;
		
		private var _container:Sprite;
		private var _fastTransfrom:Boolean = false;

        public function FastTransformExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([FastTransformPlugin]);
			
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
			var num:uint = _container.numChildren;
			for (var i:uint = 0; i < num; ++i)
			{
				if (Math.random() * 4 > 3)
				{
					var sh:Shape = _container.getChildAt(i) as Shape;
					if (sh != null)
					{
						var xPos:Number = Math.random() * stage.stageWidth;
						var yPos:Number = Math.random() * stage.stageHeight;
						var scale:Number = Math.random() * 2.0;
						var options:Object = { x: xPos, y: yPos, scaleX: scale, scaleY: scale };
						if (_fastTransfrom)
						{
							options = { fastTransform: options };
						}
						TweenLite.to(sh, Math.random() * 2 + 1, options );
					}
				}
			}
			_container.swapChildrenAt(num - 1, Math.floor(Math.random() * (num - 2)));
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawItems();
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				_fastTransfrom = !_fastTransfrom;
			}
		}
    }
}
