/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.setTimeout;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class TextLineMetricsExample extends Sprite
	{
        private var gutter:int = 20;
        private var label:TextField;
		
		private var text:String = "Before looking at specific workflows, it is important to have context as to the roles identified as being involved in the production of a rich Internet application.\n\nAcross a range of projects, the extent to which each of these roles is required will vary, but generally speaking you'll need to create design artwork, consider the layout of the application screens, plan for navigation, movement, and interaction within the application and finally create something that can be deployed to the end user. These are the core roles that I'll discuss when considering workflows in this article.";

        public function TextLineMetricsExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
            label = new TextField();
            label.background = true;
            label.backgroundColor = 0xFFFFFF;
            label.multiline = true;
            label.wordWrap = true;
			label.type = TextFieldType.INPUT;
            label.text = text;
			label.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            addChild(label);
			
            stage.addEventListener(Event.RESIZE, onResize);
			
            onResize(new Event(Event.RESIZE));
        }

        private function showMetrics():void
		{
			var len:uint = label.numLines;
			for (var i:uint = 0; i < len; ++i)
			{
				var metrics:TextLineMetrics = label.getLineMetrics(i);
				trace("metrics (" + i + "): "
					+ "[ascent:" + metrics.ascent
					+ ", descent:" + metrics.descent
					+ ", leading:" + metrics.leading
					+ ", width:" + metrics.width
					+ ", height:" + metrics.height
					+ ", x:" + metrics.x
					+ "]");
			}
        }

        private function onResize(event:Event):void
		{
            draw();
        }
		
        private function onKeyUp(event:KeyboardEvent):void
		{
            showMetrics();
        }

        private function draw():void
		{
            label.x = gutter;
            label.y = gutter;
            label.width = stage.stageWidth - (gutter * 2);
            label.height = stage.stageHeight - (gutter * 2);
        }
    }
}
