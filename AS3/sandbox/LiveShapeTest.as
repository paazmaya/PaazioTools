/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	
	import flash.display.*;
	import flash.events.Event;
	
	import LiveShape;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	public class LiveShapeTest extends Sprite
	{
		
		public function LiveShapeTest() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
			var sh:LiveShape = new LiveShape(100, 100, 20);
			sh.x = 100;
			sh.y = 100;
			addChild(sh);
		}
	}
}