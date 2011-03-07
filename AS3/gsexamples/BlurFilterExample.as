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
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the BlurFilter plugin to blur an item.
	 * <ul>
	 * 		<li> blurX : Number [0]</li>
	 * 		<li> blurY : Number [0]</li>
	 * 		<li> quality : uint [2]</li>
	 * 		<li> index : uint</li>
	 * 		<li> addFilter : Boolean [false]</li>
	 * 		<li> remove : Boolean [false]</li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class BlurFilterExample extends Sprite
	{
		private const AMOUNT:uint = 200;
		
		private var _container:Sprite;

        public function BlurFilterExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
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
				var sp:Sprite = new Sprite();
				sp.addEventListener(MouseEvent.MOUSE_OVER, onCircleMouseOver);
				var gra:Graphics = sp.graphics;
				gra.beginFill(Math.random() * 0xFFFFFF);
				gra.drawCircle(0, 0, Math.random() * 20 + 10);
				gra.endFill();
				sp.x = Math.random() * stage.stageWidth;
				sp.y = Math.random() * stage.stageHeight;
				_container.addChild(sp);
			}
		}
		
		private function onCircleMouseOver(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			
			var options:Object = {
				blurX: Math.random() * 40,
				blurY: Math.random() * 40
			};
			TweenLite.to(sp, Math.random() * 2 + 1, {
				blurFilter: options, onComplete: onCircleBlurComplete, onCompleteParams: [sp]
			} );
		}
		
		private function onCircleBlurComplete(sp:Sprite):void
		{
			TweenLite.to(sp, 1, { blurFilter: { blurX: 0, blurY: 0, remove: true} } );
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
