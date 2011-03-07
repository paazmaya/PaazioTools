/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package gsexamples
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * An example of the usage of the BlurFilter plugin to blur an item.
	 * <ul>
	 * 		<li><code> colorize : uint </code> (colorizing a DisplayObject makes it look as though you're seeing it through a colored piece of glass whereas tinting it makes every pixel exactly that color. You can control the amount of colorization using the "amount" value where 1 is full strength, 0.5 is half-strength, and 0 has no colorization effect.)</li>
	 * 		<li><code> amount : Number [1] </code> (only used in conjunction with "colorize")</li>
	 * 		<li><code> contrast : Number </code> (1 is normal contrast, 0 has no contrast, and 2 is double the normal contrast, etc.)</li>
	 * 		<li><code> saturation : Number </code> (1 is normal saturation, 0 makes the DisplayObject look black and white, and 2 would be double the normal saturation)</li>
	 * 		<li><code> hue : Number </code> (changes the hue of every pixel. Think of it as degrees, so 180 would be rotating the hue to be exactly opposite as normal, 360 would be the same as 0, etc.)</li>
	 * 		<li><code> brightness : Number </code> (1 is normal brightness, 0 is much darker than normal, and 2 is twice the normal brightness, etc.)</li>
	 * 		<li><code> threshold : Number </code> (number from 0 to 255 that controls the threshold of where the pixels turn white or black)</li>
	 * 		<li><code> matrix : Array </code> (If you already have a matrix from a ColorMatrixFilter that you want to tween to, pass it in with the "matrix" property. This makes it possible to match effects created in the Flash IDE.)</li>
	 * 		<li><code> index : Number </code> (only necessary if you already have a filter applied and you want to target it with the tween.)</li>
	 * 		<li><code> addFilter : Boolean [false] </code></li>
	 * 		<li><code> remove : Boolean [false] </code> (Set remove to true if you want the filter to be removed when the tween completes.)</li>
	 * </ul>
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class ColorMatrixFilterExample extends Sprite
	{
		// http://www.flickr.com/photos/paazio/2449304844/
		[Embed(source = "../assets/2449304844_a742a2e148_m.jpg")]
		private var DogLapo:Class;
		
		private var _container:Sprite;
		
        public function ColorMatrixFilterExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			TweenPlugin.activate([ColorMatrixFilterPlugin]);
			
			_container = new Sprite();
			addChild(_container);
			
			drawItems();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
		
		private function drawItems():void
		{
			var lapo:Bitmap = new DogLapo() as Bitmap;
			var m:Number = 6;
			var h:int = Math.floor(stage.stageWidth / (lapo.width + m * 2));
			var v:int = Math.floor(stage.stageHeight / (lapo.height + m * 2));
			
			var num:uint = _container.numChildren;
			while (num > 0)
			{
				--num;
				_container.removeChildAt(num);
			}
			
			for (var i:uint = 0; i < h; ++i)
			{
				for (var j:uint = 0; j < v; ++j)
				{
					var bm:Bitmap = new Bitmap(lapo.bitmapData);
					bm.x = (m + lapo.width) * i + m;
					bm.y = (m + lapo.height) * j + m;
					_container.addChild(bm);
					
					var options:Object = {};
					switch(Math.round(Math.random() * 2))
					{
						case 0:
							options.colorize = Math.random() * 0xFFFFFF;
							options.amount = Math.random();
							break;
						case 1:
							options.contrast = Math.random() * 2;
							options.brightness = Math.random() * 2;
							break;
						case 2:
							options.saturation = Math.random() * 2;
							options.hue = Math.random() * 360;
							break;
					};
					
					TweenLite.to(bm, 3, { colorMatrixFilter: options } );
				}
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawItems();
			}
		}
    }
}
