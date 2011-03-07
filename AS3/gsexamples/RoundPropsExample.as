/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenMax;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the RoundProps plugin with the random bezier control points.
	 * RoundProps requires TweenMax.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class RoundPropsExample extends Sprite
	{
		private const AMOUNT:uint = 25;
		
		private var _container:Sprite;
		private var _follower:Shape;
		private var _roundValues:Boolean = false;

        public function RoundPropsExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([
				BezierPlugin,
				RoundPropsPlugin
			]);
			
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
			_container.graphics.clear();
			
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
				sh.y = Math.random() * stage.stageHeight;
				_container.addChild(sh);
			}
			
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
			
			var color:uint = 0xE3E3C9;
			if (_roundValues)
			{
				color = 0x961D18;
			}
			
			var initY:Number = stage.stageHeight / 2;
			if (points[0].y != null)
			{
				initY = points[0].y;
			}
			
			_container.graphics.lineStyle(4, color, 0.6);
			_container.graphics.moveTo(0, initY);
			
			_follower.x = 0;
			_follower.y = initY;
			
			var options:Object = { bezier: points, onUpdate: onBezierUpdate };
			if (_roundValues)
			{
				options.roundProps = ["x", "y"];
			}
			TweenMax.to(_follower, 20, options );
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
			else if (event.keyCode == Keyboard.ENTER)
			{
				_roundValues = !_roundValues;
				bezierPoints();
			}
		}
    }
}
