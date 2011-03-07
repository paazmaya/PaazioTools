/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    [SWF(backgroundColor='0x668822',frameRate='33',width='800',height='600')]
    /**
     * Tests for each type of a BitmapFilter.
     * - BevelFilter
     * - BlurFilter
     * - ColorMatrixFilter
     * - ConvolutionFilter
     * - DisplacementMapFilter
     * - DropShadowFilter
     * - GlowFilter
     * - GradientBevelFilter
     * - GradientGlowFilter
     * - ShaderFilter
     */
    public class BitmapFiltersTest extends Sprite
    {

        /**
         *
         */
        public function BitmapFiltersTest()
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            loaderInfo.addEventListener(Event.INIT, onInit);
        }

        private var _filterNames:Array = [
			"BevelFilter",
			"BlurFilter",
			"ColorMatrixFilter",
			"ConvolutionFilter",
			"DisplacementMapFilter",
			"DropShadowFilter",
			"GlowFilter",
			"GradientBevelFilter",
			"GradientGlowFilter",
			"ShaderFilter"
		];

        private var _h:Number = 100;

        private var _m:Number = 40;

        private var _perRow:uint = 4;

        private var _w:Number = 200;

        private function applyFilter(target:Sprite, name:String = ""):void
        {
            var filters:Array = [];

            var distance:Number = 8;
            var angle:Number = 45;
            var blur:Number = 8;
            var quality:int = BitmapFilterQuality.MEDIUM;
            var type:String = BitmapFilterType.INNER;
            var mode:String = DisplacementMapFilterMode.WRAP;
            var strength:Number = 1;
            var color:uint = 0xF4F4F4;
            var alpha:Number = 1.0;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var hideObject:Boolean = false;
            var preserveAlpha:Boolean = true;
            var clamp:Boolean = true;

            switch (name)
            {
                case "BevelFilter":
                    filters = [ new BevelFilter(distance, angle, color, alpha, 0x000000, 1.0, blur, blur, strength, quality, type, knockout)];
                    break;
                case "BlurFilter":
                    filters = [ new BlurFilter(blur, blur, quality)];
                    break;
                case "ColorMatrixFilter":
                    filters = [ new ColorMatrixFilter()];
                    break;
                case "ConvolutionFilter":
                    filters = [ new ConvolutionFilter(0, 0, null, 1, 0, preserveAlpha, clamp, color, alpha)];
                    break;
                case "DisplacementMapFilter":
                    filters = [ new DisplacementMapFilter(null, null, 0, 0, 0, 0, mode, color, alpha)];
                    break;
                case "DropShadowFilter":
                    filters = [ new DropShadowFilter(distance, angle, color, alpha, blur, blur, strength, quality, inner, knockout, hideObject)];
                    break;
                case "GlowFilter":
                    filters = [ new GlowFilter(color, alpha, blur, blur, strength, quality, inner, knockout)];
                    break;
                case "GradientBevelFilter":
                    filters = [ new GradientBevelFilter(distance, angle, null, null, null, blur, blur, strength, quality, type, knockout)];
                    break;
                case "GradientGlowFilter":
                    filters = [ new GradientGlowFilter(distance, angle, null, null, null, blur, blur, strength, quality, type, knockout)];
                    break;
                case "ShaderFilter":
                    filters = [ new ShaderFilter(null)];
                    break;
            }

            target.filters = filters;
        }

        private function createBoxes():void
        {
            var len:uint = _filterNames.length;
            var row:int = 0;
            for (var i:uint = 0; i < len; ++i)
            {
                var sp:Sprite = new Sprite();
                sp.name = _filterNames[i] as String;
                sp.mouseChildren = false;
                sp.addEventListener(MouseEvent.CLICK, onClick);
                sp.x = (_w + _m) * (i - row * _perRow) + _m;
                sp.y = (_h + _m) * row + _m;
                if (i % _perRow == _perRow - 1)
                {
                    ++row;
                }
                drawBox(sp.graphics);
                createField(sp, sp.name);
                if (getChildByName(sp.name) != null)
                {
                    removeChild(getChildByName(sp.name));
                }
                addChild(sp);
            }
        }

        private function createField(target:Sprite, text:String):void
        {
            var format:TextFormat = new TextFormat();
            format.size = 14;
            format.font = "Verdana";
            format.bold = true;

            var field:TextField = new TextField();
            field.defaultTextFormat = format;
            field.x = _m / 2;
            field.y = _m / 2;
            field.multiline = true;
            field.wordWrap = true;
            field.width = target.width - _m;
            field.height = target.height - _m;
            field.text = text;
            target.addChild(field);
        }

        private function drawBox(gra:Graphics):void
        {
            gra.clear();
            gra.beginFill(0xBBCCDD + Math.random() * 0x101010);
            gra.drawRoundRectComplex(0, 0, _w, _h, 0, 64, 24, 0);
            gra.endFill();
        }

        private function onClick(event:MouseEvent):void
        {
            var sp:Sprite = event.target as Sprite;
            if (sp.filters.length == 0)
            {
                applyFilter(sp, sp.name);
            }
            else
            {
                sp.filters = [];
            }
        }

        private function onInit(event:Event):void
        {
            createBoxes();
            stage.addEventListener(Event.RESIZE, onResize);
        }

        private function onResize(event:Event):void
        {
            _perRow = Math.floor((stage.stageWidth - _m) / (_w + _m));
            createBoxes();
        }
    }
}
