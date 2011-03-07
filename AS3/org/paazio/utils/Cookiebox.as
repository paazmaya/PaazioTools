package org.paazio.utils {
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent
	import flash.events.SyncEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 * Cookiebox
	 * @author Jukka Paasonen
	 * @date 4/2007
	 * @version 1.0
	 * @brief Get the Flash version for the session
	 *
	 * Use setProperty() to set key=value.
	 */
	public class Cookiebox extends SharedObject {
		private var shared:SharedObject;
		private var url:String = "";

		public function Cookiebox(boxName:String) {
			shared = SharedObject.getLocal(boxName);
			shared.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			shared.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			shared.addEventListener(SyncEvent.SYNC, onSync);
		}

		// Getter...
		public function get uri():String {
			return url;
		}
		// ...and Setter.
		public function set uri(setValue:String):void 
		{
			url = setValue;
			shared.flush();
		}


		private function onAsyncError(event:AsyncErrorEvent):void 
		{
            trace("onAsyncError");
        }
		private function onNetStatus(event:NetStatusEvent):void 
		{
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
                    trace("User granted permission -- value saved.");
                    break;
                case "SharedObject.Flush.Failed":
                    trace("User denied permission -- value not saved.");
                    break;
            }
        }
		private function onSync(event:SyncEvent):void 
		{
            switch (event.type) {
                case "":
                    trace("");
                    break;
            }
        }
	}
}