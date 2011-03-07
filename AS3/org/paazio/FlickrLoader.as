package org.paazio {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.LoaderContext;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import org.paazio.utils.Console;

	/**
	 * Flickr Image loader.
	 *
	 *  1. Get a list of photosets of the selected user
	 *  2. Get the list of photos of the selected photoset
	 *  3. Get thumbnails for each of the photos and load in an array.
	 *
	 * Step one is usually skipped via addVariable.
	 * this.loaderInfo.parameters.var_name_from_swfobject;
	 */
	public class FlickrLoader {
		// The Flickr API url.
		public var apiUrl:String = "http://api.flickr.com/services/rest/";

		// The Flickr API key.
		public var apiKey:String = "490cfca6db6afc521d2dad52b129ee17"; // paazio.nanbudo.fi

		// Number of the photos in current photoset.
		public var photoNum:uint;

		// The size at Flickr of the photo to be loaded. s = 75x75 px
		private var thumbSize:String;

		// Different lists.
		public var photoSets:XML;
		public var photoList:XML;

		// This array includes bitmapdata of the loaded photoset.
		public var photoData:Array = [];

		// Currently loading index.
		private var currentIndex:uint = 0;

		// Should all the images on a list be loaded? They will be placed in photoData array.
		public var loadImages:Boolean = true;

		public function FlickrLoader() 
		{
			//
		}

		public function loadPhotoSets(userID:String):void 
		{
			// Initiate the loading of the list of Photosets for a certain user.
			var variables:URLVariables = new URLVariables();
			variables.api_key = apiKey;
			variables.user_id = userID;
			variables.method = "flickr.photosets.getList";

			var request:URLRequest = new URLRequest(apiUrl);
			request.data = variables;

			var rest:URLLoader = new URLLoader();
			rest.addEventListener(Event.COMPLETE, onSetsComplete);
			rest.load(request);
		}
		private function onSetsComplete(event:Event):void 
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onSetsComplete);
			photoSets = new XML(event.currentTarget.data);
		}


		public function loadPhotoList(photoSetID:String, size:String = "s"):void 
		{
			this.thumbSize = size;

			var variables:URLVariables = new URLVariables();
			variables.api_key = apiKey;
			variables.method = "flickr.photosets.getPhotos";
			variables.photoset_id = photoSetID;

			var request:URLRequest = new URLRequest(apiUrl);
			request.data = variables;

			var rest:URLLoader = new URLLoader();
			rest.addEventListener(Event.COMPLETE, onListComplete);
			rest.load(request);
		}
		private function onListComplete(event:Event):void 
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onListComplete);
			photoList = new XML(event.currentTarget.data);
			photoNum = photoList.photoset.elements().length();

			if (loadImages) {
				photoData[photoList.photoset.@id.toString()] = new Array();
				for (var i:uint = 0; i < photoNum; i++) {
					loadPhoto(i);
				}
			}
		}
		private function loadPhoto(inx:uint):void 
		{
			var server:String = photoList..photo[inx].@server.toString();
			var farm:String = photoList..photo[inx].@farm.toString();
			var id:String = photoList..photo[inx].@id.toString();
			var secret:String = photoList..photo[inx].@secret.toString();
			var title:String = photoList..photo[inx].@title.toString();

			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;

			var loader:Loader = new Loader();

			/*
			http://www.flickr.com/services/api/misc.urls.html

				http://farm1.static.flickr.com/2/1418878_1e92283336_m.jpg
				farm-id: 1
				server-id: 2
				photo-id: 1418878
				secret: 1e92283336
				size: m
			 */
			var url:String =  "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret + "_" + thumbSize + ".jpg";
			var request:URLRequest = new URLRequest(url);

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(request, context);
		}
		private function onPhotoComplete(event:Event):void 
		{
			var loader:Loader = Loader(event.currentTarget.loader);
			var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
			info.removeEventListener(Event.COMPLETE, onPhotoComplete);
			info.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			var bitmap:Bitmap = loader.content as Bitmap;
			loader = null;

			photoData.push(bitmap.bitmapData);

			currentIndex++;
			if (currentIndex < photoNum) {
				loadPhoto(currentIndex);
			}
			else {
				// Dispatch complete event.
			}
		}
		private function onIOError(event:IOErrorEvent):void 
		{
            Console.error("onIOError: " + event.toString());
        }
	}
}