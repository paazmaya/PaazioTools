/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
	import flash.filters.BitmapFilterQuality;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * An example of the usage of the GlowFilter plugin to glow an item.
	 * <ul>
	 * 		<li> color : uint [0x000000]</li>
	 * 		<li> alpha :Number [0]</li>
	 * 		<li> blurX : Number [0]</li>
	 * 		<li> blurY : Number [0]</li>
	 * 		<li> strength : Number [1]</li>
	 * 		<li> quality : uint [2]</li>
	 * 		<li> inner : Boolean [false]</li>
	 * 		<li> knockout : Boolean [false]</li>
	 * 		<li> index : uint</li>
	 * 		<li> addFilter : Boolean [false]</li>
	 * 		<li> remove : Boolean [false]</li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class GlowFilterExample extends Sprite
	{
		private const AMOUNT:uint = 200;
		
		private var _container:Sprite;
		
        public function GlowFilterExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			drawItems();
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
			
			var mat:Matrix = new Matrix();
			mat.tx = sp.width / 2;
			mat.ty = sp.height / 2;
			var bmd:BitmapData = new BitmapData(Math.ceil(sp.width), Math.ceil(sp.height), true, 0x00123456);
			bmd.draw(sp, mat);
			var color:uint = bmd.getPixel(bmd.width / 2, bmd.height / 2);
			
			var options:Object = {
				alpha: Math.random() * 0.8 + 0.2,
				blurX: Math.random() * 20,
				blurY: Math.random() * 20,
				color: color,
				inner: Math.random() > 0.5 ? true : false,
				knockout: Math.random() > 0.5 ? true : false,
				quality: BitmapFilterQuality.HIGH,
				strength: Math.random() * 20
			};
			TweenLite.to(sp, Math.random() * 2 + 1, {
				glowFilter: options, onComplete: onCircleGlowComplete, onCompleteParams: [sp]
			} );
		}
		
		private function onCircleGlowComplete(sp:Sprite):void
		{
			TweenLite.to(sp, 1, { glowFilter: { blurX: 0, blurY: 0, remove: true } } );
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
