/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.Event;
    import flash.filters.ShaderFilter;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
	import flash.utils.ByteArray;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
    public class RedShaderFilterExample extends Sprite
	{

        private var loader:URLLoader;
        private var s:Sprite;
		
		[Embed(source = "../assets/RedGradientFilter.pbj", mimeType = "application/octet-stream")]
		private var RedShader:Class;
		

        public function RedShaderFilterExample() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
			
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
            //loader.load(new URLRequest("RedGradientFilter.pbj"));
			
			
            s = new Sprite();
            s.graphics.beginFill(0x575757);
            s.graphics.drawCircle(200, 200, 150);
            addChild(s);
			
			
			// Alternative
			//var shader:Shader = new Shader();
			//shader.byteCode = new RedShader();

			// Or another way.
			
			var shader:Shader = new Shader(new RedShader());
            shader.data.width.value = [s.width];

            var gradientFilter:ShaderFilter = new ShaderFilter(shader);
            s.filters = [gradientFilter];
			
        }

        private function loadCompleteHandler(event:Event):void 
		{
            var shader:Shader = new Shader(loader.data);
            shader.data.width.value = [s.width];

            var gradientFilter:ShaderFilter = new ShaderFilter(shader);
            s.filters = [gradientFilter];
        }
    }
}