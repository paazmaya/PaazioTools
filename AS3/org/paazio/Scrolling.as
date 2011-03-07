package org.paazio {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;

	/**
	 * Scroll an displayobject
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.1.0
	 */
	public class Scrolling extends Sprite
	{

		private var maskShape:Shape;
		public var content:Sprite;
		public var step:Number;

		/**
		 *
		 * @param	stuff	The stuff to be scrolled
		 * @param	step	Amount of pixels for each step by keyboard or mousewheel
		 * @param	w		Width of the mask
		 * @param	h		Height of the mask
		 */
		public function Scrolling(stuff:DisplayObject, step:Number = 5, w:Number = 100, h:Number = 150) {
			this.step = step;

			maskShape = new Shape();
			maskShape.graphics.beginFill(0x000000);
			maskShape.graphics.drawRect(0, 0, w, h);
			maskShape.graphics.endFill();
			this.addChild(maskShape);

			content = new Sprite();
			content.name = "content";
			content.addChild(stuff);
			content.mask = maskShape;
			this.addChild(content);

			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onMouseWheel(event:MouseEvent):void 
		{
			content.y += event.delta / 2 * step;

			checkLimits();
		}

		private function onKeyUp(event:KeyboardEvent):void 
		{
			if (event.keyCode == Keyboard.UP) {
				content.y -= step;
			}
			else if (event.keyCode == Keyboard.DOWN) {
				content.y += step;
			}

			checkLimits();
		}

		/**
		 * Checks for the assumed limits and resets to them if overlapped.
		 */
		private function checkLimits():void 
		{
			if (content.y > 0) {
				content.y = 0;
			}
			else if (content.y < (maskShape.height - content.height)) {
				content.y = maskShape.height - content.height;
			}
			stage.invalidate();
		}
	}
}