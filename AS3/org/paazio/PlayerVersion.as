package org.paazio {
	import flash.events.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.external.ExternalInterface;

	/**
	 * Flash player version
	 * @author Jukka Paasonen
	 * @date 09/03/2008
	 * @version 2.1
	 * @brief Get the Flash version for the session
	 *
	 * Return values:
	 * - 0  Version received and row updated
	 * - 1  Version received, but no row updated
	 * - 2  Version info not received
	 */
	public class PlayerVersion {
		private var url:String = "flashversion.php";
		private var loader:URLLoader;
		private var request:URLRequest;
		private var info:Object = {};

		public function PlayerVersion(newUrl:String = "") {
			if (newUrl != "") {
				url = newUrl;
			}
		}

		public function run():void 
		{
			var dat:Array = Capabilities.version.split(" ");
			info.platform = dat[0];
			dat = dat[dat.length - 1].split(",");
			info.major = dat[0];
			info.minor = dat[1];
			info.patch = dat[2];
			info.debug = 0;
			if (Capabilities.isDebugger) {
				info.debug = 1;
			}

			request = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			request.data = info;

			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(Event.OPEN, onOpen);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.load(request);
		}

		private function onComplete(event:Event):void 
		{
			tracer("PlayerVersion::onComplete: " + event.toString());

			var vars:URLVariables = new URLVariables(loader.data);
			tracer("PlayerVersion::result=" + vars.result);
		}

		private function onOpen(event:Event):void 
		{
			tracer("PlayerVersion::onOpen: " + event.toString());
		}

		private function onSecurityError(event:SecurityErrorEvent):void 
		{
			tracer("PlayerVersion::onSecurityError: " + event.toString());
		}

		private function onHttpStatus(event:HTTPStatusEvent):void 
		{
			tracer("PlayerVersion::onHttpStatus: " + event.toString());
		}

		private function onIoError(event:IOErrorEvent):void 
		{
			tracer("PlayerVersion::onIoError: " + event.toString());
		}

		private function tracer(msg:Object):void 
		{
			trace(msg.toString());
			if (ExternalInterface.available) {
				ExternalInterface.call("console.log", msg.toString());
			}
		}
	}
}