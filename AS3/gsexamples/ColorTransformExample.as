/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * An example of the usage of the GlowFilter plugin to glow an item.
	 * <ul>
	 * 		<li><code> tint (or color) : uint</code> - Color of the tint. Use a hex value, like 0xFF0000 for red.</li>
	 * 		<li><code> tintAmount : Number</code> - Number between 0 and 1. Works with the "tint" property and indicats how much of an effect the tint should have. 0 makes the tint invisible, 0.5 is halfway tinted, and 1 is completely tinted.</li>
	 * 		<li><code> brightness : Number</code> - Number between 0 and 2 where 1 is normal brightness, 0 is completely dark/black, and 2 is completely bright/white</li>
	 * 		<li><code> exposure : Number</code> - Number between 0 and 2 where 1 is normal exposure, 0, is completely underexposed, and 2 is completely overexposed. Overexposing an object is different then changing the brightness - it seems to almost bleach the image and looks more dynamic and interesting (subjectively speaking).</li>
	 * 		<li><code> redOffset : Number</code></li>
	 * 		<li><code> greenOffset : Number</code></li>
	 * 		<li><code> blueOffset : Number</code></li>
	 * 		<li><code> alphaOffset : Number</code></li>
	 * 		<li><code> redMultiplier : Number</code></li>
	 * 		<li><code> greenMultiplier : Number</code></li>
	 * 		<li><code> blueMultiplier : Number</code></li>
	 * 		<li><code> alphaMultiplier : Number</code> </li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class ColorTransformExample extends Sprite
	{
		private const AMOUNT:uint = 600;
		private const INTERVAL:uint = 25;
		
		private var _container:Sprite;
		private var _timer:Timer;
		
        public function ColorTransformExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			
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
		
		private function onTimer(event:TimerEvent):void
		{
			var index:uint = Math.round(Math.random() * (_container.numChildren - 1));
			var sh:Shape = _container.getChildAt(index) as Shape;
			var options:Object = {
				tint: Math.random() * 0xFFFFFF,
				exposure: Math.random() * 2,
				brightness: Math.random() * 2
			};
			
			TweenLite.to(sh, 1, { colorTransform: options } );
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
