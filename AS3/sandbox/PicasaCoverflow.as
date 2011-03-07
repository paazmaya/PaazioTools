/**
* @mxmlc -source-path=D:/AS3libs
*/

/**
 * Picasa Image thumbnail loader in a coverflow
 * Using the smallest size available, 75x75.
 *
 *  1. Get a list of photosets of the selected user
 *  2. Get the list of photos of the selected photoset
 *  3. Get thumbnails for each of the photos and load in the carousel
 *  4. Open photo in a thickbox by using ExternalInterface.
 */

package sandbox
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.Plane;
	import org.papervision3d.scenes.MovieScene3D;

	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	[SWF(backgroundColor='0x042836', frameRate='60', width='800', height='150')]
	
	// 80 KB without, 207 KB with.
	//[Frame(factoryClass="Yooi")]

	public class PicasaCoverflow extends Sprite
	{
		// list of albums:
		// GET http://picasaweb.google.com/data/feed/api/user/olavic?kind=album&access=public
		
		// http://code.google.com/apis/picasaweb/gdata.html

		private var apiKey:String = "1862cc3a9e0d9d16ac3333075d29154e"; // paazio.nanbudo.fi
		private var apiUrl:String = "http://api.flickr.com/services/rest/";
		private var userId:String = "14224905@N08"; // paazio
		private var psetid:String = "72157602192912945"; // Kobudo - Turku (FI) - 2005/10
		private var thumbSide:uint = 72;
		private var blurMax:Number = 20;
		private var capBetween:Number = 16; // How much space between each photo.
		private var radius:Number = 940;
		private var viewIsSetList:Boolean = true;
		private var flickrBallsDirection:Number = 0.15; // Direction and speed of pixels.
		private var _width:Number = 800;
		private var _height:Number = 150;

		private var paazio:Sprite;
		private var sammakko:Sprite;
		private var flickrBalls:Sprite;
		private var container:Sprite;
		private var sceneMask:Shape;
		private var scene:MovieScene3D;
		private var camera:Camera3D;
		private var thumbArray:Array = [];
		private var ext:ExternalInterface;
		private var photoSets:XML;
		private var photoList:XML;
		private var rest:URLLoader;
		private var currentIndex:uint = 0;
		private var photos:uint = 0;
		private var titleField:TextField;

		[Embed(source='sammakko_only.swf', symbol='Froggy')] private var Froggy:Class;
		
		[Embed(source="nrkis.ttf", fontFamily="nrkis")] private var nrkis:String;
		
		/*
		 * All small case letters needed for "paazio".
		 * a-z	U+0061-U+007A
		 * a	U+0061-U+0061
		 * i	U+0069-U+0069
		 * o	U+006F-U+006F
		 * p	U+0070-U+0070
		 * z	U+007A-U+007A
		 */
		[Embed(source="papyrus.ttf", fontFamily="papyrus", unicodeRange="U+0061-U+007A")]
		private var papyrus:String;
		
		public function PicasaCoverflow()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			stage.doubleClickEnabled = true;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		public function onInit(event:Event):void
		{
			//stage.addEventListener(Event.RESIZE, onStageResize);
			
			sceneMask = new Shape();
			sceneMask.graphics.beginFill(0xCCCCCC);
			sceneMask.graphics.drawRoundRect(1, 1, _width - 2, _height - 2, 20, 20);
			sceneMask.graphics.endFill();
			addChild(sceneMask);

			container = new Sprite();
			container.x = 400;
			container.y = 75;
			container.mask = sceneMask;
			addChild(container);


			rest = new URLLoader();
			rest.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			rest.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			/*
			if (loaderInfo.parameters.photoset != undefined)
			{
				psetid = String(loaderInfo.parameters.photoset);
			}
			if (psetid != "undefined" && psetid != "")
			{
				loadPhotoList(psetid);
				titleField.text = "Loading photo set...";
			}
			else
			{
				loadSetList();
				titleField.text = "Loading a list of photosets...";
			}
			*/
			//loadPhotoList(psetid);
			
			//createBorders();
			try
			{
				createTitleField();
			}
			catch (e:Error)
			{
				tracer("init(). createTitleField. " + e.toString());
			}
			try
			{
				createPaazio();
			}
			catch (e:Error)
			{
				tracer("init(). createPaazio. " + e.toString());
			}
			try
			{
				createSammakko();
			}
			catch (e:Error)
			{
				tracer("init(). createSammakko. " + e.toString());
			}
			try
			{
				createFlickrBalls();
			}
			catch (e:Error)
			{
				tracer("init(). createFlickrBalls. " + e.toString());
			}
			
			init3D();
		}
		
		private function init3D():void
		{
			scene = new MovieScene3D(container);
			// In case planes should be facing center...
			scene.addChild(new DisplayObject3D() , "center");

			camera = new Camera3D();
			camera.y = 100;
			camera.z = 1000;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createSammakko():void
		{
			sammakko = new Froggy() as Sprite;
			sammakko.name = "sammakko";
			sammakko.x = _width - (sammakko.width + 4);
			sammakko.y = (_height - sammakko.height) / 2;
			sammakko.mouseEnabled = true;
			sammakko.addEventListener(MouseEvent.CLICK, onSammakkoMouse);
			sammakko.addEventListener(MouseEvent.DOUBLE_CLICK, onSammakkoMouse);
			sammakko.addEventListener(MouseEvent.MOUSE_OVER, onSammakkoMouse);
			sammakko.addEventListener(MouseEvent.MOUSE_OUT, onSammakkoMouse);
			addChild(sammakko);
		}
		
		private function createPaazio():void
		{
			paazio = new Sprite();
			paazio.name = "paazio";
			paazio.x = -70;
			paazio.y = 20;
			addChild(paazio);
			
			var fmt:TextFormat = new TextFormat();
			fmt.font = "papyrus";
			fmt.size = 56;
			fmt.bold = true;
			fmt.align = TextFormatAlign.LEFT;
			
			var str:String = "paazio";
			var num:uint = str.length;
			var xx:Number = 0;
			for (var i:uint = 0; i < num; ++i)
			{
				var txt:TextField = new TextField();
				txt.defaultTextFormat = fmt;
				txt.text = str.charAt(i);
				txt.autoSize = TextFieldAutoSize.RIGHT;
				txt.selectable = false;
				txt.embedFonts = true;
				
				var sp:Sprite = new Sprite();
				sp.name = "pz_" + i;
				sp.buttonMode = true;
				sp.mouseChildren = false;
				sp.addEventListener(MouseEvent.MOUSE_OVER, onPaazioMouse);
				sp.addEventListener(MouseEvent.MOUSE_OUT, onPaazioMouse);
				sp.addChild(txt);
				sp.x = xx + sp.width - 3;
				xx = sp.x;
				
				paazio.addChild(sp);
			}
			
			// add a feature under "p".
			/*
			var p:Sprite = paazio.getChildByName("pz_0") as Sprite;
			var masker:Shape = new Shape();
			masker.name = "masker";
			masker.graphics.beginFill(0x000000);
			masker.graphics.drawRect(0, 0, 140, 30);
			masker.x = p.width;
			
			fmt.size = 12;
			
			var jpTxt:TextField = new TextField();
			jpTxt.defaultTextFormat = fmt;
			jpTxt.autoSize = TextFieldAutoSize.LEFT;
			jpTxt.text = "Jukka Paasonen";
			
			var juga:Sprite = new Sprite();
			juga.addChild(jpTxt);
			juga.addChild(masker);
			juga.x = 0;
			juga.y = p.x + 28;
		//	jukka.mask = masker;
			paazio.addChild(juga);
			*/
		}
		
		private function createBorders():void
		{
			var borders:Shape = new Shape();
			borders.name = "borders";
			borders.graphics.lineStyle(1, 0x000000);
			borders.graphics.drawRoundRect(1, 1, _width - 2, _height - 2, 20, 20);
			borders.cacheAsBitmap = true;
			addChild(borders);
		}

		private function createFlickrBalls():void
		{
			flickrBalls = new Sprite();
			flickrBalls.name = "flickrBalls";
			flickrBalls.mouseChildren = false;
			flickrBalls.mouseEnabled = false;
			flickrBalls.visible = false;
			addChild(flickrBalls);

			var gra:Graphics;
			// Blue ball initially on the left side.
			var blue:Shape = new Shape();
			blue.name = "blue";
			blue.x = -4;
			flickrBalls.addChildAt(blue, 0);
			gra = blue.graphics;
			gra.beginFill(0x0063C8, 0.8);
			gra.drawCircle(0, 0, 4);
			gra.endFill();
			
			// Red ball initially on the right side.
			var red:Shape = new Shape();
			red.name = "red";
			red.x = 4;
			flickrBalls.addChildAt(red, 1);
			gra = red.graphics;
			gra.beginFill(0xFF0084, 0.8);
			gra.drawCircle(0, 0, 4);
			gra.endFill();
		}

		private function createTitleField():void
		{
			var format:TextFormat = new TextFormat();
			format.font = "nrkis";
			format.color = 0xFFFFFF;
			format.size = 14;

			titleField = new TextField();
			titleField.name = "titleField";
			titleField.defaultTextFormat = format;
			titleField.embedFonts = true;
			titleField.autoSize = TextFieldAutoSize.CENTER;
			titleField.antiAliasType = AntiAliasType.ADVANCED;
			titleField.selectable = false;
			titleField.background = false;
			titleField.border = false;
			titleField.mouseEnabled = false;
			titleField.x = _width / 2;
			titleField.y = 8;
			titleField.cacheAsBitmap = false;
			titleField.visible = false;
			addChild(titleField);
		}

		private function createCarouselItem(inx:uint):void
		{
			// Create white 1px border.
			var bmp:BitmapData = new BitmapData(thumbSide + 2, thumbSide + 2, true, 0x66FFFFFF);
			var material:BitmapMaterial = new BitmapMaterial(bmp);
			material.smooth = true;
			material.doubleSided = true;
			//material.oneSide = true;
			material.opposite = false;
			material.updateBitmap();

			var rotation:Number = (360 / photos) * (inx - 1);
			var radians:Number = rotation * (Math.PI / 180);

			var plane:Plane = new Plane(material, bmp.width, bmp.height);
			plane.z = radius * Math.cos(radians);
			plane.x = radius * Math.sin(radians);
			plane.y = 60;
			plane.name = "plane_" + inx;
			scene.addChild(plane);

			var cont:Sprite = plane.container;
			cont.buttonMode = true;
			cont.name = inx.toString();
			cont.buttonMode = true;
			cont.mouseChildren = false;
			cont.addEventListener(MouseEvent.CLICK, onPhotoClick);
			cont.addEventListener(MouseEvent.MOUSE_OVER, onPhotoOver);
			cont.addEventListener(MouseEvent.MOUSE_OUT, onPhotoOut);
			/*
			var blurAmount:Number = (radius - plane.z) / (radius * 2);
			var blur:BlurFilter = new BlurFilter((blurAmount * blurMax) / Math.abs(rotation), blurAmount * blurMax, BitmapFilterQuality.LOW);
			var filters:Array = [blur];
			cont.filters = filters;
			*/
			var obj:Object = new Object();
			obj.plane = plane;
			obj.rotation = rotation;
			thumbArray.push(obj);
		}

		private function loadSetList():void
		{
			var variables:URLVariables = new URLVariables();
			variables.api_key = apiKey;
			variables.user_id = userId;
			variables.method = "flickr.photosets.getList";

			var request:URLRequest = new URLRequest(apiUrl);
			request.data = variables;

			rest.addEventListener(Event.COMPLETE, onSetsComplete);
			rest.load(request);

			viewIsSetList = true;
			resetScene();
		}

		private function loadPhotoList(setId:String):void
		{
			var variables:URLVariables = new URLVariables();
			variables.api_key = apiKey;
			variables.method = "flickr.photosets.getPhotos";
			variables.photoset_id = setId;

			var request:URLRequest = new URLRequest(apiUrl);
			request.data = variables;

			rest.addEventListener(Event.COMPLETE, onListComplete);
			rest.load(request);

			viewIsSetList = false;
			resetScene();
		}

		// Called when the previous item has loaded. This way only one file is loaded at a time.
		private function loadPhoto(inx:uint):void
		{
			var url:String = getImageUrl(inx);

			var request:URLRequest = new URLRequest(url);

			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;

			var loader:Loader = new Loader();
			loader.name = "loader_" + inx;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(request, context);
		}

		private function startLoadingPhotos():void
		{
			// Recalculate dimensions.
			try
			{
				radius = (capBetween + thumbSide) * photos / (Math.PI * 2);
				camera.y = capBetween / 2 + thumbSide;
				camera.z = radius + 60;
			}
			catch (e:Error)
			{
				tracer("startLoadingPhotos. radius. " + e.toString());
			}
			//tracer("Photoset XML loaded. photos: " + photos + ", radius: " + radius + ", camera.y: " + camera.y + ", camera.z: " + camera.z);

			// Create the amount of planes needed for the photos.
			for (var i:uint = 0; i < photos; ++i)
			{
				createCarouselItem(i);
			}
			
			addEventListener(KeyboardEvent.KEY_DOWN, onArrowKeyDown);
			
			// Load the first photo.
			loadPhoto(currentIndex);
		}

		private function rotateAll(rotate:Number):void
		{
			var len:uint = thumbArray.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var obj:Object = thumbArray[i] as Object;
				// New rotation calculation, first degrees, then radians.
				var rotation:Number = obj.rotation + rotate;
				var radians:Number = rotation * (Math.PI / 180);
				var rotZ:Number = radius * Math.cos(radians);
				var rotX:Number = radius * Math.sin(radians);
				TweenLite.to(obj.plane, 0.35, {z: rotZ, x: rotX, ease: Linear.easeOut});

				// Calculate blur according to the distance.
				var speedDiff:Number = Math.abs(obj.rotation - rotation) * 5;
				speedDiff = Math.abs(obj.rotation) * 5
				/*
				var blurAmount:Number = 0.5; //(radius - rotZ) / (radius * 2);
				var blur:BlurFilter = new BlurFilter((blurAmount * blurMax) + speedDiff, blurAmount * blurMax, BitmapFilterQuality.LOW);
				var filters:Array = [blur];
				obj.plane.container.filters = filters;
				*/
				// Remember the new target rotation.
				obj.rotation = rotation;
			}
		}

		private function getImageUrl(inx:uint):String {
			/*
			http://www.flickr.com/services/api/misc.urls.html

				http://farm1.static.flickr.com/2/1418878_1e92283336_m.jpg
				farm-id: 1
				server-id: 2
				photo-id: 1418878
				secret: 1e92283336
				size: m
			*/
			var item:XML;
			var url:String = "http://farm";

			try
			{
				if (viewIsSetList)
				{
					/*
					<photoset id="72157602185431246" primary="1452413827" secret="c97af94ccd" server="1171" farm="2" photos="9">
						<title>Kobudo - Helsinki (FI) - 2005/10/15</title>
						<description>Saturday morning training in Helsinki Stadion.</description>
					</photoset>
					*/
					item = photoSets.photosets.photoset[inx] as XML;
					url += item.@farm.toString() + ".static.flickr.com/" + item.@server.toString() + "/" + item.@primary.toString() + "_" + item.@secret.toString();
				}
				else
				{
					/*
					<photo id="1453149742" secret="71e18e70ac" server="1164" farm="2" title="Kobudo2005-10-09_50" isprimary="1"/>
					*/
					item = photoList.photoset.photo[inx] as XML;
					url += item.@farm.toString() + ".static.flickr.com/" + item.@server.toString() + "/" + item.@id.toString() + "_" + item.@secret.toString();
				}
			}
			catch (e:Error)
			{
				tracer("getImageUrl. inx: " + inx + ", viewIsSetList: " + viewIsSetList + ". Error: " + e.toString());
			}

			url += ".jpg";
			return url;
		}

		private function getTitle(inx:uint):String
		{
			var title:String;

			try
			{
				if (viewIsSetList)
				{
					title = photoSets.photosets.photoset[inx].title.toString();
				}
				else
				{
					title = photoList.photoset.photo[inx].@title.toString();
				}
			}
			catch (e:Error)
			{
				tracer("getTitle. viewIsSetList: " + viewIsSetList + ". Error: " + e.toString());
			}

			return title;
		}

		private function resetScene():void
		{
			// Reset and clean up, preparation for the new items in carousel.
			thumbArray = [];
			for (var i:uint = 0; i < photos; ++i)
			{
				scene.removeChildByName("plane_" + i);
			}
		}

		private function onSetsComplete(event:Event):void
		{
			Mouse.show();
			flickrBalls.visible = false;
			rest.removeEventListener(Event.COMPLETE, onSetsComplete);
			photoSets = new XML(rest.data);
			photos = photoSets.photosets.elements().length();
			startLoadingPhotos();
		}

		private function onListComplete(event:Event):void
		{
			rest.removeEventListener(Event.COMPLETE, onListComplete);
			photoList = new XML(rest.data);
			photos = photoList.photoset.elements().length();
			startLoadingPhotos();
		}

		private function onEnterFlickrBalls(event:Event):void
		{
			flickrBalls.x = mouseX;
			flickrBalls.y = mouseY;
			var blue:Shape = flickrBalls.getChildAt(0) as Shape;
			var red:Shape = flickrBalls.getChildAt(1) as Shape;
			if (flickrBallsDirection > 0)
			{
				// Blue should increase x, red should decrease x.
				if (blue.x >= 4)
				{
					// Limit has been reached, change direction.
					flickrBallsDirection *= -1;
				}
			}
			else
			{
				// Blue should decrease x, red should increase x.
				if (blue.x <= -4)
				{
					// Limit has been reached, change direction.
					flickrBallsDirection *= -1;
				}
			}
			blue.x += flickrBallsDirection;
			red.x += flickrBallsDirection * -1;
		}
		
		private function onPaazioMouse(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			TweenLite.killTweensOf(sp);
			
			if (event.type == MouseEvent.MOUSE_OVER)
			{
				TweenLite.to(sp, 1, {type: "color", colorize: 0xFF0000, amount: 1, overwrite: false});
				TweenLite.to(sp, 1, {type: "blur", blurX: "8", blurY: "2", overwrite: false});
			}
			else if (event.type == MouseEvent.MOUSE_OUT)
			{
				
			}
		}
		
		private function onStageResize(event:Event):void
		{
			paazio.y = (stage.stageHeight - paazio.height) / 2;
			
			sammakko.x = stage.stageWidth - (sammakko.width + 4);
			sammakko.y = (stage.stageHeight - sammakko.height) / 2;
		}

		private function onSammakkoMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.CLICK)
			{
				// Load a list of photosets.
				titleField.text = "Loading a list of photosets from Flickr...";
				sammakko.removeEventListener(MouseEvent.CLICK, onSammakkoMouse);
				sammakko.removeEventListener(MouseEvent.MOUSE_OVER, onSammakkoMouse);
				sammakko.removeEventListener(MouseEvent.MOUSE_OUT, onSammakkoMouse);
				loadSetList();
			}
			else if (event.type == MouseEvent.DOUBLE_CLICK)
			{
				//stage.displayState
			}
			else if (event.type == MouseEvent.MOUSE_OVER)
			{
				titleField.text = "Click to load my photosets from Flickr";
				titleField.visible = true;
				Mouse.hide();
				flickrBalls.visible = true;
				flickrBalls.addEventListener(Event.ENTER_FRAME, onEnterFlickrBalls);
			}
			else if (event.type == MouseEvent.MOUSE_OUT)
			{
				titleField.text = "";
				titleField.visible = false;
				Mouse.show();
				flickrBalls.visible = false;
				flickrBalls.removeEventListener(Event.ENTER_FRAME, onEnterFlickrBalls);
			}
		}

		private function onPhotoClick(event:MouseEvent):void
		{
			var targ:Sprite = event.target as Sprite;
			var inx:uint = parseInt(targ.name);
			// Open the photo in thickbox if the list is of photoset, else load the photoset.
			
			TweenFilterLite.to(targ, 1, {type:"Color", colorize:0xFF0000, amount:1});

			if (viewIsSetList)
			{
				var setId:String = photoSets.photosets.photoset[inx].@id.toString();
				loadPhotoList(setId);
			}
			else
			{
				// 500 bigger side photo is without additional "_x" ending.
				var url:String = getImageUrl(inx);
				var title:String = getTitle(inx);
				tracer("AS. url: " + url + ", title: " + title);
				if (ExternalInterface.available)
				{
					ExternalInterface.call("openPhotoWindow", url, title);
				}
			}
		}

		private function onPhotoOver(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			var inx:uint = parseInt(sp.name);
			var title:String = getTitle(inx);
			
			TweenLite.to(sp, 1, {type: "color", colorize: 0xFF0000, amount: 1});

			titleField.text = title;
			titleField.visible = true;
		}

		private function onPhotoOut(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			
			TweenLite.to(sp, 1, {type: "color", colorize: 0xFF0000, amount: 0});
			
			titleField.visible = false;
		}

		private function onPhotoComplete(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);

			var info:LoaderInfo = loader.contentLoaderInfo;
			info.removeEventListener(Event.COMPLETE, onPhotoComplete);
			info.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);

			var bitmap:Bitmap = loader.content as Bitmap;
			var obj:Object = thumbArray[currentIndex] as Object;
			var plane:Plane = obj.plane as Plane;

			var material:BitmapMaterial = plane.material as BitmapMaterial;

			var bmp:BitmapData = material.bitmap as BitmapData;
			var rect:Rectangle = new Rectangle(0, 0, bmp.width, bmp.height);
			bmp.fillRect(rect, 0xFFFFFFFF);
			bmp.copyPixels(bitmap.bitmapData, new Rectangle(0, 0, thumbSide, thumbSide), new Point(1, 1));

			material.opposite = true;
			material.updateBitmap();


			// Clean up memory.
			loader = null;

			currentIndex++;

			// Load the next photo.
			if (currentIndex < photos)
			{
				loadPhoto(currentIndex);
			}
			else
			{
				// Last photo loaded.
				titleField.text = "";
				//tracer("Last photo loaded. photos: " + photos.toString() + ", currentIndex: " + currentIndex.toString());
			}
		}

		private function onEnterFrame(event:Event):void
		{
			scene.renderCamera(camera);
		}

		private function onMouseEnterFrame(event:Event):void
		{
			var rotate:Number = (container.mouseX / 50) / (photos / 10);
			rotateAll(rotate);
		}

		private function onArrowKeyDown(event:KeyboardEvent):void
		{
			var rotate:Number = 360 / photos;
			switch (event.keyCode)
			{
				case Keyboard.LEFT :
					rotateAll(-1 * rotate);
					break;
					
				case Keyboard.RIGHT :
					rotateAll(rotate);
					break;
			}
		}

		private function onIOError(event:IOErrorEvent):void
		{
			tracer("onIOError: " + event.toString());
		}

		private function onSecurityError(event:SecurityError):void
		{
			tracer("onSecurityError: " + event.toString());
		}
		
		private function tracer(msg:Object):void
		{
			trace(msg.toString());
			if (ExternalInterface.available)
			{
				ExternalInterface.call("console.log", msg.toString());
			}
		}
	}
}
