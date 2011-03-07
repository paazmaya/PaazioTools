/**
 * @mxmlc -target-player=10.0.0
 */
package sandbox
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.renderer.Renderer;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	public class CubeTricky extends Sprite
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var colors:Vector.<uint>;

		function CubeTricky()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			colors = Vector.<uint>([0x0066FF, 0xFF6600, 0x6600FF, 0x00FF66, 0x66FF00, 0xFF0066]);
			
			var renderClip:Sprite = new Sprite();
			addChild(renderClip);
			
			var descriptionClip:Sprite = new Sprite();
			addChild(descriptionClip);
			
			renderer = new Renderer(renderClip);
			renderer.distanceBlur = 40;
			renderer.blurMode = true;
			
			cam = new PointCamera(600, 400);
			
			renderList = [];
			
			for(var i:uint = 0; i < 3; ++i)
			{
				for(var j:uint = 0; j < 3; j++)
				{
					for(var k:uint = 0; k < 3; k++)
					{
						var inx:uint = j + k;
						var color:uint = colors[inx] as uint;
						trace(inx + " : 0x" + color.toString(16));
						var ma:Material = new Material(color, 0.8);
						var m:Mesh = new SimpleCube(ma, 20);
						m.scale(1.5, 1.5, 1.5);
						m.xPos = -80 + i * 80;
						m.yPos = -80 + j * 80;
						m.zPos = -80 + k * 80;
						renderList.push(m);
					}
				}
			}
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}

		private function onMouseWheel(evt:MouseEvent):void
		{
			cam.zOffset -= evt.delta * 10;
		}

		private function onRenderScene(event:Event):void
		{

			cam.angleX += (mouseY - cam.vpY) * .00005;
			cam.angleY += (mouseX - cam.vpX) * .00005;

			renderer.render(renderList, cam);
		}
	}
}
