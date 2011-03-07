/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	public class AbsoluteTest extends Sprite
	{
		public function AbsoluteTest()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			for (var i:int = -20; i < 20; i += 0.5)
			{
				for (var j:uint = 0; j < 3; ++j)
				{
					trace("abs(" + i + ", " + j + ") = " + abs(i, j));
				}
			}
		}
		
		/**
		 * @see http://lab.polygonal.de/2007/05/10/bitwise-gems-fast-integer-math/
		 */
		public static function abs(value:Number, type:uint = 0):Number
		{
			switch (type)
			{
				case 2:
					return (value < 0 ? -value : value);
					break;
					
				case 1:
					return (value ^ (value >> 31)) - (value >> 31);
					break;
					
				case 0:
				default :
					return Math.abs(value);
					break;
			}
		}
		
	}
}
