/**
 * @mxmlc -target-player=10.0.0 -debug -incremental=false -noplay -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.LoaderContext;
	import flash.filters.*;

	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.events.*;
	import org.papervision3d.core.proto.*;
	import org.papervision3d.core.*;
	import org.papervision3d.view.*;
	import org.papervision3d.render.*;
	
	import org.paazio.utils.Console;
	import org.paazio.FlickrLoader;

	import caurina.transitions.Tweener;

	public class CoverPile extends Sprite
	{
		
		private var apiKey:String = "1862cc3a9e0d9d16ac3333075d29154e"; // paazio.nanbudo.fi
		private var apiUrl:String = "http://api.flickr.com/services/rest/";
		private var userId:String = "14224905@N08"; // paazio
		private var psetid:String = "72157602182855142"; // Nanbudo - Cesena
		private var thumbSize:String = "s";

		private var viewport:Viewport3D;
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var renderer:BasicRenderEngine;

		private var planeByContainer :Dictionary = new Dictionary();

		private var paperSize 		:Number = 2;
		private var rotSize   		:Number = 0;
		private var maxAlbums 		:Number = 100;
		private var currentNum 		:uint = 0;
		
		private var albumCrate		:Array;
		private var currentAlbum	:Number = 1;
		private var selectedGoTo	:DisplayObject3D;
		
		public var iFull :SimpleButton = new SimpleButton();
		
		private var rest:URLLoader;
		private var photoList:XML;
		private var photoData:Array = [];
		private var photos:uint;
		
		//private var flickr:FlickrLoader;

		public function CoverPile()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			iFull.visible = stage.hasOwnProperty("displayState");
			iFull.addEventListener(MouseEvent.MOUSE_OVER, submitInteraction);
			iFull.addEventListener(MouseEvent.MOUSE_OUT, submitInteraction);
			iFull.addEventListener(MouseEvent.CLICK, submitInteraction);
			addChild(iFull);
			
			viewport = new Viewport3D(0, 0, true, true);
			viewport.name = "viewport";
			addChild(viewport);
			
			renderer = new BasicRenderEngine();
			
			scene = new Scene3D();
			
			camera = new Camera3D();
			camera.name = "camera";
			camera.zoom = 5;

			camera.extra = {
				goPosition: new DisplayObject3D(),
				goTarget:   new DisplayObject3D()
			};

			camera.extra.goPosition.copyPosition( camera );
			
			albumCrate = new Array();
			
			selectedGoTo = new DisplayObject3D();
			selectedGoTo.x = 0;
			selectedGoTo.y = 0;
			selectedGoTo.z = -420;
			
			rest = new URLLoader();
			rest.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			rest.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		
			loadPhotoList("72157602192912945"); // Kobudo - Turku (FI) - 2005/10
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function submitInteraction(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
					Tweener.addTween(event.currentTarget, {alpha: 1, time:.2, transition:"easeoutquad"});
					return;
				case MouseEvent.MOUSE_OUT :
					Tweener.addTween(event.currentTarget, {alpha: .7, time:.2, transition:"easeoutquad"});
					return;
				case MouseEvent.CLICK :
					goFull();
					return;
			}
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
		}
		
		private function onListComplete(event:Event):void
		{
			rest.removeEventListener(Event.COMPLETE, onListComplete);
			photoList = new XML(rest.data);
			photos = photoList.photoset.elements().length();
			
			Console.log("Photoset XML loaded. photos: " + photos.toString());

			// Load all photos.
			loadPhoto(currentNum);
		}
		private function loadPhoto(inx:uint):void
		{
			var server:String = photoList..photo[inx].@server.toString();
			var farm:String = photoList..photo[inx].@farm.toString();
			var id:String = photoList..photo[inx].@id.toString();
			var secret:String = photoList..photo[inx].@secret.toString();
			var title:String = photoList..photo[inx].@title.toString();
			
			var context:JPEGLoaderContext = new JPEGLoaderContext();
			context.deblockingFilter = 0.5;
			context.checkPolicyFile = true;

			var loader:Loader = new Loader();
			var url:String =  "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret + "_" + thumbSize + ".jpg";
			var request:URLRequest = new URLRequest(url);

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(request, context);
			
		}
		private function onPhotoComplete(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);
			var info:LoaderInfo = LoaderInfo(loader.contentLoaderInfo);
			info.removeEventListener(Event.COMPLETE, onPhotoComplete);
			info.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			var bitmap:Bitmap = loader.content as Bitmap;
			
			photoData.push(bitmap.bitmapData);
			
			loader = null;
			
			createAlbum(currentNum);
			currentNum++;
			
			// Load the next photo.
			if (currentNum < photos)
			{
				loadPhoto(currentNum);
			}
			else {
				// Last photo loaded.
				Console.timeEnd("imageload");
				Console.log("Last photo loaded. photos: " + photos.toString() + ", currentIndex: " + currentNum.toString());
			}
		}


		private function createAlbum(inx:uint):void
		{
			var bmData:BitmapData = photoData[inx] as BitmapData;
			
			Console.log("createAlbum(). inx: " + inx + ", bitmap h: " + bmData.height + ", w: " + bmData.width);
			
			var material:BitmapMaterial = new BitmapMaterial(bmData);

			material.doubleSided = true;
			material.lineColor = 0xFFFFFF;
			material.updateBitmap();

			var plane :Plane = new Plane( material, paperSize, 4, 0, 2 );

			var gotoData :DisplayObject3D = new DisplayObject3D();
			gotoData.x = 300 + currentNum * 20;
			gotoData.y = currentNum * 20;
			gotoData.z = currentNum * 20;
			gotoData.rotationX = 0;
			gotoData.rotationY = 0;
			gotoData.rotationZ = 0;

			plane.extra = {
				id:		currentNum,
				goto:	gotoData
			};

			// Include in scene
			scene.addChild( plane, "Album" + String( currentNum ) );
			albumCrate[currentNum] = plane;
			
			/*
			var container:Sprite = plane.container;
			container.buttonMode = true;
			container.addEventListener( MouseEvent.ROLL_OVER, doRollOver );
			container.addEventListener( MouseEvent.ROLL_OUT, doRollOut );
			container.addEventListener( MouseEvent.MOUSE_DOWN, doPress );
			 */

			//planeByContainer[ container ] = plane;
		}

		private function doPress(event:Event):void
		{
			var plane:Plane = planeByContainer[ event.target ] as Plane;
			plane.scaleX = 1;
			plane.scaleY = 1;

			var target :DisplayObject3D = new DisplayObject3D();

			target.copyTransform( plane );
			target.moveBackward( 350 );

			camera.extra.goPosition.copyPosition( target );
			camera.extra.goTarget.copyPosition( plane );
			currentAlbum = plane.extra.id;
			trace("currentAlbum:"+currentAlbum);
			resortAlbums();
		};

		private function doRollOver(event:Event):void
		{
			var plane:Plane = planeByContainer[ event.target ] as Plane;
			var extra:Object = plane.extra as Object;
			extra.goto.y = plane.y + 140;
		};

		private function doRollOut(event:Event):void
		{
			var plane:Plane = planeByContainer[ event.target ] as Plane;
			var extra:Object = plane.extra as Object;
			extra.goto.y = plane.y - 140;
		};

		private function update3D():void
		{
			renderer.renderScene(scene, camera, viewport);
		}
		
		private function onEnterFrame(event:Event):void
		{
			update3D();
		}
		
		private function resortAlbums():void
		{
			var i:Number;
			var paper :DisplayObject3D;
			
			for( i=1; paper = scene.getChildByName( "Album"+i ); ++i )
			{
				if ( i == currentAlbum ) break;
				
				var target0:DisplayObject3D = paper;
				var xTarget0:Number = -400 - ((currentAlbum - i) * 20);
				var yTarget0:Number = (currentAlbum - i)  * 20;
				var zTarget0:Number = (currentAlbum - i)  * 20;
				
				Tweener.addTween(target0, {x:xTarget0, y:yTarget0, z:zTarget0, rotationX:0, rotationY:-60, rotationZ:0, time:.7, transition:"easeinoutexpo"});
			}
			
			{
				paper = scene.getChildByName( "Album"+currentAlbum );
				var target1:DisplayObject3D = paper;
				Tweener.addTween(target1, {x:selectedGoTo.x, y:selectedGoTo.y, z:selectedGoTo.z, rotationX:0, rotationY:0, rotationZ:0, time:.7, transition:"easeinoutexpo"});
			}
			
			for( i=currentAlbum+1; paper = scene.getChildByName( "Album"+i ); ++i )
			{
				var target:DisplayObject3D = paper;
				var xTarget:Number = 400 + ((i - currentAlbum) * 20);
				var yTarget:Number = (i - currentAlbum)  * 20;
				var zTarget:Number = (i - currentAlbum)  * 20;
				
				Tweener.addTween(target, {x:xTarget, y:yTarget, z:zTarget, rotationX:0, rotationY:60, rotationZ:0, time:.7, transition:"easeinoutexpo"});
			}
		}


		private function goFull():void
		{
			if( stage.hasOwnProperty("displayState") )
			{
				if( stage.displayState != StageDisplayState.FULL_SCREEN )
					stage.displayState = StageDisplayState.FULL_SCREEN;
				else
					stage.displayState = StageDisplayState.NORMAL;
			}
		}
		private function onIOError(event:IOErrorEvent):void
		{
            Console.error("onIOError: " + event);
        }
		
		private function onSecurityError(event:SecurityError):void
		{
            Console.error("onSecurityError: " + event.toString());
        }
	}
}
