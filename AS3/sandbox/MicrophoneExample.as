/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.Microphone;
    import flash.system.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

    public class MicrophoneExample extends Sprite
	{
		
        public function MicrophoneExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			
            var mic:Microphone = Microphone.getMicrophone();
            Security.showSettings(SecurityPanel.MICROPHONE);
			
			trace("Microphone.names: " + Microphone.names);

            if (mic != null)
			{
                mic.addEventListener(ActivityEvent.ACTIVITY, onActivity);
                mic.addEventListener(StatusEvent.STATUS, onStatus);
				mic.addEventListener(Event.ACTIVATE, onMicEvent);
				mic.addEventListener(Event.DEACTIVATE, onMicEvent);
				
                mic.setUseEchoSuppression(true);
				mic.setLoopBack(true);
            }
        }

        private function onMicEvent(event:Event):void
		{
            trace("onMicEvent: " + event);
        }

        private function onActivity(event:ActivityEvent):void
		{
            trace("onActivity: " + event);
        }

        private function onStatus(event:StatusEvent):void
		{
            trace("onStatus: " + event);
        }
    }
}
