/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class TextRendererExample2 extends Sprite
	{

        private var gutter:int = 10;
		
		[Embed(source = "../assets/georgia.ttf", fontFamily = "Georgia")]
		private var embeddedFont:String;

        public function TextRendererExample2()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var antialiasing:Array = [
				new CSMSettings(8, 2, 2)
			];
			TextRenderer.setAdvancedAntiAliasingTable("Georgia", FontStyle.REGULAR, TextColorType.DARK_COLOR, antialiasing);
			
            createTextField(8, AntiAliasType.NORMAL);
            createTextField(8, AntiAliasType.ADVANCED);
            createTextField(24, AntiAliasType.NORMAL);
            createTextField(24, AntiAliasType.ADVANCED);
        }

        private function createTextField(fontSize:Number, antiAliasType:String):TextField
		{
            var tf:TextField = new TextField();
            tf.embedFonts = true;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.antiAliasType = antiAliasType;
            tf.defaultTextFormat = getTextFormat(fontSize);
            tf.selectable = false;
            tf.mouseEnabled = true;
            tf.text = "The quick brown fox jumped over the lazy dog.";
            if (numChildren > 0)
			{
                var sibling:DisplayObject = getChildAt(numChildren - 1);
                tf.y = sibling.y + sibling.height + gutter;
            }
            addChild(tf);
            return tf;
        }

        private function getTextFormat(fontSize:Number):TextFormat
		{
            var format:TextFormat = new TextFormat();
            format.size = fontSize;
            format.font = "Georgia";
			format.color = 0xF3F4F5;
            return format;
        }
    }
}
