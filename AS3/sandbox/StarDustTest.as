/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import org.paazio.display.StarDust;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	public class StarDustTest extends Sprite
	{
		private var _colors:Array = [0xFFFFFF, 0xFFFFFF, 0x939389];
		private var _alphas:Array = [1.0, 0.2, 0.0];
		private var _ratios:Array = [0, 68, 255];
		
		private var _width:Number = 80;
		private var _height:Number = 10;
		private var _radius:Number = 12.5;
		
	
		public function StarDustTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var colors:Array = [0xFFFFFF, 0xFFFFFF, 0x939389];
			var alphas:Array = [1.0, 0.2, 0.0];
			var ratios:Array = [0, 100, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_radius, _radius);
		
			var sh:Shape = new Shape();
			sh.x = 60;
			sh.y = 60;
			addChild(sh);
			var gra:Graphics = sh.graphics;
			gra.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			gra.drawCircle(0, 0, _radius);
			gra.endFill();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
		}
		
		private function onMouse(event:MouseEvent):void
		{
			createDust(event.stageX, event.stageY);
		}
		
		private function createDust(xPos:Number, yPos:Number):void
		{
			var amount:int = Math.round(15 + 10 * Math.random());
			for (var i:int = 0; i < amount; ++i)
			{
				var typeRandom:Number = Math.random();
				var type:String;
				type = typeRandom < 0.5 ? "h" : "v";

				var edgeX:Number = Math.random();
				var edgeY:Number = Math.random();
				var posX:Number;
				var posY:Number;

				if (type == "h")
				{
					posX = edgeX < 0.5 ? -_width * .6 : _width * .6;
					posY = -_height * .5 + Math.random() * _height;
				}
				else
				{
					posX = -_width * .5 + Math.random() * _width;
					posY = edgeY < .5 ? -_height * .6 : _height * .6;
				}
				
				var life : Number = Math.random() * 30 + 10;
				var vIniX : Number = 1;
				var vIniY : Number = 1;
				var vX : Number = 40;
				var vY : Number = 40;
				
				var pa:StarDust = new StarDust(life, vIniX, vIniY, vX, vY);
				pa.x = posX + xPos;
				pa.y = posY + yPos;
				addChild(pa);
			}
		}
	}
}
