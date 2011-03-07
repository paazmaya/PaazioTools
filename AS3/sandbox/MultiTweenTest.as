/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '800', height = '600')]
	
	public class MultiTweenTest extends Sprite
	{
		private var ballA:Shape;
		private var ballB:Shape;
		private var ballC:Shape;
		private var dudeA:Sprite;
		private var dudeB:Sprite;
		private var dudeC:Sprite;
		
		public function MultiTweenTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			dudeA = new Sprite();
			dudeA.name = "dudeA";
			addChild(dudeA);
			
			dudeB = new Sprite();
			dudeB.name = "dudeB";
			addChild(dudeB);
			
			dudeC = new Sprite();
			dudeC.name = "dudeC";
			addChild(dudeC);
						
			ballA = new Shape();
			ballA.graphics.beginFill(0xFF4400);
			ballA.graphics.drawCircle(10, 10, 10);
			ballA.graphics.endFill();
			
			ballB = new Shape();
			ballB.graphics.beginFill(0x0044FF);
			ballB.graphics.drawCircle(10, 10, 10);
			ballB.graphics.endFill();
			
			ballC = new Shape();
			ballC.graphics.beginFill(0x00FF44);
			ballC.graphics.drawCircle(10, 10, 10);
			ballC.graphics.endFill();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function localTween():void
		{
			var bt:BitmapData = new BitmapData(ballC.width, ballC.height, true, 0x00FFFFFF);
			bt.draw(ballC);
			var bmp:Bitmap = new Bitmap(bt);
				
			var sp:Sprite = new Sprite();
			sp.name = "local" + getTimer().toString();
			sp.addChild(bmp);
			sp.x = Math.random() * stage.stageWidth;
			sp.y = Math.random() * (stage.stageHeight - 200) + 200;
			dudeC.addChild(sp);
			
			TweenLite.to(sp, 6, {y: "-400", alpha: 0, onComplete: onLocalComplete, onCompleteParams: [sp]});
		}
		
		private function onLocalComplete(sp:Sprite):void
		{
			trace("onLocalComplete. name: " + sp.name);
			dudeC.removeChild(sp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				localTween();
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			var cont:Sprite;
			var ball:Shape;
			var delay:Number;
			
			if (Keyboard.capsLock)
			{
				cont = dudeA;
				ball = ballA;
				delay = 20;
			}
			else
			{
				cont = dudeB;
				ball = ballB;
				delay = 3.5;
			}
			
			var blur:BlurFilter = new BlurFilter(6, 6);
			for (var i:uint = 1; i < 20; ++i)
			{
				var bt:BitmapData = new BitmapData(ball.width, ball.height, true, 0x00FFFFFF);
				bt.draw(ball);
				
				var bmp:Bitmap = new Bitmap(bt);
				bmp.name = "bmp" + i;
				//bmp.visible = false;
				bmp.x = stage.mouseX;
				bmp.y = stage.mouseY;
				bmp.filters = [blur];
				cont.addChild(bmp);
				TweenLite.to(bmp, delay, {y: bmp.y - (Math.random() * 100 + 100), x: bmp.x + Math.random() * 200 - 100,
					rotation: 90 * Math.random() - 45, delay: i / 6, alpha: 0,
					onComplete: onComplete, onCompleteParams: [bmp.name, cont.name],
					onStart: onBegin, onStartParams: [bmp.name, cont.name]
				});
			}
		}
						
		private function onBegin(name:String, contName:String):void
		{
			trace("onBegin. name: " + name + ", cont: " + contName);
			//var cont:Sprite = getChildByName(contName) as Sprite;
			//var ball:Bitmap = cont.getChildByName(name) as Bitmap;
			//ball.visible = true;
		}
		
		private function onComplete(name:String, contName:String):void
		{
			trace("onComplete. name: " + name + ", cont: " + contName);
			var cont:Sprite = getChildByName(contName) as Sprite;
			cont.removeChild(cont.getChildByName(name));
		}
	}
}
