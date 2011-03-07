/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package
{
	import flash.display.*;
	import flash.events.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

    public class Looping extends Sprite
    {
		
        public function Looping()
        {
			var i:uint = 1500;
			while (i < 2000)
			{
				trace("(" + i + ", ''),");
				++i;
			}
        }
    }
}
