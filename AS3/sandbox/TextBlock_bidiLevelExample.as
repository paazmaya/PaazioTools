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
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class TextBlock_bidiLevelExample extends Sprite
	{
        public function TextBlock_bidiLevelExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
            var format:ElementFormat = new ElementFormat();
            format.fontDescription = new FontDescription("Adobe Hebrew");
            format.fontSize = 36;
			format.color = 0xFFFFFF;
			
            var yPos:Number = 0;
            var leading:Number = format.fontSize * 0.2;
            var text:String = "abc - " + String.fromCharCode(0x05D0, 0x05D1, 0x05D2);

            var textBlock:TextBlock = new TextBlock();
            textBlock.content = new TextElement(text, format);

            // bidiLevel even
            textBlock.bidiLevel = 0;
            var textLine:TextLine = textBlock.createTextLine(null, 400);
            yPos += leading + textLine.ascent;
            textLine.y = yPos;
            yPos += textLine.descent;
            addChild(textLine);

            // bidiLevel odd
            textBlock.content = new TextElement(text, format);
            textBlock.bidiLevel = 1;
            textLine = textBlock.createTextLine(null, 400);
            yPos += leading + textLine.ascent;
            textLine.y = yPos;
            addChild(textLine);
        }
    }
}
