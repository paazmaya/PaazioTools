/**
* @author Niels Bosma (niels.bosma@motorola.com
*/

var folder = Folder.selectDialog();
var document = app.activeDocument;
if(document && folder)
{	
	var options = new ExportOptionsPNG24();
	options.antiAliasing = true;
	options.transparency = true;
	
	hideAllLayers();
	
	var n = document.layers.length;
	for(var i=0; i<n; ++i)
	{
		var layer = document.layers[i];
		layer.visible = true;

		var file = new File(folder.fsName+"/"+layer.name+".png");
		
		var options = new ExportOptionsPNG24();
		options.artBoardClipping = true;
		
		document.exportFile(file,ExportType.PNG24,options);
		
		layer.visible = false;
	}
	
	showAllLayers();
}

function hideAllLayers()
{
	forEach(document.layers, function(layer) {
		layer.visible = false;
	});
}

function showAllLayers()
{
	forEach(document.layers, function(layer) {
		layer.visible = true;
	});		
}

function forEach(collection, fn)
{
	var n = collection.length;
	for(var i=0; i<n; ++i)
	{
		fn(collection[i]);
	}
}