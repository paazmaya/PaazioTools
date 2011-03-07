/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
	import flash.events.Event;
    import flash.text.engine.FontDescription;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextLine;
    import flash.text.engine.TextRotation;
    import flash.text.engine.ElementFormat;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class TextBlock_lineRotationExample extends Sprite
	{

        public function TextBlock_lineRotationExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
            var japanese:String = String.fromCharCode(
                0x5185, 0x95A3, 0x5E9C, 0x304C, 0x300C, 0x653F, 0x5E9C, 0x30A4,
                0x30F3, 0x30BF, 0x30FC, 0x30CD, 0x30C3, 0x30C8, 0x30C6, 0x30EC,
                0x30D3, 0x300D, 0x306E, 0x52D5, 0x753B, 0x914D, 0x4FE1, 0x5411,
                0x3051, 0x306B, 0x30A2, 0x30C9, 0x30D3, 0x30B7, 0x30B9, 0x30C6,
                0x30E0, 0x30BA, 0x793E, 0x306E
            ) +
            "FMS 2" +
            String.fromCharCode(0x3092, 0x63A1, 0x7528, 0x3059, 0x308B, 0x3068,
                0x767a, 0x8868, 0x3057, 0x307e, 0x3057, 0x305F, 0x3002);

            var fontDescription:FontDescription = new FontDescription("MS Mincho");
            var format:ElementFormat = new ElementFormat();
            format.fontSize = 15;
            format.fontDescription = fontDescription;
			format.color = 0xFFFFFF;

            var textElement:TextElement = new TextElement(japanese, format);
            var textBlock:TextBlock = new TextBlock();
            textBlock.content = textElement;
            textBlock.lineRotation = TextRotation.ROTATE_90;

            var linePosition:Number = stage.stageWidth - 120;
            var previousLine:TextLine = null;

            while (true)
			{
                var textLine:TextLine = textBlock.createTextLine(
                    previousLine,
                    300);
                if (textLine == null)
                    break;
                textLine.y = 30;
                textLine.x = linePosition;
                linePosition -= 24;
                addChild(textLine);
                previousLine = textLine;
            }
        }
    }
}
