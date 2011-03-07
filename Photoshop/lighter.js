
// enable double clicking from the Macintosh Finder or the Windows Explorer
#target photoshop

// in case we double clicked the file
app.bringToFront();

var fileRef = File(app.path + "/Samples/Fish.psd");
var docRef = app.open(fileRef);

lighter();

function lighter()
{
	var idOpn = charIDToTypeID( "Opn " );
	var desc1 = new ActionDescriptor();
	var idnull = charIDToTypeID( "null" );
	desc1.putPath( idnull, new File( "D:\\galerija\\Tallinna2009-06\\Tallinna2009-06_243.jpg" ) );
	executeAction( idOpn, desc1, DialogModes.NO );

	// =======================================================
	var idLvls = charIDToTypeID( "Lvls" );
	var desc2 = new ActionDescriptor();
	var idpresetKind = stringIDToTypeID( "presetKind" );
	var idpresetKindType = stringIDToTypeID( "presetKindType" );
	var idpresetKindFactory = stringIDToTypeID( "presetKindFactory" );
	desc2.putEnumerated( idpresetKind, idpresetKindType, idpresetKindFactory );
	var idUsng = charIDToTypeID( "Usng" );
	desc2.putPath( idUsng, new File( "C:\\Program Files\\Adobe\\Adobe Photoshop CS4\\Presets\\Levels\\Lighter.alv" ) );
	executeAction( idLvls, desc2, DialogModes.NO );

	// =======================================================
	var idsave = charIDToTypeID( "save" );
	executeAction( idsave, undefined, DialogModes.NO );

	// =======================================================
	var idCls = charIDToTypeID( "Cls " );
	executeAction( idCls, undefined, DialogModes.NO );
}
