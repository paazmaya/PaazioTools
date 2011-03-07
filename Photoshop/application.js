//Create a Welcome message
// Use the name and version properties of the application object to
// Append the application’s name and version to the Welcome message
// use "\r" to insert a carriage return
// use the combination operator += to append info to the message
var message = "Welcome to " + app.name
message += " version " + app.version + "\r\r"
// find out where Adobe Photoshop CS4 is installed
// and add the path to the message
// add the optional parameter fsName to the path property
// to display the file system name in the most common format
message += "I’m installed in " + app.path.fsName + "\r\r"
// see how much memory Adobe Photoshop CS4 has to play with
message += "You have this much memory available for Adobe Photoshop CS4: " +
app.freeMemory + "\r\r"
// use the length property of the documents object to
// see how many documents are open
var documentsOpen = app.documents.length
message += "You currently have " + documentsOpen + " document(s) open.\r\r"
// display the message to the user
alert(message)
// answer will be true for a "Yes" answer and false for a "No" answer
var answer = confirm("Set the foreground and background to my favorite colors?")
// set the colors
if (answer) {
	// I don’t have a favorite color. Why did I ask you may wonder?
	app.foregroundColor.rgb.red = Math.random() * 255
	app.foregroundColor.rgb.green = Math.random() * 255
	app.foregroundColor.rgb.blue = Math.random() * 255
	app.backgroundColor.rgb.red = Math.random() * 255
	app.backgroundColor.rgb.green = Math.random() * 255
	app.backgroundColor.rgb.blue = Math.random() * 255
}
// Open a document
if (app.documents.length == 0) {
// use the application’s path and the offset to the samples folder
var sampleDocToOpen = File(app.path + "/Samples/Fish.psd")
// compose a message with the name of the file
message = "Would you like me to open a sample for you? ("
message += sampleDocToOpen.fsName
message += ")"
// ask the user another question
answer = confirm(message)
// open the document accordingly
if (answer) {
open(sampleDocToOpen)
}
}
