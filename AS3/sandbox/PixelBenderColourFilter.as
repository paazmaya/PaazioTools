/**
 * @mxmlc -target-player=10.0.0
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.ShaderFilter;
	import flash.media.Video;
	import flash.net.*;
	import flash.utils.getQualifiedClassName;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PixelBenderColourFilter extends Sprite
	{
		private var video:Video;
		private var ns:NetStream;
		private var nc:NetConnection;
		private var colourFilter:ShaderFilter;
		private var shader:Shader;
		
		public function PixelBenderColourFilter()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			createVideoPlayer( );
			loadShader( );
			play( );
		}

		private function loadShader():void
		{
			var loader:URLLoader = new URLLoader( );
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener( Event.COMPLETE, complete );
			loader.load( new URLRequest( "assets/PixelBenderColourFilter.pbj" ) );
		}

		private function complete( event:Event ):void
		{
			shader = new Shader( event.target.data );
			addEventListener( Event.ENTER_FRAME, enterFrame );
		}

		private function enterFrame( event:Event ):void
		{
			shader.data.center.value = [video.width / 2, video.height / 2];
			shader.data.vignetteInnerSize.value = [0.5];
			shader.data.vignetteOuterSize.value = [500];
			shader.data.saturation.value = [mouseX / stage.stageWidth * 2];
			shader.data.contrast.value = [mouseY / stage.stageHeight * 2];
			colourFilter = new ShaderFilter( shader );
			video.filters = [ colourFilter ];
		}
		
		private function createVideoPlayer():void
		{
			nc = new NetConnection( );
			nc.client = { };
			nc.connect( null );
			
			ns = new NetStream( nc );
			ns.client = {onCuePoint: cuePointHandler};
			ns.bufferTime = 6;
			
			video = new Video( 640, 480 );
			video.x = (stage.stageWidth - video.width) / 2;
			video.y = (stage.stageHeight - video.height) / 2;
			video.attachNetStream( ns );
			video.smoothing = true;
			addChild( video );
		}
		
		private function cuePointHandler( info:Object ):void
		{
			switch ( info.name )
			{
				case "Red"	 : shader.data.tintR.value = [0.3]; break;
				case "Green" : shader.data.tintG.value = [0.5];break;
				case "Blue"  : shader.data.tintB.value = [0.5];break;
				case "exit"  : shader.data.tintR.value = [0.0];
							   shader.data.tintG.value = [0.0];
							   shader.data.tintB.value = [0.0];
							   break;
				default		 : break;
			}
		}
		
		public function play():void
		{
			ns.play( "assets/kamnisko_sedlo2007-05-11.mp4" );
		}

		override public function toString():String
		{
			return getQualifiedClassName( this );
		}
	}
}


