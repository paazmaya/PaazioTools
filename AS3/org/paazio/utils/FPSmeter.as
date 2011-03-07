package org.paazio.utils {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.system.System;
	import flash.utils.getTimer;

	/**
	 * Displays the current framerate and a bar visualising it.
	 */
	public class FPSmeter extends Sprite
	{
		private var time:Number = 0;
		private var frameTime:Number = 0;
		private var prevFrameTime:Number = getTimer();
		private var secondTime:Number = 0;
		private var prevSecondTime:Number = getTimer();
		private var frames:Number = 0;
		private var fps:String = "";

		private var bar:Shape = new Shape();
		private var tf:TextField = new TextField();
		private var fr:TextFormat = new TextFormat();

		public function FPSmeter() 
		{
			bar.graphics.beginFill(0xFF6600);
			bar.graphics.drawRect(0, 0, 100, 14);
			bar.graphics.endFill();
			this.addChild(bar);

			fr.font = "_sans";
			fr.bold = true;
			fr.size = 10;

			tf.x = 1;
			tf.y = -1;
			tf.cacheAsBitmap = false;
			tf.selectable = false;
			tf.background = false;
			tf.border = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(tf);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void 
		{
			time = getTimer();
			frameTime = time - prevFrameTime;
			secondTime = time - prevSecondTime;
			if (secondTime >= 1000) {
				fps = frames.toString();
				frames = 0;
				prevSecondTime = time;
			}
			else {
				frames++;
			}
			prevFrameTime = time;
			bar.scaleX = bar.scaleX - ((bar.scaleX - (frameTime / 10)) / 5);
			
			tf.text = fps + " fps / " + frameTime.toString() + " ms. mem: " + Number(System.totalMemory / 1024 / 1024).toFixed(2) + "Mb";
		}
	}
}