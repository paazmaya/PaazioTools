/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextLine;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
    public class TextBlock_createTextLineExample extends Sprite
	{
        private var lineWidth:Number = 300;
		private var textBlock:TextBlock;
		
        public function TextBlock_createTextLineExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
            var str:String = "I am a TextElement, (التشريع) created from a String and assigned " +
            "to the content property of a TextBlock. The createTextLine() method " +
            "then created these lines, 300 pixels wide, for display. سلطنة عمان دولة عربية اسلامية مستقلة ذات سيادة تامة عاصمتها مسق";

            var fontDescription:FontDescription = new FontDescription("Arial");
			
            var format:ElementFormat = new ElementFormat(fontDescription, 16, 0xFFFFFF, 1.0);
			
            var textElement:TextElement = new TextElement(str, format);
			
            textBlock = new TextBlock();
            textBlock.content = textElement;
			textBlock.bidiLevel = 0;
            createLines();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        private function createLines():void
        {
            var xPos:Number = 15.0;
            var yPos:Number = 20.0;
			
			var num:uint = numChildren;
			while (0 < num)
			{
				removeChildAt(--num);
			}

            var textLine:TextLine = textBlock.createTextLine(null, lineWidth);
            while (textLine)
            {
                textLine.x = xPos;
                textLine.y = yPos;
                yPos += textLine.height + 2;
                addChild(textLine);
                textLine = textBlock.createTextLine(textLine, lineWidth);
            }
        }
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				textBlock.bidiLevel = (textBlock.bidiLevel == 0 ? 1 : 0);
				createLines();
			}
		}
    }
}
