/**********************************************************

ADOBE SYSTEMS INCORPORATED 
Copyright 2005-2008 Adobe Systems Incorporated 
All Rights Reserved 

NOTICE:  Adobe permits you to use, modify, and 
distribute this file in accordance with the terms
of the Adobe license agreement accompanying it.  
If you have received this file from a source 
other than Adobe, then your use, modification,
or distribution of it requires the prior 
written permission of Adobe. 

*********************************************************/

/**********************************************************
 
FreehandToAI.jsx

DESCRIPTION

Open all Freehand files specified in the user selected folder and save them as AI files

**********************************************************/

// Main Code [Execution of script begins here]

try
{
	// Get the folder to read files from
	var inputFolderPath = null;
    var totalFilesConverted = 0;
	inputFolderPath = Folder.selectDialog( 'Select Freehand Files Location.', '~' );
    
    if (inputFolderPath != null) {
        // Parse the folder name to get Folder Name Prefix
        var inputFolderStr = inputFolderPath.fullName;
        //var selectedFolderName = inputFolderPath.displayName;
        var selectedFolderName = inputFolderPath.name;
        while (selectedFolderName.indexOf ("%20") > 0)
        {
            selectedFolderName = selectedFolderName.replace ("%20", " ")
         }   
        var inputFolderArray = inputFolderStr.split (selectedFolderName);
        var inputFolderPrefix = inputFolderArray[0];

        // Get the folder to save the files into
        var destFolder = null;
        destFolder = Folder.selectDialog( 'Select Output AI Location.', '~' );

        if (destFolder != null) {
            app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;

            // Set Freehand options
            var FreehandOptions = app.preferences.FreeHandFileOptions;
            FreehandOptions.convertTextToOutlines = false;
            FreehandOptions.importSinglePage = false;
    
            // Recursively read all Freehand files and convert to AI
            ConvertFHToAI(inputFolderPath);
        }
    }
        alert( totalFilesConverted + ' Freehand files were converted to AI' );
}
catch (err)
{
   rs = ("ERROR: " + (err.number & 0xFFFF) + ", " + err.description);
   alert(rs);
}


/**  Function to recursively read all Freehand files from the input folder and save them as AI file in the destination folder
	@param inputFolderPath the input folder path from where Freehand files would be read
*/
function ConvertFHToAI(inputFolderPath)
{
  
	var testFiles = new Array();
	var index = 0;
    
	// Create output folder path to be created
	pathToAppend = inputFolderPath.fullName.split(inputFolderPrefix);
	var saveFolder = destFolder + "/" + pathToAppend[1];

	// Create folder
    
	fldr = new Folder(saveFolder);
	fldr.create();
    
    if (!(fldr.exists))
    {
        throw new Error('Access is denied');
    }    
    
	// Get list of files/folders in the current working folder
	testFiles = inputFolderPath.getFiles("*.*");

	for (index = 0; index < testFiles.length;index++)
	{
        // Check if current item is file or folder
        if (testFiles[index] instanceof Folder)
        {
            ConvertFHToAI(testFiles[index]);
        }
        else
        {
            // Selected Item is a file
            fileName = testFiles[index].displayName;
            
            var fileExtensionArray = fileName.split(".", 2);
            var fileExtension = fileExtensionArray[1].toUpperCase();
            
            // Check is file is a freehand file
            if (fileExtension == "FH11" || fileExtension == "FH10" || fileExtension == "FH9" || fileExtension == "FH8" || fileExtension == "FH7" )
            {
                // Open Freehand file
                var docRef =app.open(testFiles[index]);	
                obj_doc=app.activeDocument;
                    
                // Create output file path
                var filePreName = testFiles[index].displayName.split(".",1);               
                sDocumentPath = saveFolder +"/"+ filePreName + ".ai" ;
		
                // Save file as AI
                SaveAsAI(sDocumentPath);
                
                // Increment counter of total number of files converted
                totalFilesConverted = totalFilesConverted + 1;
                    
                // Close the document
                app.activeDocument.close( SaveOptions.DONOTSAVECHANGES );
            }
        }   
    }   
} 

/** Save the current opened document as AI file
	@param sDocumentPath the name of output path where file needs to be saved
*/
function SaveAsAI(sDocumentPath)
{
    theFile = new File(sDocumentPath);
                    
    // Create AI Save options
    var aiOptions  = new IllustratorSaveOptions();
    
    // For any changes to Save options please refer to IllustratorSaveOptions in the JavaScript Reference for available options

	// For example, to save file as AI CS4 file use
	aiOptions.compatibility = Compatibility.ILLUSTRATOR14;
    
    aiOptions.compressed = true;
    aiOptions.embedICCProfile = false;
    aiOptions.embedLinkedFiles = false;
    aiOptions.flattenOutput = OutputFlattening.PRESERVEAPPEARANCE;
    aiOptions.fontSubsetThreshold = 100;
    aiOptions.pdfCompatible = true;
    
      
    // Uncomment the code below if you want to save each Artboard to seperate file
 /*   obj_doc=app.activeDocument;
    var artboardLength = obj_doc.artboards.length;
  if (artboardLength > 1)
    {
        aiOptions.saveMultipleArtboards = true;
        aiOptions.artboardRange = "";
    }   
    */
    // Save as AI file    
    obj_doc.saveAs (theFile, aiOptions);
}
