/**
* @mxmlc -default-size 700 300 -incremental=false -noplay -source-path=E:\AS3libs
*/
package {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import org.papervision3d.cameras.*;
	import org.papervision3d.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.scenes.*;

	import caurina.transitions.Tweener;

	import org.cove.ape.APEngine;
	import org.cove.ape.CircleParticle;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.SpringConstraint;
	import org.cove.ape.Vector;
	import org.cove.ape.WheelParticle;

	import com.foxaweb.pageflip.PageFlip;

	[SWF(width='700', height='300', backgroundColor='0xFFFFFF', frameRate='31')]

	public class BikingSlovenia extends Sprite
	{

		private var paintQueue:Array;

		// Manual for usage of Slovenia or bicycle?
		private var manual:Shape;
		// Pages. 230x200
		[Embed(source="assets/manual00.png")]	public var mPage0:Class;
		[Embed(source="assets/manual01.png")]	public var mPage1:Class;

		// Bicycle parts
		[Embed(source="assets/carbody.png")]	public var rightWheel:Class;
		[Embed(source="assets/leftWheel.png")]	public var leftWheel:Class;
		[Embed(source="assets/carBody.png")]	public var carBody:Class;
		[Embed(source="assets/track.png")]		public var carTrack:Class;
		[Embed(source="assets/pebble.png")]		public var pebble:Class;

		public function BikingSlovenia() {
			APEngine.init(1/3);
			APEngine.defaultContainer = this;
			APEngine.addMasslessForce(new Vector(0,3));

			createBridge();

			paintQueue = APEngine.getAll();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}



		private function onEnterFrame(event:Event):void {
			APEngine.step();
			for (var i:int = 0; i < paintQueue.length; i++) {
				paintQueue[i].paint();
				//trace(paintQueue[i]);
			}
		}

		private function onKeyDown(event:KeyboardEvent):void {
			// http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/ui/Keyboard.html
			trace("keyDownHandler: " + event.keyCode);
			//trace("keyLocation: " + event.keyLocation);
			//trace("ctrlKey: " + event.ctrlKey);
			//trace("shiftKey: " + event.shiftKey);
			//trace("altKey: " + event.altKey);
			if (event.keyCode == Keyboard.SPACE) {
				showManual();
			}
			if (event.keyCode == Keyboard.BACKSPACE) {
				createBicycle();
			}
		}

		private function onKeyUp(event:KeyboardEvent):void {

		}

		private function createBicycle():void {
			// CircleParticle(x:Number, y:Number, radius:Number, fixed:Boolean, mass:Number = 1,
			// elasticity:Number = 0.3, friction:Number = 0)
			//var bikeTireFront:CircleParticle = new CircleParticle(500, 200, 60, false, 1, 0.8, 0.6);

			// WheelParticle(x:Number, y:Number, radius:Number, fixed:Boolean, mass:Number = 1,
			// elasticity:Number = 0.3, friction:Number = 0, traction:Number = 1)
			var bikeTireFront:WheelParticle = new WheelParticle(500, 200, 40, true, 1, 0.8, 0.6);

			APEngine.addParticle(bikeTireFront);
		}

		private function createBridge():void {
			// bridge
			var bridgeStart:RectangleParticle = new RectangleParticle(80,70,50,25,0,true);
			APEngine.addParticle(bridgeStart);

			var bridgeEnd:RectangleParticle = new RectangleParticle(680,70,50,25,0,true);
			APEngine.addParticle(bridgeEnd);

			var bridgePA:CircleParticle = new CircleParticle(200,70,4,false);
			APEngine.addParticle(bridgePA);

			var bridgeConnA:SpringConstraint = new SpringConstraint(bridgeStart.cornerParticles[1], bridgePA, 0.9);
			bridgeConnA.collidable = true;
			bridgeConnA.collisionRectWidth = 10;
			bridgeConnA.collisionRectScale = 0.6;
			APEngine.addConstraint(bridgeConnA);

			// Create a long bridge
			for (var i:int = 0; i < 100; i++) {
				var bridgePB:CircleParticle = new CircleParticle(240,70,4,false);
				APEngine.addParticle(bridgePB);

				// Connect the newly created to the previous
				var bridgeConnB:SpringConstraint = new SpringConstraint(bridgePA, bridgePB, 0.9);
				bridgeConnB.collidable = true;
				bridgeConnB.collisionRectWidth = 10;
				bridgeConnB.collisionRectScale = 0.6;
				APEngine.addConstraint(bridgeConnB);
			}

			var bridgePC:CircleParticle = new CircleParticle(280,70,4,false);
			APEngine.addParticle(bridgePC);

			// Connect the last one from the loop to the last in the bridge
			var bridgeConnC:SpringConstraint = new SpringConstraint(bridgePB, bridgePC, 0.9);
			bridgeConnC.collidable = true;
			bridgeConnC.collisionRectWidth = 10;
			bridgeConnC.collisionRectScale = 0.6;
			APEngine.addConstraint(bridgeConnC);

			// Connect last in the bridge to the rock
			var bridgeConnD:SpringConstraint = new SpringConstraint(bridgePC, bridgeEnd.cornerParticles[0], 0.9);
			bridgeConnD.collidable = true;
			bridgeConnD.collisionRectWidth = 10;
			bridgeConnD.collisionRectScale = 0.6;
			APEngine.addConstraint(bridgeConnD);
		}

		private function showManual():void {
			manual = new Shape();
			var page0:BitmapData = new mPage0().bitmapData;
			var page1:BitmapData = new mPage1().bitmapData;

			manual.x = 10;
			manual.y = 10;
			addChild(manual);

			var o:Object = PageFlip.computeFlip(
								new Point(115, 190),	// flipped point
								new Point(1,1),		// of bottom-right corner
								page0.width,		// size of the sheet
								page1.height,
								true,				// in horizontal mode
								1);					// sensibility to one

			PageFlip.drawBitmapSheet(
								o,			// computeflip returned object
								manual,		// target
								page0,		// bitmap page 0
								page1);		// bitmap page 1

		}
	}
}
