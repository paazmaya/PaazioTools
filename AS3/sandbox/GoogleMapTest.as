/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.Event;
	import flash.geom.Point;
	
	import com.google.maps.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

	/**
	 * Simple Google Maps API for Flash test.
	 * Using SDK version 1.18, 2009-11-20.
	 * @see http://code.google.com/apis/maps/documentation/flash/
	 */
    public class GoogleMapTest extends Sprite
    {
		// paazio.nanbudo.fi
		private const API_KEY:String = "ABQIAAAAyLIwOFKaznKcdf7DtmATHRSOHUBqwq8HX55q_HSUVSjUxiNQnxQ38C9_FB8a3tJDlMcK74nZzv07vA";
		private const LANG:String = "ja";
		
		private var _map:Map;

        public function GoogleMapTest()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
            addEventListener( Event.ADDED_TO_STAGE, onInit );
        }

        private function onInit( event:Event ) : void
        {
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			_map = new Map();
			_map.width = 800;
			_map.height = 600;
			_map.key = API_KEY;
			_map.language = LANG;
			_map.addEventListener(MapMouseEvent.CLICK, onMapClick);
			addChild(_map);
			
			trace("Created map. version: " + _map.version);
        }

		/**
		 * Resize while keeping the center
		 * @param	event
		 */
		private function onStageResize(event:Event):void
		{
			var center:LatLng = _map.getCenter();
			_map.width = stage.stageWidth;
			_map.height = stage.stageHeight;
			_map.panTo(center);
		}
		
		private function onMapClick(event:MapMouseEvent):void
		{
			var pos:LatLng = event.latLng;
			trace("onMapClick. lat: " + pos.lat() + ", deg2dms: " + deg2dms(pos.lat(), true));
			trace("onMapClick. lng: " + pos.lng() + ", deg2dms: " + deg2dms(pos.lng(), false));
			_map.panTo(pos);
		}
		
		private function deg2dms(degfloat:Number, isLatitude:Boolean):String {
			var letter:String = '';
			if (isLatitude)
			{
				letter = 'NS';
			}
			else
			{
				letter = 'EW';
			}
			if (degfloat < 0) 
			{
				degfloat = Math.abs(degfloat);
				letter = letter.substr(1, 1);
			}
			else
			{
				letter = letter.substr(0, 1);
			}

			//trace('deg_to_dms. degfloat: ' + degfloat);

			var deg:uint = Math.floor(degfloat);
			//trace('deg_to_dms. deg: ' + deg);
			var minfloat:Number = 60 * ( degfloat - deg );
			//trace('deg_to_dms. minfloat: ' + minfloat);
			var min:uint = Math.floor(minfloat);
			//trace('deg_to_dms. min: ' + min);
			var secfloat:Number = 60 * ( minfloat - min );
			//trace('deg_to_dms. secfloat: ' + secfloat);
			secfloat = Math.round( secfloat );

			if (secfloat == 60)
			{
				min = min + 1;
				secfloat = 0;
			}
			if (min == 60)
			{
				deg = deg + 1;
				min = 0;
			}
			//W 87°43'41"
			
			return (deg + '° ' + min + "' " + secfloat + '" ' + letter);
		}
    }
}
