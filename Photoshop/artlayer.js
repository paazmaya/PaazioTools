/*
The following script opens all the files in the samples folder, creating one multi-layered document. Each
layer is pasted into one of four quadrants and given 50% transparency. Finally the layers are sorted by
name.
*/

// Save the current preferences
var startRulerUnits = app.preferences.rulerUnits
var startTypeUnits = app.preferences.typeUnits
var startDisplayDialogs = app.displayDialogs

// Set Adobe Photoshop CS4 to use pixels and display no dialogs
app.preferences.rulerUnits = Units.PIXELS
app.preferences.typeUnits = TypeUnits.PIXELS
app.displayDialogs = DialogModes.NO

//Close all the open documents
while (app.documents.length) {
	app.activeDocument.close()
}

// Create a new document to merge all the samples into
var mergedDoc = app.documents.add(1000, 1000, 72, "Merged Samples", NewDocumentMode.RGB, DocumentFill.TRANSPARENT, 1)
// Use the path to the application and append the samples folder
var samplesFolder = Folder(app.path + "/Samples/")
//Get all the files in the folder
var fileList = samplesFolder.getFiles()

// open each file
for (var i = 0; i < fileList.length; i++) {
	// The fileList is folders and files so open only files
	if (fileList[i] instanceof File) {
		open(fileList[i])
		// use the document name for the layer name in the merged document
		var docName = app.activeDocument.name
		// flatten the document so we get everything and then copy
		app.activeDocument.flatten()
		app.activeDocument.selection.selectAll()
		app.activeDocument.selection.copy()
		// don’t save anything we did
		app.activeDocument.close(SaveOptions.DONOTSAVECHANGES)
		
		// make a random selection on the document to paste into
		// by dividing the document up in 4 quadrants and pasting
		// into one of them by selecting that area
		var topLeftH = Math.floor(Math.random() * 2)
		var topLeftV = Math.floor(Math.random() * 2)
		var docH = app.activeDocument.width.value / 2
		var docV = app.activeDocument.height.value / 2
		var selRegion = Array(Array(topLeftH * docH, topLeftV * docV),
			Array(topLeftH * docH + docH, topLeftV * docV),
			Array(topLeftH * docH + docH, topLeftV * docV + docV),
			Array(topLeftH * docH, topLeftV * docV + docV),
			Array(topLeftH * docH, topLeftV * docV))
		app.activeDocument.selection.select(selRegion)
		app.activeDocument.paste()
		// change the layer name and opacity
		app.activeDocument.activeLayer.name = docName
		app.activeDocument.activeLayer.fillOpacity = 50
	}
}

// sort the layers by name
for (var x = 0; x < app.activeDocument.layers.length; x++) {
	for (var y = 0; y < app.activeDocument.layers.length - 1 - x; y++) {
		// Compare in a non-case sensitive way
		var doc1 = app.activeDocument.layers[y].name
		var doc2 = app.activeDocument.layers[y + 1].name
		if (doc1.toUpperCase() > doc2.toUpperCase()) {
			app.activeDocument.layers[y].move(app.activeDocument.layers[y+1],
			ElementPlacement.PLACEAFTER)
		}
	}
}

// Reset the application preferences
app.preferences.rulerUnits = startRulerUnits
app.preferences.typeUnits = startTypeUnits
app.displayDialogs = startDisplayDialogs
