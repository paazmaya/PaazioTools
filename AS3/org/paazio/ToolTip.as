package org.paazio {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;

	/**
	 * ToolTip
	 * Add to a display object which has a child of textfield.
	 * If textfield does not exists, use the name of the display object.
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.0.1
	 */
	public class ToolTip extends Sprite
	{
		private var tipText:String = "";

		private var field:TextField;

		public function ToolTip(parent:DisplayObject) {
			parent.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			parent.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.visible = false;
		}

		private function onMouseOver(event:MouseEvent):void 
		{
			this.visible = true;
			this.x = parent.mouseX;
			this.y = parent.mouseY;
		}

		private function onMouseOut(event:MouseEvent):void 
		{
			this.visible = false;
		}

		private function createField(fontSize:Number):void 
		{
			field = new TextField();
			field.embedFonts = true;
			field.border = true;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.selectable = false;
			field.mouseEnabled = true;
			field.text = tipText;
			this.addChild(field);
		}
	}
}