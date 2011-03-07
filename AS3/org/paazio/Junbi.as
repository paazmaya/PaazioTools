package org.paazio {
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * Junbi - Preparation (a preloader)
	 * -Matsuri no Junbi-
	 * @see http://www.imdb.com/title/tt0188885/
	 */
	public class Junbi extends MovieClip {

		private var _mainClassName:String = "Main";
		private var _bar:Sprite;

		public function Junbi() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			_bar = new Sprite();
			_bar.x = stage.stageWidth / 4;
			_bar.y = (stage.stageHeight - 10) / 2;
			this.addChild(_bar);

			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0x000000);
			line.graphics.drawRect(0, 0, stage.stageWidth / 2, 10);
			_bar.addChild(line);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void 
		{
			var percent:uint = Math.floor(stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal * 100);
			updateGraphics(percent);
			if (percent == 100) {
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.removeChild(_bar);
				loadMain();
			}
		}
		
		private function updateGraphics(percent:uint):void 
		{
			var gra:Graphics = _bar.graphics;
			gra.clear();
			gra.beginFill(0xFFD106);
			gra.drawRect(0, 0, (stage.stageWidth / 2) * percent / 100, 10);
			gra.endFill();
		}
		
		private function loadMain():void 
		{
			stop();
			
			var MainClass:Class = getDefinitionByName(_mainClassName) as Class;
			if (MainClass == null) {
				throw new Error("Junbi:loadMain. There was no class matching [" + _mainClassName + "].");
			}
			
			var main:DisplayObject = new MainClass() as DisplayObject;
			if (main == null) {
				throw new Error("Junbi::loadMain. [" + _mainClassName + "] needs to inherit from Sprite or MovieClip.");
			}
			
			this.addChildAt(main, 0);
		}
		
	}
}
