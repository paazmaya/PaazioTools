package sandbox
{
	import flash.display.Sprite;
	
	/**
	* Baseline Profile
		  o I/P slices
		  o Multiple reference frames (–refs <int>, >1 in the x264 CLI)
		  o In-loop deblocking
		  o CAVLC entropy coding (–no-cabac in the x264 CLI)
	* Main Profile
		  o Baseline Profile features mentioned above
		  o B slices
		  o CABAC entropy coding
		  o Interlaced coding - PAFF/MBAFF
		  o Weighted prediction
	* High Profile
		  o Main Profile features mentioned above
		  o 8 * 8 transform option (–8 * 8dct in the x264 CLI)
		  o Custom quantisation matrices
	*/
	public class H264Profiles extends Sprite
	{
		private var frameWidth:Number = 720;
		private var frameHeight:Number = 576;
		private var framerate:Number = 25;
		private var macroblockSize:Number = 16.0;
		
		/**
		 * h264 levels with their maximum values.
		 * - Level
		 * - VBV maximum bit rate [1000bits/s]
		 * - VBV buffer size [1000bits]
		 * - Macroblocks/s
		 * - Width * height * frame rate
		 */
		public static var levels:Array = [
			["1",       64,    175,   1485,  128 * 96 * 30], // 176 * 144 * 15
			["1b",     128,    350,   1485,  128 * 96 * 30], // 176 * 144 * 15
			["1.1",    192,    500,   3000, 176 * 144 * 30], // 320 * 240 * 10
			["1.2",    384,   1000,   6000, 176 * 144 * 60], // 320 * 240 * 20
			["1.3",    768,   2000,  11880, 352 * 288 * 30],
			["2",     2000,   2000,  11880, 352 * 288 * 30],
			["2.1",   4000,   4000,  19800, 352 * 288 * 50],
			["2.2",   4000,   4000,  20250, 352 * 288 * 50], // 640 * 480 * 15
			["3",    10000,  10000,  40500, 720 * 480 * 30], // 720 * 576 * 25
			["3.1",  14000,  14000, 108000, 1280 * 720 * 30],
			["3.2",  20000,  20000, 216000, 1280 * 720 * 60],
			["4",    20000,  25000, 245760, 1920 * 1088 * 30], // 2000 * 1000 * 30
			["4.1",  50000,  62500, 245760, 1920 * 1088 * 30], // 2000 * 1000 * 30
			["4.2",  50000,  62500, 522240, 1920 * 1088 * 60], // 2000 * 1000 * 60
			["5",   135000, 135000, 589824, 2560 * 1920 * 30],
			["5.1", 240000, 240000, 983040, 4000 * 2000 * 30] // 4096 * 2304 * 25
		];
		
		/**
		 *
		 * @see http://rob.opendot.cl/index.php/useful-stuff/h264-profiles-and-levels/
		 */
		public function H264Profiles ()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			var blocksPerFrame:Number = Math.ceil( frameWidth / macroblockSize ) * Math.ceil( frameHeight / macroblockSize );
			var blocksPerSecond:Number = blocksPerFrame * framerate;
		}
	}
}
