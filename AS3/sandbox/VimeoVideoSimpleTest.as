/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
    import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.*;
	import flash.system.Security;
	import flash.ui.Keyboard;
	
	import com.adobe.serialization.json.JSON;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * Test the use of Vimeo Simple API.
	 * @see http://www.vimeo.com/api/docs/simple-api
	 * @see http://www.vimeo.com/api/docs/moogaloop
	 */
    public class VimeoVideoSimpleTest extends Sprite
    {
		private const VIMEO_DOMAIN:String = "http://vimeo.com";
		/**
		 * http://vimeo.com/api/v2/username/request.output
		 * http://vimeo.com/api/v2/video/video_id.output
		 *
		 * http://vimeo.com/api/v2/paazmaya/info.json
		 * http://vimeo.com/api/v2/paazmaya/videos.json
		 *
		 * Returns an array of possible videos.
		 */
		private var _dataUrl:String = VIMEO_DOMAIN + "/api/v2/paazmaya/videos.json";
		
		/**
		 * Url to use with the video url.
		 * uses oEmbed protocol and return one object.
		 */
		private var _embedUrl:String = VIMEO_DOMAIN + "/api/oembed.json?url=";
		
		private var _policyUrl:String = VIMEO_DOMAIN + "/crossdomain.xml";
		
		private var _moogaUrl:String = VIMEO_DOMAIN + "/moogaloop.swf";
				
		private var _videos:Array = [];
		private var _index:int = -1;
		
		
		private var _player:Sprite;
		
		private var _context:LoaderContext;
		
		
		[Embed(source = "../assets/Vera.ttf", fontFamily = "vera")]
		private var Vera:String;
		
		/**
		 *
		 */
        public function VimeoVideoSimpleTest()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			Security.allowDomain(VIMEO_DOMAIN);
			Security.loadPolicyFile(_policyUrl);
			
			trace("sandboxType: " + Security.sandboxType);
			
			_player = new Sprite();
			_player.name = "player";
			addChild(_player);
			
			_context = new LoaderContext(true);
		}

		private function onResize(event:Event):void
		{
			
		}
		
		/**
		 * Thumbnails sizes:
		 * # 100x75 (small)
		 * # 200x150 (medium)
		 * # 640px width (large)
		 * @param	index
		 * @return
		 */
		private function drawBlock(index:uint):Sprite
		{
			var w:Number = 400;
			var data:Object = _videos[index] as Object;
			
			var sp:Sprite = new Sprite();
			sp.name = "block_" + index.toString();
			sp.addEventListener(MouseEvent.CLICK, onBlockClick);
			sp.mouseChildren = false;
			
			var gra:Graphics = sp.graphics;
			gra.beginFill(0xF4F4F4, 0.7);
			gra.lineStyle(4, 0xC6C6C6, 0.7);
			gra.drawRoundRectComplex(0, 0, w, 150, 0, 20, 10, 30);
			gra.endFill();
			
			var thumb:Loader = new Loader();
			thumb.x = 4;
			thumb.y = 4;
			thumb.load(new URLRequest(data["thumbnail_small"] as String), _context);
			sp.addChild(thumb);
			
			var title:TextField = createField(data["title"] as String, 18, true);
			title.x = 108;
			title.y = 4;
			title.width = w - 112;
			sp.addChild(title);
			
			var description:TextField = createField(data["description"] as String, 12);
			description.x = 4;
			description.y = 83;
			description.width = w - 8;
			sp.addChild(description);
			
			return sp;
		}
		
		private function onBlockClick(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			trace("onBlockClick. sp: " + sp.name);
			var index:int = parseInt(sp.name.split("_").pop());
			loadVideo(index);
		}
		
		private function createField(text:String, size:int, bold:Boolean = false):TextField
		{
			var format:TextFormat = new TextFormat();
			format.size = size;
			format.bold = bold;
			format.font = "vera";
			format.color = 0x000000;
			format.align = TextFormatAlign.LEFT;
			
			var field:TextField = new TextField();
			field.multiline = true;
			field.wordWrap = true;
			field.defaultTextFormat = format;
			field.htmlText = text;
			return field;
		}

		private function loadData(url:String, isEmbedData:Boolean = false):void
		{
			var loader:URLLoader = new URLLoader();
			if (isEmbedData)
			{
				loader.addEventListener(Event.COMPLETE, onEmbedDataComplete);
			}
			else
			{
				loader.addEventListener(Event.COMPLETE, onDataComplete);
			}
			loader.load(new URLRequest(url));
		}
		
		private function onDataComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			_videos = JSON.decode(loader.data) as Array;
			//_videos = JSON.deserialize(loader.data) as Array;

			var margin:Number = 6;
			var yPos:Number = margin;
			var len:uint = _videos.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var obj:Object = _videos[i] as Object;
				for (var key:* in obj)
				{
					trace("_videos[" + i + "] " + key + ": " + obj[key]);
				}
				
				var sp:Sprite = drawBlock(i);
				sp.x = margin;
				sp.y = yPos;
				addChild(sp);
				
				yPos += sp.height + margin;
			}
		}
		
		private function loadVideo(index:uint):void
		{
			var data:Object = _videos[index] as Object;
			if (data != null)
			{
				//loadData(_embedUrl + data["url"] as String, true);
				for (var key:* in data)
				{
					trace("loadVideo. data. " + key + ": " + data[key]);
				}
				
				
				loadMooga(data["id"] as String, parseInt(data["width"]), parseInt(data["height"]));
			}
		}
		
		private function onEmbedDataComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var data:Object = JSON.decode(loader.data) as Object;
			//var data:Object = JSON.deserialize(loader.data) as Object;
			trace("onEmbedDataComplete. data: " + data);
			for (var key:* in data)
			{
				trace("data. " + key + ": " + data[key]);
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				loadData(_dataUrl);
			}
			else if (event.keyCode == Keyboard.LEFT)
			{
				// previous video
				_index--;
				if (_index < 0 && _videos.length > 0)
				{
					_index = _videos.length - 1;
				}
				loadVideo(_index);
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				// next video
				_index++;
				if (_index > _videos.length - 1 && _videos.length > 0)
				{
					_index = 0;
				}
				loadVideo(_index);
			}
		}
		
		private function loadMooga(id:String, w:int, h:int):void
		{
			var request:URLRequest = new URLRequest(_moogaUrl + "?clip_id=" + id + "&width=" + w + "&height=" + h);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMoogaComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onMoogaProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onMoogaIoError);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onMoogaHttpStatus);
			trace("loadMooga. url: " + request.url);
			loader.load(request, _context);
		}
		

		private function onMoogaComplete(event:Event):void
		{
			var info:LoaderInfo = event.target as LoaderInfo;
			trace("onMoogaComplete. actionScriptVersion: " + info.actionScriptVersion);
			var loader:Loader = info.loader;
			_player.addChild(loader.content);
		}

		private function onMoogaProgress(event:ProgressEvent):void
		{
			var percent:Number = event.bytesLoaded / event.bytesTotal;
			trace("onMoogaProgress. " + percent);
		}

		private function onMoogaIoError(event:IOErrorEvent):void
		{
			trace("onMoogaIoError. " + event.toString());
		}

		private function onMoogaHttpStatus(event:HTTPStatusEvent):void
		{
			trace("onMoogaHttpStatus. " + event.toString());
		}
    }
}
