package org.paazio {
	import flash.net.*;
	import flash.events.*;
	import flash.utils.ByteArray;

	/**
	 * XSPF is the XML format for sharing playlists.
	 * @see http://xspf.org/specs/
	 * @author Jukka Paasonen
	 * @version 0.1.0
	 */
	public class XSPFlist {
		/**
		 * <p>XML data of the loaded playlist.</p>
		 * <code>
		 * &lt;?xml version="1.0" encoding="UTF-8"?&gt;<br />
		 * &lt;playlist version="1" xmlns="http://xspf.org/ns/0/"&gt;<br />
  		 * &nbsp;&nbsp;&lt;trackList&gt;<br />
		 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;track&gt;&lt;location&gt;file:///music/song_1.ogg&lt;/location&gt;&lt;/track&gt;<br />
		 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;track&gt;&lt;location&gt;file:///music/song_2.flac&lt;/location&gt;&lt;/track&gt;<br />
		 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;track&gt;&lt;location&gt;file:///music/song_3.mp3&lt;/location&gt;&lt;/track&gt;<br />
		 * &nbsp;&lt;/trackList&gt;<br />
		 * &lt;/playlist&gt;
		 * </code>
		 */
		public var list:XML;
		
		/**
		 * Data loader. Playlist should be compressed by using Zlib.
		 */
		private var loader:URLLoader;
		
		/**
		 * Index of the current item.
		 */
		private var current:uint = 0;
		
		/**
		 * Where is the playlist?
		 */
		public function XSPFlist(listUrl:String) {
			XML.ignoreComments = true;
			XML.ignoreProcessingInstructions = true;
			XML.ignoreWhitespace = true;
			XML.prettyPrinting = true;
			
			var request:URLRequest = new URLRequest(listUrl);
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY; // XML will be compressed by Zlib.
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(Event.OPEN, onOpen);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			loader.load(request);
		}
		
		/**
		 * Get the url for the next video in the playlist.
		 */
		public function get next():String {
			current++;
			if (list.trackList.track.length() <= current) {
				current = 0;
			}
			return list.trackList.track[current].track.toString();
		}
		
		/**
		 * Get the url of the previous item in the list.
		 */
		public function get prev():String {
			if (current > 0) {
				current--;
			}
			else {
				current = list.trackList.children().length() - 1;
			}
			return list.trackList.track[current].track.toString();
		}
		
		/**
		 * Get a given attribute of the current item.
		 */
		public function value(key:String):String {
			return list.trackList.track[current].(attribute(key)).toString();
		}
		
		/**
		 * As the name suggests, this function is triggered when the playlist has been completely downloaded.
		 */
		private function onComplete(event:Event):void 
		{
			var data:ByteArray = loader.data as ByteArray;

			loader.close();
			
			try {
				data.uncompress();
			}
			catch (e:Error) {
				trace("Could not uncompress the playlist data. " + e.toString());
			}
			data.position = 0;
			try {
				list = XML(data.readUTFBytes(data.bytesAvailable));
			}
			catch (e:Error) {
				trace("Could not read UTF Bytes. " + e.toString());
			}
			
			//trace("playlist: " + playlist);
		}
		
		/**
		 * Dispatched if a call to URLLoader.load() attempts to access data over HTTP
		 * and the current Flash Player environment is able to detect and return the status code for the request.
		 */
		private function onHTTPStatusEvent(event:HTTPStatusEvent):void 
		{
			trace("onHTTPStatusEvent: " + event.toString());
		}

		/**
		 * Dispatched if a call to URLLoader.load() results in a fatal error that terminates the download.
		 */
		private function onIOErrorEvent(event:IOErrorEvent):void 
		{
			trace("onIOErrorEvent: " + event.toString());
			trace("Unable to load the file: " + event.target.loader);
		}

		/**
		 * Dispatched when the download operation commences following a call to the URLLoader.load() method.
		 */
		private function onOpen(event:Event):void 
		{
			trace("onOpen: " + event.toString());
		}

		/**
		 * Dispatched when data is received as the download operation progresses.
		 */
		private function onProgressEvent(event:ProgressEvent):void 
		{
			trace("onProgressEvent - loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}

		/**
		 * Dispatched if a call to URLLoader.load() attempts to load data from a server outside the security sandbox.
		 */
		private function onSecurityErrorEvent(event:SecurityErrorEvent):void 
		{
			trace("onSecurityErrorEvent: " + event.toString());
		}
	}
}