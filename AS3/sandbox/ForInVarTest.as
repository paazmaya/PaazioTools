/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.system.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
	public class ForInVarTest extends Sprite
	{
		private var _list:Array = [];

		public function ForInVarTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			var num:uint = 0;
			while (num < 10000)
			{
				_list.push(num);
				++num;
			}
			
			num = 0;
			for each(var item:uint in _list)
			{
				if (num != item)
				{
					trace(num + " did not match " + item);
				}
				++num;
			}
			
			/*
			var len:uint = _list.length;
			for (var i:uint = 0; i < len; ++i)
			{
				trace(i + "\t" + _list[i]);
			}
			*/
		}
	}
}
