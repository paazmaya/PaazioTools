/**
 * @mxmlc -target-player=10.0.0 -source-path=O:/www/Tsuka_SVN/trunk/actionscript3
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;

	import com.greensock.TweenLite;
	import com.greensock.plugins.*;

	[SWF( backgroundColor = '0x042836', frameRate = '33', width = '225', height = '225' )]

	/**
	 * A test for getting a random photo of all my five thousand photos.
	 * Results are saved to a shared object for later use.
	 */
	public class RandomFlickrPhoto extends Sprite
	{
		/**
		 * @see http://www.flickr.com/services/api/keys/
		 */
		private const API_KEY:String = "1862cc3a9e0d9d16ac3333075d29154e";

		private const API_URL:String = "http://api.flickr.com/services/rest/";

		/**
		 * http://www.flickr.com/photos/{user-id}/{photo-id}
		 */
		private const TARGET_URL:String = "http://www.flickr.com/photos/paazio/";

		/**
		 * @see http://www.flickr.com/services/api/flickr.people.getPublicPhotos.html
		 */
		private const METHOD:String = "flickr.people.getPublicPhotos";

		/**
		 * paazio
		 */
		private const USER_ID:String = "14224905@N08";

		private const TWEEN_TIME:Number = 0.3;

		[Embed( source = "../assets/nrkis.ttf", fontFamily = "nrkis", unicodeRange = "U+0030-U+0039" )]
		private var Nrkis:String;

		private var _currentPage:uint = 1;

		/**
		 * s	small square 75x75
		 * t	thumbnail, 100 on longest side
		 * m	small, 240 on longest side
		 */
		private var _imageSize:String = "s";

		private var _imageWidth:uint = 75; // Image width depends of the size parameter.

		private var _interval:Number = 3; // seconds

		/**
		 * Nine items as the grid is 3x3.
		 */
		private var _photos:Vector.<Sprite>;

		private var _photoList:Array = [];

		/**
		 * Index of the current image.
		 */
		private var _photoIndex:uint = 0;

		private var _photoShownAt:uint = 0;

		private var _photoLoading:Boolean = false;

		private var _photosPerPage:uint = 20;

		private var _totalPages:uint = 1;

		private var _shared:SharedObject;

		private var _sharedData:ByteArray;

		private var _sharedDataObj:Object = {};

		private var _timer:Timer;

		public function RandomFlickrPhoto()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			loaderInfo.addEventListener( Event.INIT, onInit );
		}

		private function onInit( event:Event ):void
		{
			TweenPlugin.activate( [ BlurFilterPlugin ] );

			Security.loadPolicyFile( "http://api.flickr.com/crossdomain.xml" );

			_photos = new Vector.<Sprite>( 9 );

			_shared = SharedObject.getLocal( "RandomFlickrPhoto" );
			trace( "Initial shared KB: " + Math.round( _shared.size / 1024 ).toString() );

			_sharedData = _shared.data.bytes as ByteArray;
			if ( _sharedData == null )
			{
				_sharedData = new ByteArray();
			}
			else
			{
				if ( _sharedData.length > 0 )
				{
					try
					{
						_sharedData.uncompress();
					}
					catch ( error:Error )
					{
						trace( "Could not uncompress" );
					}
					_sharedDataObj = _sharedData.readObject();
				}
			}

			// Check which pages are found in the local memory.
			var pageFound:Boolean = true;
			while ( pageFound )
			{
				var list:Array = _sharedDataObj[ "page" + _currentPage.toString() ] as
					Array;
				if ( list != null )
				{
					_photoList = _photoList.concat( list );
					++_currentPage;
				}
				else
				{
					pageFound = false;
				}
			}

			loadPhotoList( _currentPage );

			var index:uint = 0;
			for ( var i:uint = 0; i < 3; ++i )
			{
				for ( var j:uint = 0; j < 3; ++j )
				{
					var sp:Sprite = new Sprite();
					sp.x = i * _imageWidth;
					sp.y = j * _imageWidth;
					sp.addEventListener( MouseEvent.CLICK, onPhotoClick );
					addChild( sp );
					var bm:Bitmap = new Bitmap( new BitmapData( _imageWidth, _imageWidth,
																true, 0x00121212 ) );
					sp.addChild( bm );
					_photos[ index ] = sp;
					++index;
				}
			}

			stage.addEventListener( KeyboardEvent.KEY_UP, onKey );

			_timer = new Timer( 200 );
			_timer.addEventListener( TimerEvent.TIMER, onTimer );
			_timer.start();
		}

		private function loadImage( url:String ):void
		{
			trace( "loadImage. url: " + url );
			var cx:JPEGLoaderContext = new JPEGLoaderContext();
			cx.deblockingFilter = 0.5;
			cx.checkPolicyFile = true;

			var request:URLRequest = new URLRequest( url );

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onImageLoaded );
			loader.load( request, cx );
		}

		private function loadPhotoList( page:uint = 1 ):void
		{
			var vars:URLVariables = new URLVariables();
			vars.api_key = API_KEY;
			vars.user_id = USER_ID;
			vars.method = METHOD;
			vars.per_page = _photosPerPage;
			vars.page = page;

			var request:URLRequest = new URLRequest( API_URL );
			request.data = vars;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onPhotoListComplete );
			loader.load( request );
		}

		private function onBlurEnd( sp:Sprite, bmd:BitmapData, id:String ):void
		{
			sp.name = id;
			_photoShownAt = getTimer();
			_photoLoading = false;
			var bm:Bitmap = sp.getChildAt( 0 ) as Bitmap;
			bm.bitmapData = bmd;
			TweenLite.to( sp, TWEEN_TIME, {
				blurFilter: { blurX: 0, blurY: 0, remove: true }, alpha: 1.0
			} );
		}

		private function onImageLoaded( event:Event ):void
		{
			var info:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = info.loader;
			var bmd:BitmapData = new BitmapData( loader.width, loader.height );
			bmd.draw( loader );

			// http://farm4.static.flickr.com/3014/2769238276_29c101cb29_s.jpg --> 2769238276
			var id:String = info.url.split( "/" ).pop().split( "_" )[ 0 ];

			var index:uint = Math.round( Math.random() * ( _photos.length - 1 ) );
			var sp:Sprite = _photos[ index ];
			if ( sp != null )
			{
				TweenLite.to( sp, TWEEN_TIME, {
					blurFilter: { blurX: 10, blurY: 10 }, alpha: 0.1,
					onComplete: onBlurEnd, onCompleteParams: [ sp, bmd, id ]
				} );
			}
			else
			{
				trace( "onImageLoaded. bm was null. index: " + index );
			}
		}

		private function onKey( event:KeyboardEvent ):void
		{
			if ( event.keyCode == Keyboard.LEFT )
			{
				// previous photo
				showPhoto( -1 );
			}
			else if ( event.keyCode == Keyboard.RIGHT )
			{
				// next photo
				showPhoto( 1 );
			}
			else if ( event.keyCode == Keyboard.UP )
			{
				// longer interval
				_interval += 0.5;
			}
			else if ( event.keyCode == Keyboard.DOWN )
			{
				// shorter interval
				if ( _interval > 1 )
				{
					_interval -= 0.5;
				}
			}
			else if ( event.keyCode == Keyboard.SPACE )
			{
				// Pause the slideshow
				if ( _timer.running )
				{
					_timer.stop();
				}
				else
				{
					_timer.start();
				}
			}
		}

		private function onPhotoListComplete( event:Event ):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var data:XML = new XML( loader.data );
			//trace("onPhotoListComplete. data: " + data.toXMLString());
			if ( data.localName().toString() != "err" )
			{
				parseXML( data.children()[ 0 ] );
			}
		}

		/**
		 * Triggeres the opening of the corresponding flickr page.
		 * @param	event
		 */
		private function onPhotoClick( event:MouseEvent ):void
		{
			var sp:Sprite = event.target as Sprite;
			var url:String = TARGET_URL + sp.name;
			navigateToURL( new URLRequest( url ), "_blank" );
		}

		/**
		 * Initiattes the transformation to the next photo if the time is to do so.
		 * @param	event
		 */
		private function onTimer( event:TimerEvent ):void
		{
			var now:uint = getTimer();
			if ( _photoShownAt + _interval * 1000 < now && !_photoLoading )
			{
				_photoLoading = true;
				showPhoto();
			}
		}

		/**
		 * Add new items to the dictionary.
		 * http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
		 * http://flic.kr/p/{base58-photo-id}
		 * @param	data
		 */
		private function parseXML( data:XML ):void
		{
			trace( "parsing page " + data.@page.toString() + ", total: " + data.@pages.toString() +
				   ", shared KB: " + Math.round( _shared.size / 1024 ).toString() );
			_totalPages = parseInt( data.@pages.toString() );

			var list:Array = [];
			for each ( var child:XML in data.children() )
			{
				var url:String = "http://farm" + child.@farm.toString() + ".static.flickr.com/" +
					child.@server.toString() + "/" + child.@id.toString() + "_" +
					child.@secret.toString() + "_" + _imageSize + ".jpg";
				list.push( url );
			}

			// Update data.
			_sharedDataObj[ "page" + data.@page.toString() ] = list;
			_sharedData.writeObject( _sharedDataObj );
			_sharedData.compress();
			_shared.data.bytes = _sharedData;
			_sharedData.uncompress();

			_photoList = _photoList.concat( list );

			if ( _currentPage.toString() == data.@page.toString() && _currentPage <
				_totalPages )
			{
				++_currentPage;
				loadPhotoList( _currentPage );
			}
		}

		/**
		 * Show a random photo.
		 */
		private function showPhoto( offset:int = 0 ):void
		{
			var index:int = Math.round( Math.random() * ( _photoList.length - 1 ) );
			if ( offset != 0 )
			{
				index = _photoIndex + offset;
			}
			if ( index < 0 )
			{
				index = _photoList.length - 1;
			}
			else if ( index > _photoList.length - 1 )
			{
				index = 0;
			}
			trace( "showPhoto. offset: " + offset + ", index: " + index + ", _photoIndex: " +
				   _photoIndex );
			_photoIndex = index;
			var url:String = _photoList[ index ] as String;
			if ( url != null )
			{
				loadImage( url );
			}
		}

	/**
	 * Helper funtion to shorten urls in Base58 form.
	 * @param	snipcode
	 * @return
	 * @see http://www.flickr.com/groups/api/discuss/72157616713786392/
	 */ /*
	   private function base58_decode( snipcode:String ):String
	   {
	   var alphabet:String = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ' ;
	   var len:uint = snipcode.length;
	   var decoded = 0 ;
	   var multi = 1 ;
	   for ( var i = (len - 1) ; i >= 0 ; i-- )
	   {
	   decoded = decoded + multi * alphabet.indexOf( snipcode[i] ) ;
	   multi = multi * alphabet.length;
	   }
	   return decoded;
	 }*/ /*
	   function base58encode($num, $alphabet)
	   {
	   $base_count = strlen($alphabet);
	   $encoded = '';
	   while ($num >= $base_count)
	   {
	   $div = $num/$base_count;
	   $mod = ($num-($base_count*intval($div)));
	   $encoded = $alphabet[$mod] . $encoded;
	   $num = intval($div);
	   }

	   if ($num)
	   {
	   $encoded = $alphabet[$num] . $encoded;
	   }

	   return $encoded;
	   }

	   function base58decode($num, $alphabet)
	   {
	   $decoded = 0;
	   $multi = 1;
	   while (strlen($num) > 0)
	   {
	   $digit = $num[strlen($num)-1];
	   $decoded += $multi * strpos($alphabet, $digit);
	   $multi = $multi * strlen($alphabet);
	   $num = substr($num, 0, -1);
	   }

	   return $decoded;
	   }
	 */

	}
}
