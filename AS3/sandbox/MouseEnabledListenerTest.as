/**
 * @mxmlc -debug
 */
package sandbox
{
	import flash.display.Sprite;
	import flash.events.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	/**
	 * ...
	 * @author ...
	 */
	public class MouseEnabledListenerTest extends Sprite
	{
		public function MouseEnabledListenerTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var sp:Sprite = new Sprite();
			sp.mouseEnabled = true;
			sp.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addChild(sp);
			trace("mouseEnabled: " + sp.mouseEnabled + ", hasEventListener: " + sp.hasEventListener(MouseEvent.MOUSE_UP));
			
			sp.mouseEnabled = false;
			trace("mouseEnabled: " + sp.mouseEnabled + ", hasEventListener: " + sp.hasEventListener(MouseEvent.MOUSE_UP));
		}
		
		private function onMouse(event:MouseEvent):void
		{
			// hoplaa
		}
		
	}
	
}
