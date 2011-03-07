/**
 *
 */

// enable double clicking from the Macintosh Finder or the Windows Explorer
#target photoshop

// in case we double clicked the file
app.bringToFront();


var fileRef = File(app.path + "/Samples/Fish.psd")
var docRef = app.open(fileRef)

autocolor(true, true);

function autocolor(blackWhite, neutrals)
{

	var idLvls = charIDToTypeID( "Lvls" );

	var actionDesc = new ActionDescriptor();

	var autoBlackWhite = stringIDToTypeID( "autoBlackWhite" );
	actionDesc.putBoolean( autoBlackWhite, true );

	var autoNeutrals = stringIDToTypeID( "autoNeutrals" );
	actionDesc.putBoolean( autoNeutrals, true );

	executeAction( idLvls, actionDesc, DialogModes.NO );
}
