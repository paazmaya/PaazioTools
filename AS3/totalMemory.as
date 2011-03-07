while ( true )
{
	try
	{
		var b:BitmapData = new BitmapData(1024,1024,true,0);
	}
	catch ( e:Error )
	{
		break;
	}
};
trace("System.totalMemory: " + Math.round(System.totalMemory / (1024 * 1024)) + " MB");
