package org.paazio {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	
	public class ProgressiveLoader extends Loader {

		public var url:String;
		
		private var bytes:ByteArray;
		private var stream:URLStream;
		
		public function ProgressiveLoader() 
		{
			super();
			
			bytes = new ByteArray();

		}
		
		private function onEnterFrame(event:Event):void 
		{
			
			if (stream.bytesAvailable > 0) {
				trace("onEnterFrame. stream.connected: " + stream.connected + ", bytes.length: " + bytes.length);
				
				if (stream.connected) {
					stream.readBytes(bytes, bytes.length);
					reload();
				}
			}
		}
		
		
		override public function load(request:URLRequest, context:LoaderContext = null):void 
		{
			this.url = request.url;
			
			trace("load. url: " + url);
			
			stream = new URLStream();
			stream.addEventListener(Event.COMPLETE, onStreamComplete);
			stream.load(request);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onStreamProgress(event:Event):void 
		{
		}
		
		private function onStreamComplete(event:Event):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (stream.connected) {
				stream.readBytes(bytes, bytes.length);
				stream.close();
				reload();
			}
			trace("onStreamComplete. stream.connected: " + stream.connected + ", bytes.length: " + bytes.length);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function reload():void 
		{
			this.unload();
			this.loadBytes(bytes);
		}
	}
}