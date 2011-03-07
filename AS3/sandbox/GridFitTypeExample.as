/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.text.*;
	import flash.events.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '400', height = '200')]
	
    public class GridFitTypeExample extends Sprite
    {
		private const GRID_TYPE:Array = [
			GridFitType.NONE,
			GridFitType.PIXEL,
			GridFitType.SUBPIXEL
		];
		
		private var _format:TextFormat = new TextFormat("vera", 22, 0xFFFFFF);
		
		[Embed(source = "../assets/Vera.ttf", fontFamily = "vera")]
		private var _vera:String;
		
        public function GridFitTypeExample()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var len:uint = GRID_TYPE.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var field:TextField = createTextField(10.44 + i * 45, GRID_TYPE[i]);
				addChild(field);
			}
		}
		
		private function createTextField(yPos:Number, gridFitType:String):TextField
		{
			var field:TextField = new TextField();
			field.x = 10.77;
			field.y = yPos;
			field.defaultTextFormat = _format;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.text = "This text uses a gridFitType of " + gridFitType.toUpperCase();
			field.autoSize = TextFieldAutoSize.LEFT;
			field.embedFonts = true;
			field.gridFitType = gridFitType;
			return field;
		}
    }
}
