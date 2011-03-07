/**
 * @mxmlc -target-player=10.0.22 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.*;
	import flash.ui.Keyboard;
	import flash.system.Security;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
	/**
	 * Fetch the cross domain policy file by using a xml socket.
	 */
	public class FetchPolicyFile extends Sprite
	{
		private const HOST:String = "192.168.1.37";
		private const PORT:int = 5229;
		private const POLICY_REQUEST:String = "<policy-file-request/>\0";
		
		private var _xmlSocket:XMLSocket;
		private var _socket:Socket;
		
		public function FetchPolicyFile()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			Security.loadPolicyFile("xmlsocket://" + HOST + ":" + PORT);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				createXMLSocket();
			}
			else if (event.keyCode == Keyboard.ENTER)
			{
				createSocket();
			}
		}
		
		private function createXMLSocket():void
		{
			_xmlSocket = new XMLSocket();
			_xmlSocket.addEventListener(DataEvent.DATA, onData);
			_xmlSocket.addEventListener(Event.DEACTIVATE, onDeactivate);
			_xmlSocket.addEventListener(Event.CLOSE, onClose);
			_xmlSocket.addEventListener(Event.ACTIVATE, onActive);
			_xmlSocket.addEventListener(Event.CONNECT, onConnect);
			_xmlSocket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_xmlSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_xmlSocket.connect(HOST, PORT);
		}
		
		private function createSocket():void
		{
			_socket = new Socket();
			_socket.addEventListener(DataEvent.DATA, onData);
			_socket.addEventListener(Event.DEACTIVATE, onDeactivate);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(Event.ACTIVATE, onActive);
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.connect(HOST, PORT);
		}
		
		private function onData(event:DataEvent):void
		{
			trace("onData. " + event.toString());
		}
		private function onDeactivate(event:Event):void
		{
			trace("onDeactivate. " + event.toString());
		}
		private function onClose(event:Event):void
		{
			trace("onClose. " + event.toString());
		}
		private function onActive(event:Event):void
		{
			trace("onActive. " + event.toString());
		}
		private function onConnect(event:Event):void
		{
			trace("onConnect. " + event.toString());
			trace("onConnect. target: " + event.target);
			if (event.target is XMLSocket)
			{
				_xmlSocket.send(POLICY_REQUEST);
			}
			else
			{
				_socket.writeUTFBytes(POLICY_REQUEST);
				_socket.flush();
			}
		}
		private function onIOError(event:IOErrorEvent):void
		{
			trace("onIOError. " + event.toString());
		}
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			trace("onSecurityError. " + event.toString());
		}
	}
	
}
