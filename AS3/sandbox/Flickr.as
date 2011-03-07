/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.system.*;
	import flash.ui.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '1000', height = '900')]

	/**
	 * Flickr API tests. 
	 * Fetches all photo sets and then shows thumbnails with the given amount of views.
	 */
	public class Flickr extends Sprite
	{
		private const API_KEY:String = "1862cc3a9e0d9d16ac3333075d29154e"; // paazio.nanbudo.fi
		private const API_URL:String = "http://api.flickr.com/services/rest/";
		private const USER_ID:String = "14224905@N08"; // paazio
		
		private var _photoSets:XML;
		private var _photos:XML = <fotkes/>;
		private var _loadedSets:uint = 0;
		
		private var _panel:TextField;

		private var format:TextFormat;

		private var container:Sprite;

		private var imagesWithViews:uint = 0;


		private var margin:Number = 1;

		private var imageWidth:uint = 75; // Image width depends of the size parameter.
		private var imageSize:String = "s"; // s = 75

		/**
		 * Flickr API usage.
		 * Load images without any views.
		 */
		public function Flickr()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener( Event.INIT, onInit );
		}

		public function onInit( event:Event ):void
		{
			Security.loadPolicyFile( "http://api.flickr.com/crossdomain.xml" );
			
			format = new TextFormat();
			format.font = "Arial";
			format.size = 10;
			format.color = 0xF3F3F3;

			createPanel();

			container = new Sprite();
			addChild( container );

			getPhotoSets();
			
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		}
		
		public function onKeyUp( event:KeyboardEvent ):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				loadPhotosWithViews( imagesWithViews );
			}
			else if (event.keyCode == Keyboard.UP)
			{
				imagesWithViews++;
			}
			else if (event.keyCode == Keyboard.DOWN && imagesWithViews > 0)
			{
				imagesWithViews--;
			}
		}
		
		private function createPanel():void
		{
			_panel = new TextField();
			_panel.textColor = 0x000000;
			_panel.defaultTextFormat = format;
			_panel.selectable = true;
			_panel.background = false;
			_panel.border = true;
			_panel.text = "";
			_panel.x = 3;
			_panel.y = 3;
			_panel.height = 200;
			_panel.width = stage.stageWidth - 6;
			addChild( _panel );
		}

		public function getPhotoSets():void
		{
			var variables:URLVariables = new URLVariables();
			variables.api_key = API_KEY;
			variables.user_id = USER_ID;
			variables.method = "flickr.photosets.getList";
			//variables.method = "flickr.favorites.getList";

			var request:URLRequest = new URLRequest( API_URL );
			request.data = variables;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onPhotoSetsLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.load( request );
		}

		private function onPhotoSetsLoaded( event:Event ):void
		{
			var setLoader:URLLoader = event.target as URLLoader;
			trace(setLoader.data);
			
			_photoSets = new XML( setLoader.data );
			trace("photosets total: " + _photoSets.photosets.children().length());
			//_panel.appendText(_photoSets.toString() + "\n\n");
			
			var children:XMLList = _photoSets.photosets.children();
			var len:uint = children.length();

			for (var i:uint = 0; i < len; ++i)
			{
				var photoset:XML = children[i] as XML;
				var variables:URLVariables = new URLVariables();
				variables.api_key = API_KEY;
				variables.method = "flickr.photosets.getPhotos";
				variables.photoset_id = photoset.@id.toString();
				variables.extras = "views";
				trace("Loading set: " + photoset.@id);

				var request:URLRequest = new URLRequest( API_URL );
				request.data = variables;

				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, onPhotoSetPhotosComplete );
				loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				loader.load( request );
			}
		}
		
		private function onIOError( event:IOErrorEvent ):void
		{
			trace("onIOError. " + event.toString());
		}
		
		private function onSecurityError( event:SecurityErrorEvent ):void
		{
			trace("onSecurityError. " + event.toString());
		}

		private function onPhotoSetPhotosComplete( event:Event ):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var data:XML = XML( loader.data );
			//trace( "onPhotoSetPhotosComplete. data.toXMLString(): " + data.toXMLString() );
			
			_loadedSets++;
			_photos.appendChild( data.photoset.children() );
			
			trace("id: " + data.photoset.@id + ", _loadedSets: " + _loadedSets);
			if (_loadedSets == _photoSets.photosets.children().length())
			{
				// List views
				for (var i:uint = 0; i < 600; ++i)
				{
					var c:uint = _photos.children().(@views == i).length();
					if (c > 0)
					{
						_panel.appendText( "Photos with " + i + " views: " + c + "\n" );
					}
				}
				
				// Show photos with specific amount of views
				loadPhotosWithViews( imagesWithViews );
				
			}
		}
		
		private function loadPhotosWithViews( limit:uint = 0 ):void
		{
			var children:XMLList = _photos.children().(@views == limit);
			var len:uint = children.length();
			trace("photos with " + limit + " views: " + len);
			
			var num:uint = container.numChildren;
			while (num > 0)
			{
				--num;
				container.removeChildAt(num);
			}
			
			var xPos:Number = 0;
			var yPos:Number = _panel.y + _panel.height + 3;
			for (var i:uint = 0; i < len; ++i)
			{
				var photo:XML = children[i] as XML;
				showPhoto(photo, xPos, yPos);
				xPos += imageWidth;
				if (xPos + imageWidth > stage.stageWidth)
				{
					xPos = 0;
					yPos += imageWidth;
				}
			}
		}
		
		// <photo id="2484" secret="123456" server="1" title="my photo" isprimary="0" />
		private function showPhoto( data:XML, xPos:Number, yPos:Number ):void
		{
			var sp:Sprite = new Sprite();
			sp.x = xPos;
			sp.y = yPos;
			sp.name = data.@id;
			sp.mouseChildren = false;
			sp.addEventListener(MouseEvent.CLICK, onPhotoClick);
			container.addChild( sp );
			
			var ld:Loader = new Loader();
			sp.addChild(ld);

			var url:String = "http://farm" + data.@farm + ".static.flickr.com/" + data.@server +
				"/" + data.@id + "_" + data.@secret + "_" + imageSize + ".jpg";
			
			var cx:JPEGLoaderContext = new JPEGLoaderContext();
			cx.checkPolicyFile = true;
			
			var request:URLRequest = new URLRequest( url );
			//_panel.appendText( "Loading... " + url + "\n" );
			ld.load( request, cx );

			//_panel.appendText( data.@title + "ld.y: " + ld.y + ", ld.x: " + ld.x + "\n" );

		}

		private function onPhotoClick( event:MouseEvent ):void
		{
			var sp:Sprite = event.target as Sprite;
			//trace(sp.name);
			navigateToURL(new URLRequest("http://flickr.com/paazio/" + sp.name), "_blank");
		}
	}
}
