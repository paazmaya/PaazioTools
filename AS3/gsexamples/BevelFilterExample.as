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
	import com.greensock.plugins.BevelFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the BevelFilter plugin to bevel an item.
	 * <ul>
	 * 		<li> distance : Number [0]</li>
	 * 		<li> angle : Number [0]</li>
	 * 		<li> highlightColor : uint [0xFFFFFF]</li>
	 * 		<li> highlightAlpha : Number [0.5]</li>
	 * 		<li> shadowColor : uint [0x000000]</li>
	 * 		<li> shadowAlpha :Number [0.5]</li>
	 * 		<li> blurX : Number [2]</li>
	 * 		<li> blurY : Number [2]</li>
	 * 		<li> strength : Number [0]</li>
	 * 		<li> quality : uint [2]</li>
	 * 		<li> index : uint</li>
	 * 		<li> addFilter : Boolean [false]</li>
	 * 		<li> remove : Boolean [false]</li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class BevelFilterExample extends Sprite
	{
		private const AMOUNT:uint = 600;
		
		private var _container:Sprite;

        public function BevelFilterExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([BevelFilterPlugin]);
			
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
					var item:DisplayObject = _container.getChildAt(i);
					
					var options:Object = {
						blurX: 20,
						blurY: 20,
						distance: Math.random() * 20,
						angle: Math.atan2(item.y - stage.mouseY, item.x - stage.mouseX) / Math.PI * 180,
						strength: Math.round(Math.random() * 3)
					};
					
					if (item.filters.length != 0)
					{
						options.remove = true;
						options.blurX = 0;
						options.blurY = 0;
					}
					TweenLite.to(item, Math.random() * 2 + 1, { bevelFilter: options } );
				}
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
