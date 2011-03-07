/**
 * @mxmlc -target-player=10.0.0 -debug -source-path+=D:/papervision3d
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.QuaternionsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
    import org.papervision3d.objects.DisplayObject3D;
    import org.papervision3d.objects.primitives.*;
    import org.papervision3d.view.Viewport3D;
    import org.papervision3d.render.BasicRenderEngine;
    import org.papervision3d.materials.*;
    import org.papervision3d.materials.utils.MaterialsList;
    import org.papervision3d.cameras.Camera3D;
    import org.papervision3d.core.*;
    import org.papervision3d.core.render.data.RenderStatistics;
    import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.core.math.Quaternion;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * An example of the usage of the Quaternions plugin to perform better.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class QuaternionsExample extends Sprite
	{
		private const SIZE:Number = 100;
		private const AMOUNT:uint = 3;
		
		private var _view:Viewport3D;
        private var _scene:Scene3D;
		private var _camera:Camera3D;
        private var _renderer:BasicRenderEngine;
		private var _items:Array;

        public function QuaternionsExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([QuaternionsPlugin]);
						
            _renderer = new BasicRenderEngine();
            _scene = new Scene3D();
			_camera = new Camera3D();
			_view = new Viewport3D();
			addChild(_view);
			
			drawBoxes();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

		private function drawBoxes():void
		{
			_items = [];
			
			for (var i:Number = 0; i < AMOUNT; ++i)
			{
				for (var j:Number = 0; j < AMOUNT; ++j)
				{
					for (var k:Number = 0; k < AMOUNT; ++k)
					{
						var materials:MaterialsList = new MaterialsList(
							{ all: new ColorMaterial(Math.random() * 0xFFFFFF, 0.7, true) }
						);
						var cube:Cube = new Cube(materials, SIZE, SIZE, SIZE, 4, 4, 4);
						cube.x = -SIZE + i * SIZE;
						cube.y = -SIZE + j * SIZE;
						cube.z = -SIZE + k * SIZE;
						_scene.addChild(cube);
					}
				}
			}
		}
		
		private function tweenCamera():void
		{
			var qua:Quaternion = new Quaternion();
			qua.x = Math.random() * 200;
			qua.y = Math.random() * 200;
			
			TweenLite.to(_camera, 2, { quaternions: { quaternion: qua } } );
		}
		
		private function onEnterFrame(event:Event):void
		{
			var stat:RenderStatistics = _renderer.renderScene(_scene, _camera, _view);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawBoxes();
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				tweenCamera();
			}
		}
    }
}
