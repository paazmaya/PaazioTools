/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextLine;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.FontPosture;
    import flash.text.engine.FontWeight;
    import flash.events.Event;
    import flash.geom.Rectangle;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class TextLineExample extends Sprite
	{
        private var atomDataContainer:Sprite;
        private var fontDescriptionItalic:FontDescription = new FontDescription("Arial", FontWeight.NORMAL, FontPosture.ITALIC);
        private var fontDescriptionNormal:FontDescription = new FontDescription("Arial", FontWeight.NORMAL , FontPosture.NORMAL);
        private var textBlock:TextBlock = new TextBlock();
        private var textLine:TextLine;

        public function TextLineExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
            var myText:String = "I am a TextElement, created from a String and assigned " +
				"to the content property of a TextBlock. From the text block, " +
				"the createTextLine() method created these lines, 300 pixels wide, "  +
				"for display.";

            var directions:String = "Click up / down arrows to frame atoms in text block above.";

            var formatItalic:ElementFormat = new ElementFormat(fontDescriptionItalic, 12);
			
            var textElement1:TextElement = new TextElement(directions, formatItalic);
            textBlock.content = textElement1;
            createLines(textBlock, 15, 160, 400, this);

            var formatNormal:ElementFormat = new ElementFormat(fontDescriptionNormal, 16);
            var textElement2:TextElement = new TextElement(myText, formatNormal);
            textBlock.content = textElement2;
            createLines(textBlock, 15.0, 20.0, 300, this);
            textLine = textBlock.firstLine;
            showAtom(textLine, 0);
        }

        private function createLines(textBlock:TextBlock, startX:Number, startY:Number, width:Number, container:Sprite):void
        {
            var textLine:TextLine = textBlock.createTextLine (null, width);
            while (textLine)
            {
                textLine.x = startX;
                textLine.y = startY;
                startY += textLine.height + 2;
                container.addChild(textLine);
                textLine = textBlock.createTextLine (textLine, width);
            }
        }

        private function showAtom(textLine:TextLine, i:int):void
        {
            var bounds:Rectangle = textLine.getAtomBounds(i);
			
            var box:Sprite = new Sprite();
            var gra:Graphics = box.graphics;
            gra.lineStyle(1, 0xFF0000, 1.0);
            gra.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);
			
            textLine.userData = textLine.addChild(box);
            displayAtomData(textLine, i);
        }

        private function displayAtomData(textLine:TextLine, i:int):void
        {
            if (atomDataContainer != null)
			{
                removeChild(atomDataContainer);
			}
            atomDataContainer = new Sprite();
            var format:ElementFormat = new ElementFormat(fontDescriptionNormal);
            format.color = 0x00000FF;
            var n:int = 0;
            var nxtY:Number = 0;
            var atomInfo:String = "value of getAtomBidiLevel() is: " + textLine.getAtomBidiLevel(i)+"\n"
            +"value of getAtomCenter() is: " + textLine.getAtomCenter(i)+"\n"
            +"value of getAtomIndexAtCharIndex() is: " + textLine.getAtomIndexAtCharIndex(i)+"\n"
            +"value of getAtomTextBlockBeginIndex() is: " + textLine.getAtomTextBlockBeginIndex(i)+"\n"
            +"value of getAtomTextBlockEndIndex() is: " + textLine.getAtomTextBlockEndIndex(i)+"\n"
            +"value of getAtomTextRotation() is: " + textLine.getAtomTextRotation(i)+"\n";
            var atomtextBlock:TextBlock = new TextBlock();
            var textElement3:TextElement = new TextElement(atomInfo, format);
            atomtextBlock.content = textElement3;
            createLines(atomtextBlock, 20, 200, 500, atomDataContainer);
            addChild(atomDataContainer);
        }

        private function removeAtom(textLine:TextLine):void
        {
            textLine.removeChild(textLine.userData);
        }
    }
}
