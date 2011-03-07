/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import org.papervision3d.events.FileLoadEvent;
		
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
	
	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]

	public class DaeLoad extends Sprite
	{
			
		private var scene:Scene3D;
		private var view:Viewport3D;
		private var renderer:QuadrantRenderEngine;
		private var collada:Collada;


		public function DaeLoad()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		public function onInit(event:Event):void
		{
			loadDAE();

			
		}
		
		private function loadDAE():void
		{
			collada = new Collada();

			collada.addEventListener(FileLoadEvent.LOAD_COMPLETE, onLoadComplete);
			collada.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, onAnimationsComplete);
			collada.addEventListener(FileLoadEvent.ANIMATIONS_PROGRESS, onAnimationsProgress);

			collada.load("Nid.dae");


		}
		
		private function onLoadComplete(event:FileLoadEvent):void
		{
			trace("onLoadComplete. " + event.message);
		}
		
		private function onAnimationsComplete(event:FileLoadEvent):void
		{
			trace("onAnimationsComplete. " + event.message);
		}
		
		private function onAnimationsProgress(event:FileLoadEvent):void
		{
			trace("onAnimationsProgress. " + event.message);
		}



	}
}
