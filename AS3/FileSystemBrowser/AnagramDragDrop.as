package
{

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;  

  public class AnagramDragDrop extends Sprite
	{
    private var dragTarget:Sprite;

    public function AnagramDragDrop() 
		{
      var board:Sprite = new Sprite();
      var letters:Array = new Array("d","i","r","t","y","r","o","o","m")
      var l:String;
      var xPos:uint = 50
      var yPos:uint = 100
      for each (l in letters) {
        var tile:Sprite = new Sprite();
        tile = createLetterTile(l as String) // size, color yellow
        tile.x = xPos;
        tile.y = yPos;
        xPos += 50;
        board.addChild(tile);
        tile.addEventListener(MouseEvent.MOUSE_DOWN, dragStarter, false);
        tile.addEventListener(MouseEvent.MOUSE_UP, dragStopper);
      }
      addChild(board)

      var instructions:TextField = new TextField();
      instructions.text = "Re-order the letters to form another word.";
	  instructions.selectable = false;
      instructions.x = 20
      instructions.y = 20
      instructions.width = 300;
      addChild(instructions)

    }

    private function dragStarter(event:MouseEvent):void 
		{
      if (event.target is Sprite) {
        dragTarget = event.target as Sprite;
        dragTarget.startDrag();
      }
    }

    private function dragStopper(event:MouseEvent):void 
		{
      dragTarget.stopDrag();
    }

    private function createLetterTile(txt:String):Sprite
	{
      var s:Sprite = new Sprite();
      var letter:TextField = new TextField();
      var tileBackColor:uint = 0xDBD9A6;
      var tileShadowColor:uint = 0x676420;
      var tileBorderColor:uint = 0x000000;

      s.graphics.beginFill(tileShadowColor);
      s.graphics.drawRect(-2, 2, 40, 40);
      s.graphics.endFill();
      s.graphics.beginFill(tileBackColor);
      s.graphics.drawRect(0, 0, 40, 40);
      s.graphics.endFill();
      s.graphics.lineStyle(1, tileBorderColor, 100);
      s.graphics.drawRect(0, 0, 40, 40);

      letter.text = txt
      letter.selectable = false;
      letter.x = 14
      letter.y = 14
      letter.width = 14
      letter.height = 16
      s.addChild(letter)

      return s;
    }
  }
}