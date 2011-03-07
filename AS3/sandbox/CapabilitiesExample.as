/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.events.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class CapabilitiesExample extends Sprite
	{
		
		private var _field:TextField;
		
		public function CapabilitiesExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_field = new TextField();
			_field.border = true;
			_field.background = true;
			_field.multiline = true;
			_field.x = 10;
			_field.y = 10;
			_field.width = stage.stageWidth - 20;
			_field.height = stage.stageHeight - 20;
			_field.text = "Your system capabilities\n---------------------------\n";
			addChild(_field);
			
			showCapabilities();
		}
		
		private function showCapabilities():void
		{
            _field.appendText("avHardwareDisable: " + Capabilities.avHardwareDisable + "\n");
            _field.appendText("hasAccessibility: " + Capabilities.hasAccessibility + "\n");
            _field.appendText("hasAudio: " + Capabilities.hasAudio + "\n");
            _field.appendText("hasAudioEncoder: " + Capabilities.hasAudioEncoder + "\n");
            _field.appendText("hasEmbeddedVideo: " + Capabilities.hasEmbeddedVideo + "\n");
            _field.appendText("hasMP3: " + Capabilities.hasMP3 + "\n");
            _field.appendText("hasPrinting: " + Capabilities.hasPrinting + "\n");
            _field.appendText("hasScreenBroadcast: " + Capabilities.hasScreenBroadcast + "\n");
            _field.appendText("hasScreenPlayback: " + Capabilities.hasScreenPlayback + "\n");
            _field.appendText("hasStreamingAudio: " + Capabilities.hasStreamingAudio + "\n");
            _field.appendText("hasVideoEncoder: " + Capabilities.hasVideoEncoder + "\n");
            _field.appendText("isDebugger: " + Capabilities.isDebugger + "\n");
            _field.appendText("language: " + Capabilities.language + "\n");
            _field.appendText("localFileReadDisable: " + Capabilities.localFileReadDisable + "\n");
            _field.appendText("manufacturer: " + Capabilities.manufacturer + "\n");
			_field.appendText("maxLevelIDC: " + Capabilities.maxLevelIDC + "\n");
            _field.appendText("os: " + Capabilities.os + "\n");
            _field.appendText("pixelAspectRatio: " + Capabilities.pixelAspectRatio + "\n");
            _field.appendText("playerType: " + Capabilities.playerType + "\n");
            _field.appendText("screenColor: " + Capabilities.screenColor + "\n");
            _field.appendText("screenDPI: " + Capabilities.screenDPI + "\n");
            _field.appendText("screenResolutionX: " + Capabilities.screenResolutionX + "\n");
            _field.appendText("screenResolutionY: " + Capabilities.screenResolutionY + "\n");
            _field.appendText("serverString: " + Capabilities.serverString + "\n");
            _field.appendText("version: " + Capabilities.version + "\n");
        }
	}
}
