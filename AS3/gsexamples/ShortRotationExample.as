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
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the ShortRotation plugin to rotate the shorter trip.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class ShortRotationExample extends Sprite
	{
		private const AMOUNT:uint = 200;
		
		private var _container:Sprite;
		private var _shortRotate:Boolean = false;

        public function ShortRotationExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([ShortRotationPlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			drawItems();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.CLICK, onClick);
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
				sh.x = Math.random() * stage.stageWidth;
				sh.y = Math.random() * stage.stageHeight;
				
				var radius:Number = Math.random() * 40 + 10;
				var fill:uint = Math.random() * 0xFFFFFF;
				var line:uint = 0xFFFFFF;
				if (fill > line / 2)
				{
					line = 0x000000;
				}
				
				var gra:Graphics = sh.graphics;
				gra.beginFill(fill);
				gra.drawCircle(0, 0, radius);
				gra.endFill();
				gra.beginFill(line, 0.5);
				gra.drawCircle(0, 0, 4);
				gra.endFill();
				gra.lineStyle(2, line, 0.5);
				gra.moveTo(0, 0);
				gra.lineTo(-radius, 0);
				
				_container.addChild(sh);
			}
		}
		
		private function rotate(sh:Shape):void
		{
			var angle:Number = Math.atan2(sh.y - stage.mouseY, sh.x - stage.mouseX) / Math.PI * 180;
			var options:Object = { rotation: angle };
			if (_shortRotate)
			{
				options = { shortRotation: options };
			}
			TweenLite.to(sh, Math.random() + 1, options );
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawItems();
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				_shortRotate = !_shortRotate;
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			var num:uint = _container.numChildren;
			while (num > 0)
			{
				--num;
				rotate(_container.getChildAt(num) as Shape);
			}
		}
    }
}
