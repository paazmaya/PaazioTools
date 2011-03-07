/**
 * @mxmlc -target-player=10.0.0 -debug -incremental=false -noplay -source-path=D:/AS3libs
 */
package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '300', height = '100')]
	
	/**
	 * @see http://www.minedu.fi/OPM/Tiedotteet/2009/04/Liikuntapaikkarakentaminen.html
	 */
	public class Solitaire extends Sprite
	{

		private var _cardsPerKind:uint = 13;
		private var _kinds:Array = ["Hearts", "", "", ""];

		public function Solitaire() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
			
		}

	}
}
