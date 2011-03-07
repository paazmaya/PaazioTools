/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.ui.Keyboard;
	import flash.system.Security;
	import flash.utils.Timer;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]

	/**
	 * Fetch all images tagged with "yuganoichi" and display in a cluster.
	 * @see http://www.flickr.com/services/api/
	 */
	public class FlickrClusterTest extends MovieClip
	{
		private const TAG:String = "yuganoichi";
		private const API_KEY:String = "1862cc3a9e0d9d16ac3333075d29154e"; // paazio.nanbudo.fi
		private const API_URL:String = "http://api.flickr.com/services/rest/";
		private const USER_ID:String = "14224905@N08"; // paazio
		
		private var _container:Sprite;
		private var _photoList:XMLList;
		private var _loadingIndex:int = -1;
		private var _photos:Vector.<Bitmap>;
	
		private var hsw:Number;
		private var hsh:Number;
		private var points3D:Vector.<Number>;
		private var points2D:Vector.<Number>;
		private var uvts:Vector.<Number>;
		private var sorted:Array = [];
		private var pnt:Point;
		private var m:Matrix3D;
		private var v:Vector3D;
		private var p:PerspectiveProjection;
		private var proj:Matrix3D;
		private var dx:Number;
		private var dy:Number;


		public function FlickrClusterTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			Security.loadPolicyFile( "http://api.flickr.com/crossdomain.xml" );
			
			_container = new Sprite();
			addChild(_container);
			
			_photos = new Vector.<Bitmap>();
			
			getTagPhotos();
		}
		
		private function getTagPhotos():void
		{
			var vars:URLVariables = new URLVariables();
			vars.api_key = API_KEY;
			vars.user_id = USER_ID;
			vars.method = "flickr.photos.search";
			vars.tags = TAG;

			var request:URLRequest = new URLRequest( API_URL );
			request.data = vars;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onTagPhotosLoaded );
			loader.load( request );
		}
		
		private function onTagPhotosLoaded(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			trace("onTagPhotosLoaded. loader.data: " + loader.data);
			
			var data:XML = new XML(loader.data);
			_photoList = data.photos.children();
			
			trace("onTagPhotosLoaded. _photoList: " + _photoList);
			loadPhoto();
		}
		
		
		// <photo id="2484" secret="123456" server="1" title="my photo" isprimary="0" />
		private function loadPhoto():void
		{
			++_loadingIndex;
			if (_photoList.length() <= _loadingIndex)
			{
				createCluster();
				return;
			}
			var data:XML = _photoList[_loadingIndex];
			var loader:Loader = new Loader();
			var cx:LoaderContext = new LoaderContext();
			cx.checkPolicyFile = true;

			var url:String = "http://farm" + data.@farm + ".static.flickr.com/" + data.@server +
				"/" + data.@id + "_" + data.@secret + "_s.jpg";
			var request:URLRequest = new URLRequest( url );
			trace( "Loading... " + url );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load( request, cx );
		}
		
		private function onLoadComplete(event:Event):void
		{
			var info:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = info.loader;
			var bm:Bitmap = loader.content as Bitmap;
			addChild(bm);
			_photos.push(bm);
			
			loadPhoto();
		}

		private function createCluster():void
		{
			hsw = stage.stageWidth / 2;
			hsh = stage.stageHeight / 2;
			
			points3D = new Vector.<Number>();
			points2D = new Vector.<Number>();
			uvts = new Vector.<Number>();
			
			pnt = new Point();
			m = new Matrix3D();
			v = new Vector3D();
			var len:uint = _photos.length;
			
			for (var i:int = 0; i < len; ++i)
			{
				v.x = Math.random()*400-200;
				m.identity();
				m.appendRotation(Math.random()*360, Vector3D.X_AXIS);
				m.appendRotation(Math.random()*360, Vector3D.Y_AXIS);
				m.appendRotation(Math.random()*360, Vector3D.Z_AXIS);
				v = m.transformVector(v);
				points3D.push(v.x, v.y, v.z);
				points2D.push(0,0);
				uvts.push(0,0,0);
				sorted.push(new Vector3D());
			}
			points3D.fixed = true;
			points2D.fixed = true;
			uvts.fixed = true;
			
			p = new PerspectiveProjection();
			proj = p.toMatrix3D();
			
			dx = 0, dy = 0;
			addEventListener(Event.ENTER_FRAME, onLoop);
			

		}

		private function onLoop(event:Event):void
		{
			var gr:Graphics = _container.graphics;
			gr.clear();
			
			
			dx += (mouseX - dx) / 4;
			dy += (mouseY - dy) / 4;
			m.identity();
			m.appendRotation(dx, Vector3D.Y_AXIS);
			m.appendRotation(dy, Vector3D.X_AXIS);
			m.appendTranslation(0, 0, 1000);
			m.append(proj);
			
			Utils3D.projectVectors(m, points3D, points2D, uvts);
			
			var i:uint = 0;
			var j:uint = 0;
			var len:uint = points2D.length;
			
			while ( i < len )
			{
				sorted[j].x = points2D[i] + hsw;
				sorted[j].y = points2D[i + 1] + hsh;
				sorted[j].z = uvts[j * 3 + 2];
				i += 2;
				++j;
			}
			
			sorted.sortOn("z", Array.NUMERIC);
			i = 0;
			len = sorted.length;
			
			while ( i < len )
			{
				var bm:Bitmap = _photos[i];
				bm.x = sorted[i].x;
				bm.y = sorted[i].y;
				bm.z = sorted[i].z;
				/*
				var zpos:Number = sorted[i].z * 12000;
				var c:int = zpos * 14;
				//c = (c > 255) ? 255 : c;
				gr.beginFill(c << 16 | c << 8 | c);
				gr.drawCircle(sorted[i].x, sorted[i].y, zpos);
				gr.endFill();
				*/
				++i;
			}
		}
		
	}

}
