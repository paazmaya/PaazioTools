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
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the Bezier plugin with the random control points.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class BezierExample extends Sprite
	{
		private const AMOUNT:uint = 25;
		
		private var _container:Sprite;
		private var _follower:Shape;

        public function BezierExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([BezierPlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			_follower = new Shape();
			_follower.graphics.lineStyle(1, 0x121212);
			_follower.graphics.beginFill(0xFFFEE7);
			_follower.graphics.drawCircle(0, 0, 10);
			_follower.graphics.endFill();
			addChild(_follower);
			
			drawItems();
			
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
				gra.lineStyle(1, 0x8B8C7D);
				gra.beginFill(0x961D18);
				gra.drawCircle(0, 0, 4);
				gra.endFill();
				sh.x = stage.stageWidth / AMOUNT * i;
				sh.y = Math.random() * stage.stageHeight / 2 + stage.stageHeight / 4;
				_container.addChild(sh);
			}
			
			_follower.x = 0;
			_follower.y = _container.getChildAt(0).y;
			
			_container.graphics.clear();
			_container.graphics.lineStyle(2, 0xE3E3C9);
			_container.graphics.moveTo(0, _follower.y);
			
			bezierPoints();
		}
		
		private function bezierPoints():void
		{
			var points:Array = [];
			var num:uint = _container.numChildren;
			for (var i:uint = 0; i < num; ++i)
			{
				var item:DisplayObject = _container.getChildAt(i);
				points.push( { x: item.x, y: item.y } );
			}
			TweenLite.to(_follower, 30, { bezier: points, onUpdate: onBezierUpdate } );
		}
		
		private function onBezierUpdate():void
		{
			var gra:Graphics = _container.graphics;
			gra.lineTo(_follower.x, _follower.y);
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
