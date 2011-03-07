/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import org.cove.ape.*;
	import org.paazio.utils.FPSmeter;

	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]

	public class ApeTest extends Sprite
	{
		private var defaultGroup:Group;
		private var fpsField:FPSmeter;
		private var tx:TextField;
		private var counter:uint;
		
		// Speed up
		private var stageBitmap:Bitmap;
		private var point:Point;

		public function ApeTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, run);

			var forza:VectorForce = new VectorForce(true, 0, 1);
			APEngine.init(1/4);
			APEngine.container = this;
			APEngine.addForce(forza);

			defaultGroup = new Group();
			defaultGroup.collideInternal = true;

			var cp:CircleParticle = new CircleParticle(250,10,5);
			defaultGroup.addParticle(cp);

			var rp:RectangleParticle = new RectangleParticle(350,600,800,50,0,true);
			defaultGroup.addParticle(rp);

			var rp2:RectangleParticle = new RectangleParticle(50,200,8,500,0,true);
			defaultGroup.addParticle(rp2);

			var elasticity:Number = 0.5;
			var friction:Number = 0.1;
			var traction:Number = 1;
			var wh:WheelParticle = new WheelParticle(300, 0, 30, false, 1, elasticity, friction, traction);
			wh.angularVelocity = -0.01;
			defaultGroup.addParticle(wh);


			var cp2:CircleParticle = new CircleParticle(150,10,8);
			defaultGroup.addParticle(cp2);

			var cp3:CircleParticle = new CircleParticle(50,10,15);
			defaultGroup.addParticle(cp3);

			APEngine.addGroup(defaultGroup);


			fpsField = new FPSmeter();
			fpsField.x = 1;
			fpsField.y = 1;
			addChild(fpsField);

			tx = new TextField();
			tx.y = 2;
			tx.x = 800;
			tx.width = 100;
			addChild(tx);
		}

		private function run(event:Event):void
		{
			if (counter < 500)
			{
				var cp4:CircleParticle = new CircleParticle(20 + 650 * Math.random(), 10, 4);
				cp4.addEventListener(Event.ENTER_FRAME, cleanUp);
				defaultGroup.addParticle(cp4);
				counter++;
			}
			APEngine.step();
			APEngine.paint();
			
			tx.text = counter.toString();
		}
		
		private function cleanUp(event:Event):void
		{
			var pr:CircleParticle = event.target as CircleParticle;
			if (pr.center.y > stage.stageHeight || pr.center.x > stage.stageWidth || 0 > pr.center.x)
			{
				defaultGroup.removeParticle(pr);
				counter--;
			}
		}
	}
}
