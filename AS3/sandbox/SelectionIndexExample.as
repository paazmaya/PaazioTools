/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.text.*;
	import flash.events.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
    public class SelectionIndexExample extends Sprite
    {
		private const TEXT:String = "A lens magnifies one of the intact muslces to demonstrate that the muscle is comprised of individual fibers. Fibers are the individual cells of muscles. Each fiber has formed by the merging of of numerous myoblasts to form a syncetium with multiple nuclei. The fiber's plasma membrane is the sarcolemma, and the cytoplasm is the sarcoplasm. The sarcoplasm is packed with contractile elements termed myofibrils. The myofibrils have a striated pattern and the overall muscle has a striated appearance, if it is a voluntary muscle of vertebrate animals. All insect muscles are striated.";
		
		private var _format:TextFormat = new TextFormat("vera", 14, 0xFFFFFF);
		private var _editable:TextField;
		private var _feedback:TextField;
		
		[Embed(source = "../assets/Vera.ttf", fontFamily = "vera")]
		private var _vera:String;
		
        public function SelectionIndexExample()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_editable = createTextField(10, 200, TextFieldType.INPUT);
			_editable.text = TEXT;
			_editable.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			_editable.addEventListener(Event.CHANGE, onEvent);
			_editable.addEventListener(Event.SELECT_ALL, onEvent);
			addChild(_editable);
			
			_feedback = createTextField(220);
			_feedback.text = "Select text...";
			addChild(_feedback);
		}
		
		private function onMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				_editable.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
				_editable.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			}
			else if (event.type == MouseEvent.MOUSE_MOVE)
			{
				var selected:String = _editable.text.substring(_editable.selectionBeginIndex, _editable.selectionEndIndex);
				_feedback.text = "Selected text is [" + selected + "]";
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				_editable.removeEventListener(MouseEvent.MOUSE_MOVE, onMouse);
				_editable.removeEventListener(MouseEvent.MOUSE_UP, onMouse);
			}
		}
		
		private function onEvent(event:Event):void
		{
			trace("onEvent. type: " + event.type);
		}
		
		private function createTextField(yPos:Number, h:Number = 100, type:String = TextFieldType.DYNAMIC):TextField
		{
			var field:TextField = new TextField();
			field.x = 10;
			field.y = yPos;
			field.width = 500;
			field.height = h;
			field.defaultTextFormat = _format;
			field.type = type;
			field.embedFonts = true;
			field.multiline = true;
			field.wordWrap = true;
			field.border = true;
			return field;
		}
    }
}
