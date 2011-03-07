/**
 * @mxmlc -target-player=10.0.0 -debug -source-path=D:/AS3libs
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.ByteArray;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.*;
	import org.papervision3d.core.render.data.RenderStatistics;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	import com.greensock.TweenLite;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '970', height = '500')]
	
	public class MultiView extends Sprite
	{
		private var scene:Scene3D;
		private var cameras:Array;
		private var views:Array;
		private var renderer:BasicRenderEngine;
		private var currentCamera:int;
		private var center:DisplayObject3D;
		private var cube:Cube;
		private var format:TextFormat;
		private var currentZoom:Number = 1;
		private var collada:DAE;
		
		[Embed(source = "../assets/nrkis.ttf", fontFamily = "nrkis")]
		public var nrkis:String;
		
		public function MultiView()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			renderer = new BasicRenderEngine();
			
			scene = new Scene3D();
			
			center = new DisplayObject3D();
			center.name = "center";
			scene.addChild(center);
			
			format = new TextFormat();
			format.font = "nrkis";
			format.bold = true;
			format.align = TextFormatAlign.LEFT;
			format.color = 0x010101;
			format.size = 13;
						
			createViews();
			
			createCameras();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			/*
			for (var i:uint = 0; i < 10; ++i)
			{
				var material:ColorMaterial = new ColorMaterial(0x111111 * i);
				var sphere:Sphere = new Sphere(material, 40);
				sphere.x = i * 30 - Math.random() * 100;
				sphere.y = i * 30 - Math.random() * 100;
				sphere.z = i * 30 - Math.random() * 100;
				scene.addChild(sphere);
			}
			
			for (var i:uint = 0; i < 10; ++i)
			{
				var material:ColorMaterial = new ColorMaterial(0x222222 * i);
				var cone:Cone = new Cone(material, 40, 50);
				cone.x = i * 20 - Math.random() * 100;
				cone.y = i * 20 - Math.random() * 100;
				cone.z = i * 20 - Math.random() * 100;
				scene.addChild(cone);
			}
			 */
			
			var mclist:Object = {};
			var locs:Array = ["all", "front", "back", "right", "left", "top", "bottom"];
			for (var s:uint = 0; s < locs.length; ++s)
			{
				var mc:Sprite = new Sprite();
				mc.name = String(locs[s]);
				var gra:Graphics = mc.graphics;
				gra.lineStyle(1, 0x000000);
				gra.beginFill(0x123456 * s + 0x555555);
				gra.drawRect(0, 0, 200, 100);
				var tx:TextField = new TextField();
				tx.defaultTextFormat = format;
				tx.embedFonts = true;
				tx.text = mc.name;
				tx.width = 100;
				mc.addChild(tx);
				mclist[locs[s]] = new MovieMaterial(mc, true);
			}
			
			var materials:MaterialsList = new MaterialsList({
				all:	new ColorMaterial(0x63FF04, 1, true),
				front:	new ColorMaterial(0x63FF04, 1, true),
				back:	new ColorMaterial(0xFF6304, 1, true),
				right:	new ColorMaterial(0x63CCFF, 1, true),
				left:	new ColorMaterial(0x0463FF, 1, true),
				top:	new ColorMaterial(0xCCFF63, 1, true),
				bottom:	new ColorMaterial(0xCCCCCC, 1, true)
			});
			//cube = new Cube(new MaterialsList(mclist), 200, 300, 100, 4, 4, 4);
			//scene.addChild(cube);
			
			collada = new DAE();
			collada.load("Nid.dae");
			scene.addChild(collada);
		}
		
		private function createViews():void
		{
			views = [];
			var settings:Array = [
				{ w: 640, h: 480, x: 0, y: 1 },
				{ w: 320, h: 240, x: 642, y: 1 },
				{ w: 320, h: 240, x: 642, y: 242 }
			];
			
			var len:uint = settings.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var opts:Object = settings[i] as Object;
				
				var view:Viewport3D = new Viewport3D(opts.w, opts.h);
				view.name = "Viewport " + i.toString();
				view.x = opts.x;
				view.y = opts.y;
				view.graphics.lineStyle(1, 0x000000);
				view.graphics.drawRect(0, 0, opts.w - 1, opts.h - 1);
				addChild(view);
				
				var tx:TextField = new TextField();
				tx.defaultTextFormat = format;
				tx.embedFonts = true;
				tx.name = "title";
				tx.width = opts.w;
				view.addChild(tx);
				
				var rx:TextField = new TextField();
				rx.defaultTextFormat = format;
				rx.embedFonts = true;
				rx.multiline = true;
				rx.wordWrap = true;
				rx.name = "render";
				rx.width = opts.w;
				rx.height = 32;
				rx.y = opts.h - 32;
				view.addChild(rx);
				
				views.push(view);
			}
		}
		
		private function createCameras():void
		{
			cameras = [];
			
			var cams:Array = [
				{ x: 0, y: 0, z: 200, name: "Front" },
				{ x: 0, y: 0, z: -200, name: "Back" },
				{ x: 1, y: 200, z: 0, name: "Top" }, // x non zero to get out from the box.
				{ x: 1, y: -200, z: 0, name: "Bottom" },
				{ x: 200, y: 0, z: 0, name: "Right" },
				{ x: -200, y: 0, z: 0, name: "Left" },
				{ x: 160, y: 160, z: 160, name: "Angular" } // Extra camera for special angle.
			];
			
			var len:uint = cams.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var opts:Object = cams[i] as Object;
				
				var cam:Camera3D = new Camera3D(center, currentZoom);
				cam.name = opts.name;
				cam.x = opts.x;
				cam.y = opts.y;
				cam.z = opts.z;
				cameras.push(cam);
			}
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function onEnterFrame(event:Event):void
		{
			/*
			var x:Number = -(stage.mouseX * 3) / 2;
			var y:Number = (stage.mouseY * 3);
			cube.rotationX = x;
			cube.rotationY = y;
			 */
			
			var len:uint = views.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var view:Viewport3D = views[i] as Viewport3D;
				var cam:Camera3D = cameras[i] as Camera3D;
				if (view.name == "Viewport 0")
				{
					cam.zoom = currentZoom * 2;
				}
				else
				{
					cam.zoom = currentZoom;
				}
				
				var title:TextField = view.getChildByName("title") as TextField;
				title.text = view.name + " - " + cam.name + " - Zoom: " + cam.zoom.toFixed(2);
				
				var stat:RenderStatistics = renderer.renderScene(scene, cam, view);
				var render:TextField = view.getChildByName("render") as TextField;
				render.text = stat.toString();
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			var cam:Camera3D;
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					// rotate camera array
					cam = cameras.shift() as Camera3D;
					cameras.push(cam);
					break;
					
				case Keyboard.RIGHT:
					// rotate camera array
					cam = cameras.pop() as Camera3D;
					cameras.unshift(cam);
					break;
					
				case 82: // r
					// Rotate the object
					TweenLite.to(cube, 1, {rotationY: "+90" } );
					break;
			}
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			currentZoom += event.delta / 100;
		}
	}
}
