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
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the DropShadowFilter plugin to drop a shadow to an item.
	 * <ul>
	 * 		<li> distance : Number [0]</li>
	 * 		<li> angle : Number [45]</li>
	 * 		<li> color : uint [0x000000]</li>
	 * 		<li> alpha :Number [0]</li>
	 * 		<li> blurX : Number [0]</li>
	 * 		<li> blurY : Number [0]</li>
	 * 		<li> strength : Number [1]</li>
	 * 		<li> quality : uint [2]</li>
	 * 		<li> inner : Boolean [false]</li>
	 * 		<li> knockout : Boolean [false]</li>
	 * 		<li> hideObject : Boolean [false]</li>
	 * 		<li> index : uint</li>
	 * 		<li> addFilter : Boolean [false]</li>
	 * 		<li> remove : Boolean [false]</li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class DropShadowFilterExample extends Sprite
	{
		private const AMOUNT:uint = 200;
		
		private var _container:Sprite;

        public function DropShadowFilterExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([DropShadowFilterPlugin]);
			
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
				sp.addEventListener(MouseEvent.MOUSE_OVER, onTriangleMouseOver);
				var s:Number = Math.random() * 40 + 30;
				var r:Number = Math.random() * Math.PI;
				
				var gra:Graphics = sp.graphics;
				gra.beginFill(Math.random() * 0xFFFFFF);
				drawTriangle(gra, s, r);
				gra.endFill();
				sp.x = Math.random() * stage.stageWidth;
				sp.y = Math.random() * stage.stageHeight;
				_container.addChild(sp);
			}
		}
		
		private function drawTriangle(gra:Graphics, side:Number, rotation:Number):void
		{
			var angle:Number = Math.PI / 3;

			var bx:Number = Math.cos(angle - rotation) * side;
			var by:Number = Math.sin(angle - rotation) * side;
			var cx:Number = Math.cos( -rotation) * side;
			var cy:Number = Math.sin( -rotation) * side;

			var centroidX:Number = (cx + bx) / 3;
			var centroidY:Number = (cy + by) / 3;

			gra.moveTo(-centroidX, -centroidY);
			gra.lineTo(cx - centroidX, cy - centroidY);
			gra.lineTo(bx - centroidX, by - centroidY);
			gra.lineTo(-centroidX, -centroidY);
		}
		
		private function onTriangleMouseOver(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			
			var options:Object = {
				blurX: Math.random() * 10,
				blurY: Math.random() * 10,
				distance: sp.height / 4,
				color: Math.random() * 0xFFFFFF,
				inner: Math.random() > 0.5 ? true : false,
				alpha: Math.random() * 0.5 + 0.2
			};
			TweenLite.to(sp, Math.random() * 2 + 1, {
				dropShadowFilter: options, onComplete: onCircleShadowComplete, onCompleteParams: [sp]
			} );
		}
		
		private function onCircleShadowComplete(sp:Sprite):void
		{
			TweenLite.to(sp, 1, {
				dropShadowFilter: { blurX: 0, blurY: 0, distance: 0, remove: true }
			} );
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
