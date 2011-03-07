/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
	import flash.text.TextField;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class LoaderInfoExample extends Sprite
	{

        public function LoaderInfoExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var tx:TextField =  new TextField();
			tx.y = 10;
			tx.x = 10;
			tx.width = 500;
			tx.height = 300;
			tx.multiline = true;
			tx.wordWrap = true;
			tx.border = true;
			tx.background = true;
			tx.text = "stage.loaderInfo content:\n";
			addChild(tx);
			
            var info:LoaderInfo = stage.loaderInfo;
			var i:*;
			for each(i in info)
			{
				tx.appendText(i + " = " + info[i] + "\n");
			}
			
            info = loaderInfo;
			tx.appendText("\nthis.loaderInfo content:\n");
			for each(i in info)
			{
				tx.appendText(i + " = " + info[i] + "\n");
			}
        }
    }
}
