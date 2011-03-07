/**
 * @mxmlc -target-player=10.0.0
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.FileReferenceList;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

    public class FileReferenceListExample extends Sprite
	{
        public static const LIST_COMPLETE:String = "listComplete";
		
        public function FileReferenceListExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
            initiateFileUpload();
        }
		
        private function initiateFileUpload():void
		{
            var fileRef:CustomFileReferenceList = new CustomFileReferenceList();
            fileRef.addEventListener(FileReferenceListExample.LIST_COMPLETE, listCompleteHandler);
            fileRef.browse(fileRef.getTypes());
        }
		
        private function listCompleteHandler(event:Event):void
		{
            trace("listCompleteHandler");
        }
    }
}

import flash.events.*;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.net.FileFilter;
import flash.net.URLRequest;

class CustomFileReferenceList extends FileReferenceList
{
    private var uploadURL:URLRequest;
    private var pendingFiles:Array;
    public function CustomFileReferenceList()
	{
        uploadURL = new URLRequest();
        uploadURL.url = "http://www.[yourDomain].com/yourUploadHandlerScript.cfm";
        initializeListListeners();
    }
    private function initializeListListeners():void
	{
        addEventListener(Event.SELECT, selectHandler);
        addEventListener(Event.CANCEL, cancelHandler);
    }
    public function getTypes():Array
	{
        var allTypes:Array = new Array();
        allTypes.push(getImageTypeFilter());
        allTypes.push(getTextTypeFilter());
        return allTypes;
    }

    private function getImageTypeFilter():FileFilter
	{
        return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
    }

    private function getTextTypeFilter():FileFilter
	{
        return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
    }

    private function doOnComplete():void
	{
        var event:Event = new Event(FileReferenceListExample.LIST_COMPLETE);
        dispatchEvent(event);
    }

    private function addPendingFile(file:FileReference):void
	{
        trace("addPendingFile: name=" + file.name);
        pendingFiles.push(file);
        file.addEventListener(Event.OPEN, openHandler);
        file.addEventListener(Event.COMPLETE, completeHandler);
        file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        file.upload(uploadURL);
    }

    private function removePendingFile(file:FileReference):void
	{
        for (var i:uint; i < pendingFiles.length; ++i)
		{
            if (pendingFiles[i].name == file.name)
			{
                pendingFiles.splice(i, 1);
                if (pendingFiles.length == 0)
				{
                    doOnComplete();
                }
                return;
            }
        }
    }

    private function selectHandler(event:Event):void
		{
        trace("selectHandler: " + fileList.length + " files");
        pendingFiles = new Array();
        var file:FileReference;
        for (var i:uint = 0; i < fileList.length; ++i)
			{
            file = FileReference(fileList[i]);
            addPendingFile(file);
        }
    }

    private function cancelHandler(event:Event):void
		{
        var file:FileReference = FileReference(event.target);
        trace("cancelHandler: name=" + file.name);
    }

    private function openHandler(event:Event):void
		{
        var file:FileReference = FileReference(event.target);
        trace("openHandler: name=" + file.name);
    }

    private function progressHandler(event:ProgressEvent):void
		{
        var file:FileReference = FileReference(event.target);
        trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
    }

    private function completeHandler(event:Event):void
		{
        var file:FileReference = FileReference(event.target);
        trace("completeHandler: name=" + file.name);
        removePendingFile(file);
    }

    private function httpErrorHandler(event:Event):void
		{
        var file:FileReference = FileReference(event.target);
        trace("httpErrorHandler: name=" + file.name);
    }

    private function ioErrorHandler(event:Event):void
		{
        var file:FileReference = FileReference(event.target);
        trace("ioErrorHandler: name=" + file.name);
    }

    private function securityErrorHandler(event:Event):void
		{
        var file:FileReference = FileReference(event.target);
        trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
    }
}
