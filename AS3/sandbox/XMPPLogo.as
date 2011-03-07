/**
 * @mxmlc -target-player=10.0.0 -source-path=D:/AS3libs -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import XML;
	import com.lorentz.SVG.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]

	public class XMPPLogo extends Sprite
	{
		private const SVG_FILE:String = "assets/XMPP_Logo.svg";
		
		/*[Embed(source = "../assets/XMPP_Logo.svg", mimeType = "text/xml")]
		private var XMPP_Logo:Class;
		*/
		public function XMPPLogo() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load( new URLRequest(SVG_FILE));
			
			
			/*
			//var ba:ByteArray = new XMPP_Logo() as ByteArray;
			//var s:String = ba.readUTFBytes( ba.length );
			XML.ignoreWhitespace = false;
			//var svg:XML = new XML(s);
			var svg:XML = new XML(new XMPP_Logo());
			trace("svg: " + svg.toString());
			XML.ignoreWhitespace = true;
			renderSvg(svg);
			*/
		}
		
		private function renderSvg(data:XML):void
		{
			var i:Number = getTimer();
			var shp:Sprite = new SVGRenderer(data);
			var f:Number = getTimer();
			
			trace("Time elapsed: "+Number(f-i).toString());

			addChildAt(shp, 0);
		}

		private function onError(event:IOErrorEvent):void
		{
			trace("Cannot load the file");
		}
		
		private function onComplete(event:Event):void
		{			
			XML.ignoreWhitespace = false;
			var svg:XML = new XML(event.target.data);
			XML.ignoreWhitespace = true;
			renderSvg(svg);
		}
	}
}