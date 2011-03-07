/**
 * @mxmlc -target-player=10.0.0 -debug
 * 2009-02
 */
package sandbox
{
	import flash.display.*;
	import flash.net.*;
	import flash.media.*;
	import flash.system.*;
	import flash.events.*;
	import flash.utils.ByteArray;

	[SWF( backgroundColor='0x042836',frameRate='33',width='500',height='300' )]

	public class OnTextDataExample extends Sprite
	{

		public function OnTextDataExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			loaderInfo.addEventListener( Event.INIT, onInit );
		}

		private function onInit( event:Event ):void
		{

			var customClient:Object = {};
			customClient.onMetaata = onMetaDataHandler;
			customClient.onImageData = onImageDataHandler;
			customClient.onTextData = onTextDataHandler;
			customClient.onXMPData = onXMPDataHandler;

			var my_nc:NetConnection = new NetConnection();
			my_nc.connect( null );
			var my_ns:NetStream = new NetStream( my_nc );
			my_ns.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
			my_ns.play( "yourURL" );
			my_ns.client = customClient;

			var my_video:Video = new Video();
			my_video.attachNetStream( my_ns );
			addChild( my_video );

		}

		public function onMetaDataHandler( metaData:Object ):void
		{

			trace( "metaData length: " + metaData.data.length );
		}

		public function onImageDataHandler( imageData:Object ):void
		{
			var by:ByteArray = imageData.data as ByteArray;
			trace( "imageData length: " + by.length );

			var imageloader:Loader = new Loader();
			imageloader.loadBytes( by ); // imageData.data is a ByteArray object.
			addChild( imageloader );
		}


		public function onTextDataHandler( textData:Object ):void
		{

			trace( "--- textData properties ----" );
			var key:String;

			for ( key in textData )
			{
				trace( key + ": " + textData[ key ] );
			}
		}

		/**
		 * The object passed to the onXMPData() event handling function has one data property,
		 * which is a string. The string is generated from a top-level UUID box.
		 * (The 128-bit UUID of the top level box is BE7ACFCB-97A9-42E8-9C71-999491E3AFAC  .)
		 * This top-level UUID box contains exactly one XML document represented as a null-terminated UTF-8 string.
		 * @param	xmpData
		 */
		public function onXMPDataHandler( xmpData:Object ):void
		{
			var uuid:String = xmpData.data as String;
		}

		/**
		 * All netStatus event options available in Flash player 10, 28/01/2009.
		 * @param	event
		 */
		private function onNetStatus( event:NetStatusEvent ):void
		{
			switch ( event.info )
			{
				case 'NetStream.Buffer.Empty':
					/**
					 * Data is not being received quickly enough to fill the buffer.
					 * Data flow will be interrupted until the buffer refills,
					 * at which time a NetStream.Buffer.Full message will be sent
					 * and the stream will begin playing again.
					 */
					break;
				case 'NetStream.Buffer.Full':
					/**
					 * The buffer is full and the stream will begin playing.
					 */
					break;
				case 'NetStream.Buffer.Flush':
					/**
					 * Data has finished streaming, and the remaining buffer will be emptied.
					 */
					break;
				case 'NetStream.Failed':
					/**
					 * Flash Media Server only.
					 * An error has occurred for a reason other than those listed in other event codes.
					 */
					break;
				case 'NetStream.Publish.Start':
					/**
					 * Publish was successful.
					 */
					break;
				case 'NetStream.Publish.BadName':
					/**
					 * Attempt to publish a stream which is already being published by someone else.
					 */
					break;
				case 'NetStream.Publish.Idle':
					/**
					 * The publisher of the stream is idle and not transmitting data.
					 */
					break;
				case 'NetStream.Unpublish.Success':
					/**
					 * The unpublish operation was successfuul.
					 */
					break;
				case 'NetStream.Play.Start':
					/**
					 * Playback has started.
					 */
					break;
				case 'NetStream.Play.Stop':
					/**
					 * Playback has stopped.
					 */
					break;
				case 'NetStream.Play.Failed':
					/**
					 * An error has occurred in playback for a reason other
					 * than those listed elsewhere in this table,
					 * such as the subscriber not having read access.
					 */
					break;
				case 'NetStream.Play.StreamNotFound':
					/**
					 * The FLV passed to the play() method can't be found.
					 */
					break;
				case 'NetStream.Play.Reset':
					/**
					 * Caused by a play list reset.
					 */
					break;
				case 'NetStream.Play.PublishNotify':
					/**
					 * The initial publish to a stream is sent to all subscribers.
					 */
					break;
				case 'NetStream.Play.UnpublishNotify':
					/**
					 * An unpublish from a stream is sent to all subscribers.
					 */
					break;
				case 'NetStream.Play.InsufficientBW':
					/**
					 * Flash Media Server only. The client does not have
					 * sufficient bandwidth to play the data at normal speed.
					 */
					break;
				case 'NetStream.Play.FileStructureInvalid':
					/**
					 * The application detects an invalid file structure
					 * and will not try to play this type of file.
					 * For AIR and for Flash Player 9.0.115.0 and later.
					 */
					break;
				case 'NetStream.Play.NoSupportedTrackFound':
					/**
					 * The application does not detect any supported tracks
					 * (video, audio or data) and will not try to play the file.
					 * For AIR and for Flash Player 9.0.115.0 and later.
					 */
					break;
				case 'NetStream.Play.Transition':
					/**
					 * Flash Media Server only. The stream transitions to another as a
					 * result of bitrate stream switching. This code indicates a success
					 * status event for the NetStream.play2() call to initiate a stream switch.
					 * If the switch does not succeed, the server sends a NetStream.Play.Failed
					 * event instead. For Flash Player 10 and later.
					 */
					break;
				case 'NetStream.Play.Transition':
					/**
					 * Flash Media Server 3.5 and later only. The server received the
					 * command to transition to another stream as a result of bitrate
					 * stream switching. This code indicates a success status event for
					 * the NetStream.play2() call to initiate a stream switch.
					 * If the switch does not succeed, the server sends a NetStream.Play.Failed event
					 * instead. When the stream switch occurs, an onPlayStatus event with a
					 * code of 'NetStream.Play.TransitionComplete' is dispatched.
					 * For Flash Player 10 and later.
					 */
					break;
				case 'NetStream.Pause.Notify':
					/**
					 * The stream is paused.
					 */
					break;
				case 'NetStream.Unpause.Notify':
					/**
					 * The stream is resumed.
					 */
					break;
				case 'NetStream.Record.Start':
					/**
					 * Recording has started.
					 */
					break;
				case 'NetStream.Record.NoAccess':
					/**
					 * Attempt to record a stream that is still playing or the client has no access right.
					 */
					break;
				case 'NetStream.Record.Stop':
					/**
					 * Recording stopped.
					 */
					break;
				case 'NetStream.Record.Failed':
					/**
					 * An attempt to record a stream failed.
					 */
					break;
				case 'NetStream.Seek.Failed':
					/**
					 * The seek fails, which happens if the stream is not seekable.
					 */
					break;
				case 'NetStream.Seek.InvalidTime':
					/**
					 * For video downloaded with progressive download, the user has tried to
					 * seek or play past the end of the video data that has downloaded thus far,
					 * or past the end of the video once the entire file has downloaded.
					 * The message.details property contains a time code that indicates the last valid
					 * position to which the user can seek.
					 */
					break;
				case 'NetStream.Seek.Notify':
					/**
					 * The seek operation is complete.
					 */
					break;
				case 'NetConnection.Call.BadVersion':
					/**
					 * Packet encoded in an unidentified format.
					 */
					break;
				case 'NetConnection.Call.Failed':
					/**
					 * The NetConnection.call method was not able to invoke the server-side method or command.
					 */
					break;
				case 'NetConnection.Call.Prohibited':
					/**
					 * An Action Message Format (AMF) operation is prevented for security reasons.
					 * Either the AMF URL is not in the same domain as the file containing the
					 * code calling the NetConnection.call() method, or the AMF server does not
					 * have a policy file that trusts the domain of the the file containing the
					 * code calling the NetConnection.call() method.
					 */
					break;
				case 'NetConnection.Connect.Closed':
					/**
					 * The connection was closed successfully.
					 */
					break;
				case 'NetConnection.Connect.Failed':
					/**
					 * The connection attempt failed.
					 */
					break;
				case 'NetConnection.Connect.Success':
					/**
					 * The connection attempt succeeded.
					 */
					break;
				case 'NetConnection.Connect.Rejected':
					/**
					 * The connection attempt did not have permission to access the application.
					 */
					break;
				case 'NetStream.Connect.Closed':
					/**
					 * The P2P connection was closed successfully. The info.stream property
					 * indicates which stream has closed.
					 */
					break;
				case 'NetStream.Connect.Failed':
					/**
					 * The P2P connection attempt failed. The info.stream property indicates which
					 * stream has failed.
					 */
					break;
				case 'NetStream.Connect.Success':
					/**
					 * The P2P connection attempt succeeded. The info.stream property indicates
					 * which stream has succeeded.
					 */
					break;
				case 'NetStream.Connect.Rejected':
					/**
					 * The P2P connection attempt did not have permission to access the other peer.
					 * The info.stream property indicates which stream was rejected.
					 */
					break;
				case 'NetConnection.Connect.AppShutdown':
					/**
					 * The specified application is shutting down.
					 */
					break;
				case 'NetConnection.Connect.InvalidApp':
					/**
					 * The application name specified during connect is invalid.
					 */
					break;
				case 'SharedObject.Flush.Success':
					/**
					 * The 'pending' status is resolved and the SharedObject.flush() call succeeded.
					 */
					break;
				case 'SharedObject.Flush.Failed':
					/**
					 * The 'pending' status is resolved, but the SharedObject.flush() failed.
					 */
					break;

				case 'SharedObject.BadPersistence':
					/**
					 * A request was made for a shared object with persistence flags, but the request
					 * cannot be granted because the object has already been created with different flags.
					 */
					break;
				case 'SharedObject.UriMismatch':
					/**
					 * An attempt was made to connect to a NetConnection object that has a different
					 * URI (URL) than the shared object.
					 */
					break;
				default:
					break;
			}
		}

	}
}
