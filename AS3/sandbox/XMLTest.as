/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.text.*;
	import flash.system.Security;
	import flash.ui.Keyboard;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * Test all the possibilities of XML...
	 */
    public class XMLTest extends Sprite
    {
		private var chat:XML =
			<root>
				<item id="1">
					<sender>22</sender>
					<time>11:00 30.07.2009</time>
					<message><![CDATA[Apina&gorilla]]></message>
				</item>
				<item id="2">
					<sender>22</sender>
					<time>11:01 30.07.2009</time>
					<message><![CDATA[Are you busy?]]></message>
				</item>
			</root>;
		
        public function XMLTest()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			trace(chat.item.(@id == 1).message.toXMLString());
			
			var emptyOne:XML = chat.item.(@id == 4)[0];
			trace("emptyOne: " + emptyOne);
			trace("emptyOne typeof: " + (typeof emptyOne));
			
		}

    }
}
