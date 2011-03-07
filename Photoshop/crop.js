
// enable double clicking from the Macintosh Finder or the Windows Explorer
#target photoshop

// in case we double clicked the file
app.bringToFront();



function crop(margin)
{
	app.preferences.rulerUnits = Units.PIXELS;
	bounds = new Array(margin, margin, app.activeDocument.width - margin, app.activeDocument.height - margin);
	app.activeDocument.crop(bounds);
	bounds = null;
}
