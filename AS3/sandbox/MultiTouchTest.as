/**
 * @mxmlc -target-player=10.1.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '500')]

	/**
	 * Testing the multi touch capabilities of the new Flash Player 10.1.
	 * Needs Flex SDK 4.1 for compiling.
	 * @see http://opensource.adobe.com/wiki/display/flexsdk/Download+Flex+4
	 * @see http://www.adobe.com/support/flashplayer/downloads.html
	 * @see http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/events/GestureEvent.html
	 * @see http://www.adobe.com/devnet/flash/articles/multitouch_gestures_03.html
	 */
	public class MultiTouchTest extends Sprite
	{
		private var _field:TextField;
		
		public function MultiTouchTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			_field = new TextField();
			_field.width = 880;
			_field.height = 680;
			_field.x = 10;
			_field.y = 10;
			_field.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			addChild(_field);
			
			draw();
			
			_field.appendText("Multitouch.inputMode: " + Multitouch.inputMode + "\n");
			_field.appendText("Multitouch.maxTouchPoints: " + Multitouch.maxTouchPoints + "\n");
			_field.appendText("Multitouch.supportsGestureEvents: " + Multitouch.supportsGestureEvents + "\n");
			_field.appendText("Multitouch.supportsTouchEvents: " + Multitouch.supportsTouchEvents + "\n");
			_field.appendText("Multitouch.supportsTouchEvents: " + Multitouch.supportsTouchEvents + "\n");
			
			var supportedGesturesList:Vector.<String> = Multitouch.supportedGestures;
			if (supportedGesturesList != null)
			{
				var len:uint = supportedGesturesList.length;
				for (var i:int = 0; i < len; ++i)
				{
					_field.appendText("supportedGesturesList " + i + ": " + supportedGesturesList[i] + "\n");
				}
			}

			// GesturePhase.BEGIN, END, UPDATE
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			stage.addEventListener(GestureEvent.GESTURE_TWO_FINGER_TAP, onGesture);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onTransformGesture);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onTransformGesture);
			stage.addEventListener(PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP, onPressAndTapGesture);

			
			//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_OUT, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_OVER, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_ROLL_OVER, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_TAP, onTouch);
		}
		
		private function draw():void
		{
			var gr:Graphics = this.graphics;
			gr.clear();
			gr.beginFill(Math.random() * 0xAAAAAA);
			gr.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			gr.endFill();
		}
		
		private function onGesture(event:GestureEvent):void
		{
			_field.appendText("onGesture. type: " + event.type + "\n");
			draw();
		}
		
		private function onTransformGesture(event:TransformGestureEvent):void
		{
			_field.appendText("onTransformGesture. type: " + event.type + "\n");
			draw();
			
		}
		
		private function onPressAndTapGesture(event:PressAndTapGestureEvent):void
		{
			_field.appendText("onPressAndTapGesture. type: " + event.type + "\n");
			draw();
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			_field.appendText("onTouch. type: " + event.type + "\n");
			draw();
		}
	}
}
