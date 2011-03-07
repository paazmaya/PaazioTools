/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.errors.IOError;
    import flash.system.Capabilities;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
    public class TextEvent_LINKExample extends Sprite 
	{
        private  var myCircle:Shape = new Shape();

        public function TextEvent_LINKExample() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
            var myTextField:TextField = new TextField();
            myTextField.autoSize = TextFieldAutoSize.LEFT;
            myTextField.multiline = true;
			myTextField.background = true;
            myTextField.htmlText = "Draw a circle with the radius of <u><a href=\"event:20\">20 pixels</a></u>.<br>"
                         +  "Draw a circle with the radius of <u><a href=\"event:50\">50 pixels</a></u>.<br><br>"
                         +  "<u><a href=\"event:os\">Learn about your operating system.</a></u><br>";

            myTextField.addEventListener(TextEvent.LINK, linkHandler);

            addChild(myTextField);
            addChild(myCircle);
        }

        private function linkHandler(e:TextEvent):void 
		{
            var osString:String = Capabilities.os;

            if (e.text == "os")
			{

                if (osString.search(/Windows/) != -1 )
				{
                    navigateToURL(new URLRequest("http://www.microsoft.com/"), "_self");
                }
				else if (osString.search(/Mac/) != -1 ) 
				{
                    navigateToURL(new URLRequest("http://www.apple.com/"), "_self");
                }
				else if (osString.search(/linux/i) != -1) 
				{
                    navigateToURL(new URLRequest("http://www.tldp.org/"), "_self");
                }

            } 
			else
			{
                myCircle.graphics.clear();
                myCircle.graphics.beginFill(0xFF0000);
                myCircle.graphics.drawCircle(100, 150, Number(e.text));
                myCircle.graphics.endFill();
            }
        }
    }
}
