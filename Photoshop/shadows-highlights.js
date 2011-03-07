
// enable double clicking from the Macintosh Finder or the Windows Explorer
#target photoshop

// in case we double clicked the file
app.bringToFront();


var fileRef = File(app.path + "/Samples/Fish.psd");
var docRef = app.open(fileRef);

fix_darkness();
/*
Adjusts the range of tones in the
image’s shadows and highlights.
Amounts and widths are
percentage values. Radius
values are in pixels.
*/
var shadowAmount = 1; // [0..100]
var shadowWidth = 0; // [0.100]
var shadowRadius = 0; // [0..2500] pixels
var highlightAmount = 0; // [0..100]
var highlightWidth = 0; // [0..100]
var highlightRadius = 0; // [0..2500] pixels
var colorCorrection = 4; // [-100..100]
var midtoneContrast = 0; // [-100..100]
var blackClip = 0.01; // [0.000..50.000]
var whiteClip = 0.01; // [0.000..50.000]

var brightness = 0.2; // [-100..100]
var contrast = 0.1; // [-100..100]

function fix_darkness()
{
	var layer = artLayer;
	
	layer.shadowHighlight(
		shadowAmount,
		shadowWidth,
		shadowRadius,
		highlightAmount,
		highlightWidth,
		highlightRadius,
		colorCorrection,
		midtoneContrast,
		blackClip,
		whiteClip
	);

	layer.adjustBrightnessContrast(
		brightness,
		contrast
	);
}

