/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class StyleSheet_parseCSSExample extends Sprite
	{
        private var loader:URLLoader = new URLLoader();
        private var field:TextField = new TextField();
        private var exampleText:String = "<h1>This is a headline</h1>"
                    + "<p>This is a line of text. <span class='bluetext'>"
                    + "This line of text is colored blue.</span></p>";
        private var sheet:StyleSheet = new StyleSheet();
        private var cssReady:Boolean = false;

        public function StyleSheet_parseCSSExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
            field.x = 10;
            field.y = 10;
            field.background = true;
            field.multiline = true;
            field.autoSize = TextFieldAutoSize.LEFT;
            field.htmlText = exampleText;

            field.addEventListener(MouseEvent.CLICK, clickHandler);

            addChild(field);

            var req:URLRequest = new URLRequest("assets/StyleSheet_parseCSSExample.css");
            loader.load(req);

            loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
        }

        public function errorHandler(e:IOErrorEvent):void 
		{
            field.htmlText = "Couldn't load the style sheet file.";
        }

        public function loaderCompleteHandler(event:Event):void 
		{
            sheet.parseCSS(loader.data);
            cssReady = true;
        }

        public function clickHandler(e:MouseEvent):void 
		{
            if (cssReady) 
			{
                field.styleSheet = sheet;
                field.htmlText = exampleText;

                var style:Object = sheet.getStyle("h1");
                field.htmlText += "<p>Headline font-family is: " + style.fontFamily + "</p>";
                field.htmlText += "<p>Headline color is: " + style.color + "</p>";

            } 
			else 
			{
                field.htmlText = "Couldn't apply the CSS styles.";
            }
        }
    }
}
