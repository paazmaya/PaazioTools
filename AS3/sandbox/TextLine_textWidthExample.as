/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.FontDescription;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontPosture;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class TextLine_textWidthExample extends Sprite
	{

        public function TextLine_textWidthExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
            var str:String = "The FTE provides low-level support for sophisticated control of text metrics, formatting, and bi-directional text. While it can be used to create and manage simple text elements, the FTE is primarily designed as a foundation for developers to create text-handling components.";
            var yPos:Number = 20;
			
            var fontDescription:FontDescription = new FontDescription();
            fontDescription.fontPosture = FontPosture.NORMAL;
			
			
            var format:ElementFormat = new ElementFormat(fontDescription, 14, 0xFFFFFF);
            var textElement:TextElement = new TextElement(str, format);
			
            var textBlock:TextBlock = new TextBlock();
            textBlock.content = textElement;
            createLine(textBlock, yPos);
			
            var fontDescriptionItalic:FontDescription = fontDescription.clone();
            fontDescriptionItalic.fontPosture = FontPosture.ITALIC;
			
            var formatItalic:ElementFormat = new ElementFormat(fontDescriptionItalic, 14, 0xF4F4F4);
            textElement = new TextElement(str, formatItalic);
            textBlock.content = textElement;
            createLine(textBlock, yPos + 20);
        }

        private function createLine(textBlock:TextBlock, yPos:Number):void
		{
            var textLine:TextLine = textBlock.createTextLine (null, 500);
            trace("specifiedWidth is: " + textLine.specifiedWidth);
            trace("textWidth is: " + textLine.textWidth);
            trace("width is: " + textLine.width);
            addChild(textLine);
            textLine.x = 15;
            textLine.y = yPos;
        }
    }
}
