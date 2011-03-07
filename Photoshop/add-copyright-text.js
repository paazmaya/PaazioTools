

// enable double clicking from the Macintosh Finder or the Windows Explorer
#target photoshop

// in case we double clicked the file
app.bringToFront();

// debug level: 0-2 (0:disable, 1:break on error, 2:break at beginning)
// $.level = 0;
// debugger; // launch debugger on next line

// Should create a dialog asking for:
// - Text
// - color
// - font drop down list
// - font size
// - position, which would be pointed in the thumbnail, or by given in two fields (x, y)

add_text("Kukkuu apina", "FF6600", "Verdana", 20, 10, 30);

function add_text(value, color, font, size, x, y)
{
	// Save the original units
	var strtRulerUnits = app.preferences.rulerUnits;
	var strtTypeUnits = app.preferences.typeUnits;
	
	// Set units to use in this function
	app.preferences.rulerUnits = Units.PIXELS;
	app.preferences.typeUnits = TypeUnits.POINTS;

	// w, h, res
	var docRef = app.documents.add(app.activeDocument.width, app.activeDocument.height, 72);

	// Suppress all dialogs
	app.displayDialogs = DialogModes.NO;

	var textColor = new SolidColor;
	textColor.rgb.hexValue = color;
	
	var textFont = app.fonts.getByName(font);
		
	var textLayer = docRef.artLayers.add();
	textLayer.kind = LayerKind.TEXT;
	textLayer.textItem.contents = value;
	textLayer.textItem.color = textColor;
	textLayer.textItem.font = textFont.postScriptName;
	textLayer.textItem.position = [x, y];
	textLayer.textItem.size = size;

	// Restore the original units
	app.preferences.rulerUnits = strtRulerUnits;
	app.preferences.typeUnits = strtTypeUnits;
	
	// Clean memory
	docRef = null;
	textColor = null;
	textFont = null;
	textLayer = null;
}

function strokeFilter()
{

	// =======================================================
	var idsetd = charIDToTypeID( "setd" );
		var desc15 = new ActionDescriptor();
		var idnull = charIDToTypeID( "null" );
			var ref6 = new ActionReference();
			var idPrpr = charIDToTypeID( "Prpr" );
			var idLefx = charIDToTypeID( "Lefx" );
			ref6.putProperty( idPrpr, idLefx );
			var idLyr = charIDToTypeID( "Lyr " );
			var idOrdn = charIDToTypeID( "Ordn" );
			var idTrgt = charIDToTypeID( "Trgt" );
			ref6.putEnumerated( idLyr, idOrdn, idTrgt );
		desc15.putReference( idnull, ref6 );
		var idT = charIDToTypeID( "T   " );
			var desc16 = new ActionDescriptor();
			var idScl = charIDToTypeID( "Scl " );
			var idPrc = charIDToTypeID( "#Prc" );
			desc16.putUnitDouble( idScl, idPrc, 100.000000 );
			var idFrFX = charIDToTypeID( "FrFX" );
				var desc17 = new ActionDescriptor();
				var idenab = charIDToTypeID( "enab" );
				desc17.putBoolean( idenab, true );
				var idStyl = charIDToTypeID( "Styl" );
				var idFStl = charIDToTypeID( "FStl" );
				var idOutF = charIDToTypeID( "OutF" );
				desc17.putEnumerated( idStyl, idFStl, idOutF );
				var idPntT = charIDToTypeID( "PntT" );
				var idFrFl = charIDToTypeID( "FrFl" );
				var idSClr = charIDToTypeID( "SClr" );
				desc17.putEnumerated( idPntT, idFrFl, idSClr );
				var idMd = charIDToTypeID( "Md  " );
				var idBlnM = charIDToTypeID( "BlnM" );
				var idNrml = charIDToTypeID( "Nrml" );
				desc17.putEnumerated( idMd, idBlnM, idNrml );
				var idOpct = charIDToTypeID( "Opct" );
				var idPrc = charIDToTypeID( "#Prc" );
				desc17.putUnitDouble( idOpct, idPrc, 100.000000 );
				var idSz = charIDToTypeID( "Sz  " );
				var idPxl = charIDToTypeID( "#Pxl" );
				desc17.putUnitDouble( idSz, idPxl, 3.000000 );
				var idClr = charIDToTypeID( "Clr " );
					var desc18 = new ActionDescriptor();
					var idRd = charIDToTypeID( "Rd  " );
					desc18.putDouble( idRd, 0.000000 );
					var idGrn = charIDToTypeID( "Grn " );
					desc18.putDouble( idGrn, 0.000000 );
					var idBl = charIDToTypeID( "Bl  " );
					desc18.putDouble( idBl, 0.000000 );
				var idRGBC = charIDToTypeID( "RGBC" );
				desc17.putObject( idClr, idRGBC, desc18 );
			var idFrFX = charIDToTypeID( "FrFX" );
			desc16.putObject( idFrFX, idFrFX, desc17 );
		var idLefx = charIDToTypeID( "Lefx" );
		desc15.putObject( idT, idLefx, desc16 );
	executeAction( idsetd, desc15, DialogModes.NO );
}
