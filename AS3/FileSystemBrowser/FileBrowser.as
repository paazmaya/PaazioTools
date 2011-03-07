package org.paazio {
	import flash.display.*;
	import mx.core.*;
	import flash.filesystem.*;
	import flash.events.*;
	
    import mx.core.WindowedApplication;
    import mx.containers.VBox;
    import mx.controls.Button;

    import mx.events.FlexEvent;
    import flash.events.*;

    import flash.desktop.*;
    import flash.filesystem.File;
    import flash.net.*;
	
	public class FileBrowser extends WindowedApplication {
		
		private var file:File = new File();
		
        private var filesToUpload :Array
        private var UploadProgressComponents :Array;
        public var files_vb:VBox;
        public var upload_btn:Button;
        private var uploadURL:URLRequest;
		
		public function FileBrowser() 
		{
            addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
		}
		
        private function creationCompleteHandler( event:FlexEvent ) :void  {
            addEventListener( NativeDragEvent.NATIVE_DRAG_ENTER,    onDragEnter );
            addEventListener( NativeDragEvent.NATIVE_DRAG_DROP,     onDragDrop );
			
			file.addEventListener(Event.SELECT, dirSelected);
			file.browseForDirectory("Select a directory");			
		}
		
		private function dirSelected(event:Event):void 
		{
			trace(file.nativePath);
		}
		
		private function onDragEnter( event:NativeDragEvent ) :void
        {
           DragManager.acceptDragDrop(this);
        }

        private function onDragDrop( event:NativeDragEvent ) :void
        {
            DragManager.dropAction = DragActions.COPY;
            var files:Array = event.transferable.dataForFormat( TransferableFormats.FILE_LIST_FORMAT ) as Array;
            for each (var f:File in files)
            {
               addFile( FileReference( f ) );
            }

            upload_btn.enabled = true;
        }
		
		private function addFile( f:FileReference ) :void
        {
            filesToUpload.push( f );

            var upv:UploadProgressComponent = new UploadProgressComponent();
            UploadProgressComponents.push( upv );
            files_vb.addChild( upv );
            upv.file_lb.text = f.name;
            upv.pb.source = f;

            f.addEventListener( Event.COMPLETE, completeHandler );
            f.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
        }

        /*
         * completeHandler
         *
         * a file upload is complete, remove it from filesToUpload
         * and remove the upload component
         */
        private function completeHandler( event:Event ) :void
        {
            var f:FileReference = FileReference(e.target);
            for( var i:uint; i < filesToUpload.length; i++ )
            {
                if( f.name == filesToUpload[i].name )
                {
                    files_vb.removeChild( UploadProgressComponents[i] );
                    filesToUpload.splice(i, 1);
                    UploadProgressComponents.splice(i, 1);
                }
            }
        }

        /*
         * trace any errors
         */
        private function ioErrorHandler( event:IOErrorEvent ) :void
        {
            trace(“ioErrorHandler: “ + event);
        }

        /*
         * upload!
         */
        private function upload( e:MouseEvent ) :void
        {
            for each (var f:File in filesToUpload)
            {
               f.upload( uploadURL );
            }
        }

	}
}
/*
<mx:WindowedApplication xmlns:mx="http://www.adobe.com/2006/mxml"
    layout="absolute" width="568" height="375">
    <mx:FileSystemDataGrid width="555" height="154" x="6" y="7"
    directory="{File.desktopDirectory.resolvePath('')}" />
    <mx:FileSystemComboBox x="10" y="169"
    directory="{File.desktopDirectory.resolvePath('')}"/>
    <mx:FileSystemTree x="10" y="199" width="291"
    directory="{File.desktopDirectory.resolvePath('')}"/>
    <mx:FileSystemList x="309" y="169"
    directory="{File.desktopDirectory.resolvePath('')}"/>
</mx:WindowedApplication>
*/

/*

*/