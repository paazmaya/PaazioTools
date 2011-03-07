/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
		
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.parsers.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.objects.special.*;
	import org.papervision3d.view.*;
	import org.papervision3d.render.QuadrantRenderEngine;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.core.*;
	import org.papervision3d.scenes.Scene3D;
	
	import com.greensock.TweenLite;

	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]

	public class ColladaLoad extends Sprite
	{
			
		private var scene:Scene3D;
		private var view:Viewport3D;
		private var renderer:QuadrantRenderEngine;
		private var collada:Collada;
		private var dae:DAE; // COLLADA 1.4.1 file.
		
		private var gateway:String = "http://paazio.nanbudo.fi/amf-server.php";
		private var connection:NetConnection;
		private var responder:Responder;

		public function ColladaLoad()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		public function onInit(event:Event):void
		{

			responder = new Responder(onResult, onFault);
			
			connection = new NetConnection();
			connection.objectEncoding = ObjectEncoding.AMF3;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			connection.connect(gateway);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function loadDAE():void
		{
			dae = new DAE();

			dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, myOnLoadCompleteHandler);
			dae.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, myOnAnimationsCompleteHandler);
			dae.addEventListener(FileLoadEvent.ANIMATIONS_PROGRESS, myOnAnimationsProgressHandler);

			dae.load( "path/to/collada" );


		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			trace("onNetStatus. " + event.info);
		}
		
		private function onEnterFrame(event:Event):void
		{
			
		}
		
		public function onComplete( event:Event ):void{
			var params = "Sent to Server";
			connection.call("World.hello", responder, params);
		}

		private function onResult(result:Object):void
		{
			// Display the returned data
			trace(String(result));
		}
		
		private function onFault(fault:Object):void
		{
			trace(String(fault.description));
		}

	}
}
