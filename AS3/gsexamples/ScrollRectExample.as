/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.ScrollRectPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * An example of the possible use case of the ScrollRect plugin.
	 * <ul>
	 * 		<li> x : Number</li>
	 * 		<li> y : Number</li>
	 * 		<li> width : Number</li>
	 * 		<li> height : Number</li>
	 * 		<li> top : Number</li>
	 * 		<li> bottom : Number</li>
	 * 		<li> left : Number</li>
	 * 		<li> right : Number</li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class ScrollRectExample extends Sprite
	{
		private var _element:Sprite;
		private var _container:Sprite;
		
        public function ScrollRectExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([ScrollRectPlugin]);
			
			_container = new Sprite();
			_container.x = stage.stageWidth / 4;
			_container.y = stage.stageHeight / 4;
			addChild(_container);
			
			_element = new Sprite();
			_container.addChild(_element);
			
			var gra:Graphics = _element.graphics;
			gra.beginFill(0xF44444);
			gra.drawCircle(0, 0, stage.stageWidth / 3);
			gra.endFill();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
		
		private function updateVisual():void
		{
			var rec:Rectangle = _container.scrollRect;
			if (rec == null)
			{
				rec = _container.getBounds(this);
			}
			var gra:Graphics = _container.graphics;
			gra.clear();
			gra.beginFill(0x961D18);
			gra.drawRect(rec.x, rec.y, rec.width, rec.height);
			gra.endFill();
		}
		
		private function onEnterFrame(event:Event):void
		{
			updateVisual();
		}
		
		private function tweenItem():void
		{
			//var rec:Rectangle = new Rectangle(100, 100, 100, 100);
			var rec:Object = { x: 100, y: 100, width: 100, height: 100 };
			TweenLite.to(_container, 2, { scrollRect: rec } );
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				tweenItem();
			}
		}
    }
}
