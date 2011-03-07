// Sparklines for Photoshop
// (c) Copyright 2004, 2005 Mathew Lodge / www.lodgephoto.com
// Last updated: 4 May 2005 (v2)

// For debugging only
//$.level = 1; debugger;


// Plug in your own values here
var defaultXSpacing = 1.0; // Default x axis pixel spacing between points on the sparkline
var defaultHeight = 50; // Default height of image, in pixels -- 1 inch = 72 pixels
// Width will be dependent on the size of the data set


// Save current units settings
var startRulerUnits = app.preferences.rulerUnits;
var startDisplayDialogs = app.displayDialogs;
var startTypeUnits = app.preferences.typeUnits;

// Switch to pixel units and turn off dialogs
app.preferences.rulerUnits = Units.PIXELS;
app.preferences.typeUnits = TypeUnits.PIXELS;
app.displayDialogs = DialogModes.ERROR;

try {
	if (runningOnMac())
		var dataFile = File.openDialog("Select data file");
	else // Windows
		var dataFile = File.openDialog("Select data file", "Text files:*.txt;*.TXT,All files:*");

	// Read the data file	
	var data_set = readDataFile(File(dataFile.fsName));
	var legend = data_set[0]; // Assumption: first line of file contains legend
	
	// Find the min and max of the data set
	var lowest, highest;
	lowest = highest = Number(data_set[1]);
	for (var i = 2; i<data_set.length; i++) {
		datum = Number(data_set[i]);
		if (datum < lowest)
			lowest = datum;
		if (datum > highest)
			highest = datum;
	}
	
	var height = Number(prompt(legend+": Pixel height of sparkline?", defaultHeight));
	var scaleLine = confirm(legend+": Automatically fit (scale) sparkline to document height?");
	var yIntercept = lowest;
	if (!scaleLine) {
		yIntercept = Number(prompt(legend+": Y intercept (min value) of sparkline?", lowest));
		highest = Number(prompt(legend+": Max y value of sparkline?", highest));
	}
	var xSpacing = Number(prompt(legend+": X axis pixel spacing between points?", defaultXSpacing));

	var scale = height/(highest-yIntercept); // Y axis scale
	var width = (data_set.length * xSpacing);
	
	// Create the sparkline Photoshop document and bring it to the front
	sparklineDoc = app.documents.add(width, height, 72,
						"Sparkline for "+legend,
						NewDocumentMode.RGB,
						DocumentFill.WHITE,
						1.0);
	app.activeDocument = sparklineDoc;
	
	// Create the point array for the sparkline
	var pointArray = new Array();
	var currX = 0;
	var currY;
	for (var i = 1; i < data_set.length; i++) {
		currY = height - ((Number(data_set[i])-yIntercept) * scale);
		addPointToArray(pointArray, currX, currY);
		currX = currX + xSpacing;
	}
	
	var sparklineSubPath = new SubPathInfo();
	sparklineSubPath.operation = ShapeOperation.SHAPEXOR;
	sparklineSubPath.closed = false;
	sparklineSubPath.entireSubPath = pointArray;
	
	var sparklinePath = sparklineDoc.pathItems.add("Sparkline", Array(sparklineSubPath));
	// Stroke the path so it becomes visible, then deselect the path
	sparklinePath.strokePath(ToolType.PENCIL);
	sparklinePath.deselect();
	
}
catch(e)
{
	alert(e);
}

app.preferences.rulerUnits = startRulerUnits;
app.preferences.typeUnits = startTypeUnits;
app.displayDialogs = startDisplayDialogs;


function readDataFile(dataFile)
// Reads a text file (typically output from Excel)
// Assumes that there is one number per line
// Blank lines are ignored
{
	var line; // Line read from file
	var data_series = new Array; // The data series to be returned
	
	var result = dataFile.open("r", "TEXT", "");
		if (!result)
		throw dataFile.error;
	
	var index = 0;
	var line;
	while (!dataFile.eof) {
		line = dataFile.readln();
		if (line.search(/\S/) != -1) // if line is not blank
			data_series[index++] = line;
    }
	return data_series;
}

function runningOnMac() {
	return (File.fs.search(/mac/i) == 0);
}

function addPointToArray(parray, x, y) {
	var idx = parray.length;
	
	parray[idx] = new PathPointInfo;
	parray[idx].kind = PointKind.SMOOTHPOINT;
	parray[idx].anchor = Array(x, y);
	parray[idx].leftDirection = parray[idx].anchor;
	parray[idx].rightDirection = parray[idx].anchor;
}
