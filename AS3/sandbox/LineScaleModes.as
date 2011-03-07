/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	
	import org.paazio.visual.PTextField;
	import com.greensock.TweenLite;

	[SWF(backgroundColor = '0xF39631', frameRate = '33', width = '800', height = '600')]

	public class LineScaleModes extends Sprite
	{

		public function LineScaleModes()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			var modes:Array = [
				LineScaleMode.HORIZONTAL,
				LineScaleMode.NONE,
				LineScaleMode.NORMAL,
				LineScaleMode.VERTICAL
			];
			var len:uint = modes.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var tf:PTextField = createField(modes[i] as String);
				tf.x = i * 125 + 60;
				tf.y = 5;
				addChild(tf);
				for (var j:uint = 0; j < 4; ++j)
				{
					var sh:Shape = drawCircle(modes[i] as String);
					sh.x = i * 125 + 60;
					sh.y = j * 125 + 60;
					if (j == 1)
					{
						sh.scaleX = 4;
					}
					else if (j == 2)
					{
						sh.scaleY = 4;
					}
					else if (j == 3)
					{
						sh.scaleY = 4;
						sh.scaleX = 4;
					}
					addChild(sh);
				}
			}
			
			for (var k:uint = 0; k < len; ++k)
			{
				var sht:Shape = drawCircle(modes[k] as String);
				sht.x = k * 125 + 60;
				sht.y = 120;
				addChild(sht);
				TweenLite.to(sht, 10, { scaleX: 6 } );
			}
		}

		private function drawCircle(mode:String):Shape
		{
			var sh:Shape = new Shape();
			var gra:Graphics = sh.graphics;
			gra.lineStyle(1, 0x000000, 1, false, mode);
			gra.drawCircle(0, 0, 10);
			gra.endFill();
			return sh;
		}
		
		private function createField(text:String):PTextField
		{
			var field:PTextField = new PTextField();
			field.text = text;
			return field;
		}
	}
}
