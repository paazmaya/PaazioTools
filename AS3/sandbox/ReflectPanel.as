/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import com.rictus.reflector.*;
	import com.rictus.dragpanel.*;


	[SWF(backgroundColor = '0x009933', frameRate = '33', width = '500', height = '300')]

	public class ReflectPanel extends Sprite
	{
		private var reflector:Reflector;
		private var panel:DragPanel;

		public function ReflectPanel()
		{
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			panel = new DragPanel();
			panel.initialize();

			reflector = new Reflector();
			reflector.target = panel;
		}
	}
}
/*
	<dragpanel:DragPanel id="panel" width="280" height="90" layout="absolute" title="Live Reflection Panel - Drag Me"
		color="#FFFFFF" horizontalCenter="0.5" verticalCenter="0">
		<mx:Label x="10" y="7" text="Alpha:" color="#000000"/>
		<mx:HSlider id="alphaSlider" x="61" y="3" liveDragging="true" showDataTip="false"
			width="159" minimum="0.0" maximum="1.0" value="0.3" snapInterval="0.01"/>
		<mx:Label x="217" y="6" text="{alphaSlider.value}" color="#000000" width="36"/>
		<mx:Label x="10" y="28" text="Falloff:" color="#000000"/>
		<mx:HSlider id="falloffSlider" x="61" y="24" liveDragging="true" showDataTip="false"
			width="159" minimum="0.0" maximum="1.0" value="0.7" snapInterval="0.01"/>
		<mx:Label x="217" y="30" text="{falloffSlider.value}" color="#000000" width="36"/>
	</dragpanel:DragPanel>

	<reflector:Reflector target="{panel}" alpha="{alphaSlider.value}" falloff="{falloffSlider.value}"/>
 */
