/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.system.*;
	
	
	import flash.text.TextField;
	import mx.charts.chartClasses.StackedSeries;
	import mx.formatters.DateFormatter;
	import flash.sampler.Sample;
	import mx.events.SliderEvent;
	import mx.events.FlexEvent;
	import mx.collections.ArrayCollection;
	import mx.events.ItemClickEvent;

	
	/**
	 * Testing the Stratus which appeared in FP10.
	 * @see http://labs.adobe.com/technologies/stratus/
	 */
	public class StratusOne extends Sprite
	{
		private const ABODE_STRATUS_URL:String = "rtmfp://stratus.adobe.com";
		private const DEVELOPER_KEY:String = "29ac284388efebc8dabbb169-a980ba86b9f5";
		
		
		private var _connection:NetConnection;
		
		
		// please insert your webservice URL here for exchanging
		private const WebServiceUrl:String = "your webservice URL";

		
		// after connection to stratus, publish listener stream to wait for incoming call
		private var _streamListen:NetStream;
		
		// caller's incoming stream that is connected to callee's listener stream
		private var _streamControl:NetStream;
		
		// outgoing media stream (audio, video, text and some control messages)
		private var _streamOut:NetStream;
		
		// incoming media stream (audio, video, text and some control messages)
		private var _streamIn:NetStream;
		
		// ID management serice
		private var idManager:AbstractIdManager;

		private var remoteVideo:Video;
		
		// login/registration state machine
		[Bindable] private var loginState:int;
		
		private const LoginNotConnected:int = 0;
		private const LoginConnecting:int = 1;
		private const LoginConnected:int = 2;
		private const LoginDisconnecting:int = 3;
		
		// call state machine
		[Bindable]
		private var callState:int;
		
		private const CallNotReady:int = 0;
		private const CallReady:int = 1;
		private const CallCalling:int = 2;
		private const CallRinging:int = 3;
		private const CallEstablished:int = 4;
		private const CallFailed:int = 5;
			
		// available microphone devices
		[Bindable]
		private var micNames:Array;
		private var micIndex:int = 0;
		
		// available camera deviced
		[Bindable]
		private var cameraNames:Array;
		private var cameraIndex:int = 0;
		
		private var activityTimer:Timer;
		
		// user name is saved in local shared object
		private var localSO:SharedObject;
				
		[Bindable] private var remoteName:String = "";
		
		private var callTimer:int;
		
		// charts
		private var audioRate:Array = new Array(30);
		[Bindable]
		private var audioRateDisplay:ArrayCollection = new ArrayCollection();
		private var videoRate:Array = new Array(30);
		[Bindable]
		private var videoRateDisplay:ArrayCollection = new ArrayCollection();
		private var srtt:Array = new Array(30);
		[Bindable]
		private var srttDisplay:ArrayCollection = new ArrayCollection();
		
		private const defaultMacCamera:String = "USB Video Class Video";
		
		// Display objects
		private var userNameInput:TextField;
					
		// called when application is loaded
		public function StratusOne()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			status("Player: " + Capabilities.version + "\n");
			
			loginState = LoginNotConnected;
			callState = CallNotReady;
			
			localSO = SharedObject.getLocal("videoPhoneSettings");
			if (localSO.data.hasOwnProperty("user"))
			{
				userNameInput.text = localSO.data.user;
			}
							
			var mics:Array = Microphone.names;
			if (mics)
			{
				micNames = mics;
			}
			else
			{
				status("No microphone available.\n");
			}
				
			var cameras:Array = Camera.names;
			if (cameras)
			{
				cameraNames = cameras;
			}
			else
			{
				status("No camera available.\n");
			}
		
			// statistics timer
			activityTimer = new Timer(1000);
			activityTimer.addEventListener(TimerEvent.TIMER, onActivityTimer);
			activityTimer.start();
					
			// selected mic device
			micIndex = 0;
			if (localSO.data.hasOwnProperty("micIndex"))
			{
				micIndex = localSO.data.micIndex;
			}
				
			micSelection.selectedIndex = micIndex;
			
			// set Mac default camera
			if (Capabilities.os.search("Mac") != -1)
			{
				for (cameraIndex = 0; cameraIndex < cameras.length; cameraIndex++)
				{
					if (cameras[cameraIndex] == defaultMacCamera)
					{
						break;
					}
				}
			}
					
			// selected camera device
			if (localSO.data.hasOwnProperty("cameraIndex"))
			{
				cameraIndex = localSO.data.cameraIndex;
			}
			
			cameraSelection.selectedIndex = cameraIndex;
			
			// mic volume
			var micVolume:int = 50;
			if (localSO.data.hasOwnProperty("micVolume"))
			{
				micVolume = localSO.data.micVolume;
			}
			
			micVolumeSlider.value = micVolume;
			
			// speaker volume
			var speakerVolume:Number = 0.8;
			if (localSO.data.hasOwnProperty("speakerVolume"))
			{
				speakerVolume = localSO.data.speakerVolume;
			}
			
			speakerVolumeSlider.value = speakerVolume;
			
			// configure audio and video
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			if (mic)
			{
				mic.codec = SoundCodec.SPEEX;
				mic.setSilenceLevel(0);
				mic.framesPerPacket = 1;
				mic.gain = micVolume;
					
				mic.addEventListener(StatusEvent.STATUS, onDeviceStatus);
				mic.addEventListener(ActivityEvent.ACTIVITY, onDeviceActivity);
			}
			
			var camera:Camera = Camera.getCamera(cameraIndex.toString());
			if (camera)
			{
				camera.addEventListener(StatusEvent.STATUS, onDeviceStatus);
				camera.addEventListener(ActivityEvent.ACTIVITY, onDeviceActivity);
				camera.setMode(320, 240, 15);
				camera.setQuality(0, 80);
			}
		}
				
		private function status(msg:String):void
		{
			trace("ScriptDebug: " + msg);
		}
		
		// user clicked connect
		private function onConnect():void
		{
			localSO.data.user = userNameInput.text;
			localSO.flush();
			
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
			_connection.connect(ABODE_STRATUS_URL + "/" + DEVELOPER_KEY);
			
			loginState = LoginConnecting;
			
			status("Connecting to " + ABODE_STRATUS_URL + "\n");
		}
		
		private function netConnectionHandler(event:NetStatusEvent):void
		{
			status("NetConnection event: " + event.info.code + "\n");
			
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					connectSuccess();
					break;
					
				case "NetConnection.Connect.Closed":
					loginState = LoginNotConnected;
					callState = CallNotReady;
					break;
					
				case "NetStream.Connect.Success":
					// we get this when other party connects to our control stream our outgoing stream
					status("Connection from: " + event.info.stream.farID + "\n");
					break;
					
				case "NetConnection.Connect.Failed":
					status("Unable to connect to " + ABODE_STRATUS_URL + "\n");
					loginState = LoginNotConnected;
					break;
					
				case "NetStream.Connect.Closed":
					onHangup();
					break;
			}
		}
		
		private function listenerHandler(event:NetStatusEvent):void
		{
			status("Listener event: " + event.info.code + "\n");
		}
		
		private function controlHandler(event:NetStatusEvent):void
		{
			status("Control event: " + event.info.code + "\n");
		}
		
		private function outgoingStreamHandler(event:NetStatusEvent):void
		{
			status("Outgoing stream event: " + event.info.code + "\n");
			switch (event.info.code)
			{
				case "NetStream.Play.Start":
					if (callState == CallCalling)
					{
						_streamOut.send("onIncomingCall", "apina");
					}
					break;
			}
		}
			
		private function incomingStreamHandler(event:NetStatusEvent):void
		{
			status("Incoming stream event: " + event.info.code + "\n");
			switch (event.info.code)
			{
				case "NetStream.Play.UnpublishNotify":
					onHangup();
					break;
			}
		}
		
		// connection to stratus succeeded and we register our fingerprint with a simple web service
		// other clients use the web service to look up our fingerprint
		private function connectSuccess():void
		{
			status("Connected, my ID: " + _connection.nearID + "\n");
			
			idManager = new HttpIdManager();
			idManager.addEventListener("registerSuccess", idManagerEvent);
			idManager.addEventListener("registerFailure", idManagerEvent);
			idManager.addEventListener("lookupFailure", idManagerEvent);
			idManager.addEventListener("lookupSuccess", idManagerEvent);
			idManager.addEventListener("idManagerError", idManagerEvent);
			
			idManager.service = WebServiceUrl;
			idManager.register(userNameInput.text, _connection.nearID);
		}
		
		private function completeRegistration():void
		{
			// start the control stream that will listen to incoming calls
			_streamListen = new NetStream(_connection, NetStream.DIRECT_CONNECTIONS);
			_streamListen.addEventListener(NetStatusEvent.NET_STATUS, listenerHandler);
			_streamListen.publish("control" + userNameInput.text);
						
			var c:Object = new Object
			c.onPeerConnect = function(caller:NetStream):Boolean
			{
				status("Caller connecting to listener stream: " + caller.farID + "\n");
							
				if (callState == CallReady)
				{
					callState = CallRinging;
								
					// callee subscribes to media, to be able to get the remote user name
					_streamIn = new NetStream(_connection, caller.farID);
					_streamIn.addEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
					_streamIn.play("media-caller");
					
					// set volume for incoming stream
					var st:SoundTransform = new SoundTransform(speakerVolumeSlider.value);
					_streamIn.soundTransform = st;
								
					_streamIn.receiveAudio(false);
					_streamIn.receiveVideo(false);
								
					var i:Object = new Object;
					i.onIncomingCall = function(caller:String):void
					{
						if (callState != CallRinging)
						{
							status("onIncomingCall: Wrong call state: " + callState + "\n");
							return;
						}
						remoteName = caller;
								
						status("Incoming call from: " + caller + "\n");
					}
					
					i.onIm = function(name:String, text:String):void
					{
						textOutput.text += name + ": " + text + "\n";
						textOutput.validateNow();
						textOutput.verticalScrollPosition = textOutput.textHeight;
					}
					_streamIn.client = i;
								
					return true;
				}
					
				status("onPeerConnect: all rejected due to state: " + callState + "\n");
	
				return false;
			}
						
			_streamListen.client = c;
						
			callState = CallReady;
		}
		
		private function placeCall(user:String, identity:String):void
		{
			status("Calling " + user + ", id: " + identity + "\n");
						
			if (identity.length != 64)
			{
				status("Invalid remote ID, call failed\n");
				callState = CallFailed;
				return;
			}
						
			// caller subsrcibes to callee's listener stream
			_streamControl = new NetStream(_connection, identity);
			_streamControl.addEventListener(NetStatusEvent.NET_STATUS, controlHandler);
			_streamControl.play("control" + user);
						
			// caller publishes media stream
			_streamOut = new NetStream(_connection, NetStream.DIRECT_CONNECTIONS);
			_streamOut.addEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
			_streamOut.publish("media-caller");
						
			var o:Object = new Object
			o.onPeerConnect = function(caller:NetStream):Boolean
			{
				status("Callee connecting to media stream: " + caller.farID + "\n");
										
				return true;
			}
			_streamOut.client = o;

			startAudio();
			startVideo();
													
			// caller subscribes to callee's media stream
			_streamIn = new NetStream(_connection, identity);
			_streamIn.addEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
			_streamIn.play("media-callee");
			
			// set volume for incoming stream
			var st:SoundTransform = new SoundTransform(speakerVolumeSlider.value);
			_streamIn.soundTransform = st;
						
			var i:Object = new Object;
			i.onCallAccepted = function(callee:String):void
			{
				if (callState != CallCalling)
				{
					status("onCallAccepted: Wrong call state: " + callState + "\n");
					return;
				}
							
				callState = CallEstablished;
													
				status("Call accepted by " + callee + "\n");
			}
			i.onIm = function(name:String, text:String):void
			{
				textOutput.text += name + ": " + text + "\n";
			}
			_streamIn.client = i;
							
			remoteVideo = new Video();
			remoteVideo.width = 320;
			remoteVideo.height = 240;
			remoteVideo.attachNetStream(_streamIn);
			remoteVideoDisplay.addChild(remoteVideo);
						
			remoteName = user;
			callState = CallCalling;
		}
				
		// process successful response from web service
		private function idManagerEvent(event:Event):void
		{
			status("ID event: " + e.type + "\n");
			
			if (e.type == "registerSuccess")
			{
				switch (loginState)
				{
					case LoginConnecting:
						loginState = LoginConnected;
						break;
					case LoginDisconnecting:
					case LoginNotConnected:
						loginState = LoginNotConnected;
						return;
					case LoginConnected:
						return;
				}
						
				completeRegistration();
			}
			else if (e.type == "lookupSuccess")
			{
				// party query response
				var i:IdManagerEvent = e as IdManagerEvent;
				
				placeCall(i.user, i.id);
			}
			else
			{
				// all error messages ar IdManagerError type
				var error:IdManagerError = e as IdManagerError;
				status("Error description: " + error.description + "\n")
				
				onDisconnect();
			}
		}
		
		// user clicked accept button
		private function acceptCall():void
		{
			_streamIn.receiveAudio(true);
			_streamIn.receiveVideo(true);
			
			remoteVideo = new Video();
			remoteVideo.width = 320;
			remoteVideo.height = 240;
			remoteVideo.attachNetStream(_streamIn);
			remoteVideoDisplay.addChild(remoteVideo);
							
			// callee publishes media
			_streamOut = new NetStream(_connection, NetStream.DIRECT_CONNECTIONS);
			_streamOut.addEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
			_streamOut.publish("media-callee");
			
			var o:Object = new Object
			o.onPeerConnect = function(caller:NetStream):Boolean
			{
				status("Caller connecting to media stream: " + caller.farID + "\n");
												
				return true;
			}
			_streamOut.client = o;
			
			_streamOut.send("onCallAccepted", userNameInput.text);
			
			startVideo();
			startAudio();
								
			callState = CallEstablished;
		}
		
		private function cancelCall():void
		{
			onHangup();
		}
		
		private function rejectCall():void
		{
			onHangup();
		}
					
		private function onDisconnect():void
		{
			status("Disconnecting.\n");
			
			onHangup();
			
			callState = CallNotReady;
			
			if (idManager)
			{
				idManager.unregister();
				idManager = null;
			}
			
			loginState = LoginNotConnected;
			
			_connection.close();
			_connection = null;
		}
	
		// placing a call
		private function onCall():void
		{
			if (_connection && _connection.connected)
			{
				if (calleeInput.text.length == 0)
				{
					status("Please enter name to call\n");
					return;
				}
				
				// first, we need to lookup callee's fingerprint using the web service
				if (idManager)
				{
					idManager.lookup(calleeInput.text);
				}
				else
				{
					status("Not registered.\n");
					return;
				}
			}
			else
			{
				status("Not connected.\n");
			}
		}
		
		private function startAudio():void
		{
			if (sendAudioCheckbox.selected)
			{
				var mic:Microphone = Microphone.getMicrophone(micIndex);
				if (mic && _streamOut)
				{
					_streamOut.attachAudio(mic);
				}
			}
			else
			{
				if (_streamOut)
				{
					_streamOut.attachAudio(null);
				}
			}
		}
		
		private function startVideo():void
		{
			if (sendVideoCheckbox.selected)
			{
				var camera:Camera = Camera.getCamera(cameraIndex.toString());
				if (camera)
				{
					localVideoDisplay.attachCamera(camera);
					if (_streamOut)
					{
						_streamOut.attachCamera(camera);
					}
				}
			}
			else
			{
				localVideoDisplay.attachCamera(null);
				if (_streamOut)
				{
					_streamOut.attachCamera(null);
				}
			}
		}
					
		// this function is called in every second to update charts, microhone level, and call timer
		private function onActivityTimer(e:TimerEvent):void
		{
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			micActivityLabel.text = mic.activityLevel.toString();
			
			if (callState == CallEstablished && _streamIn && _streamOut && _streamOut.peerStreams.length == 1)
			{
				var recvInfo:NetStreamInfo = _streamIn.info;
				var sentInfo:NetStreamInfo = _streamOut.peerStreams[0].info;
				
				audioRate.shift();
				var a:Object = new Object;
				a.Recv = recvInfo.audioBytesPerSecond * 8 / 1024;
				a.Sent = sentInfo.audioBytesPerSecond * 8 / 1024;
				audioRate.push(a);
				audioRateDisplay.source = audioRate;
				
				videoRate.shift();
				var v:Object = new Object;
				v.Recv = recvInfo.videoBytesPerSecond * 8 / 1024;
				v.Sent = sentInfo.videoBytesPerSecond * 8 / 1024;
				videoRate.push(v);
				videoRateDisplay.source = videoRate;
				
				srtt.shift();
				var s:Object = new Object;
				s.Data = recvInfo.SRTT;
				srtt.push(s);
				srttDisplay.source = srtt;
			}

			if (callState == CallEstablished)
			{
				callTimer++;
				var elapsed:Date = new Date(2008, 4, 12);
				elapsed.setTime(elapsed.getTime() + callTimer * 1000);
				var formatter:DateFormatter = new DateFormatter();
				var format:String = "JJ:NN:SS";
				if (callTimer < 60)
				{
					format = "SS";
				}
				else if (callTimer < 60 * 60)
				{
					format = "NN:SS";
				}
				formatter.formatString = format
				callTimerText.text = formatter.format(elapsed);
			}
		}
		
		private function onDeviceStatus(e:StatusEvent):void
		{
			status("Device status: " + e.code + "\n");
		}
		
		private function onDeviceActivity(e:ActivityEvent):void
		{
//				status("Device activity: " + e.activating + "\n");
		}
				
		private function onHangup():void
		{
			status("Hanging up call\n");
			
			calleeInput.text = "";
			callState = CallReady;
			
			if (_streamIn)
			{
				_streamIn.close();
				_streamIn.removeEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
			}
			
			if (_streamOut)
			{
				_streamOut.close();
				_streamOut.removeEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
			}
			
			if (_streamControl)
			{
				_streamControl.close();
				_streamControl.removeEventListener(NetStatusEvent.NET_STATUS, controlHandler);
			}
			
			_streamIn = null;
			_streamOut = null;
			_streamControl = null;
			
			remoteName = "";
			
			receiveAudioCheckbox.selected = true;
			receiveVideoCheckbox.selected = true;
			
			callTimer = 0;
		}
		
		private function speakerVolumeChanged(e:SliderEvent):void
		{
			if (_streamIn)
			{
				var st:SoundTransform = new SoundTransform(e.value);
				_streamIn.soundTransform = st;
				
				status("Setting speaker volume to: " + e.value + "\n");
			}
			
			localSO.data.speakerVolume = e.value;
			localSO.flush();
		}
		
		private function micVolumeChanged(e:SliderEvent):void
		{
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			if (mic)
			{
				mic.gain = e.value;
				
				localSO.data.micVolume = e.value;
				localSO.flush();
				
				status("Setting mic volume to: " + e.value + "\n");
			}
		}
		
		// sending text message
		private function onSend():void
		{
			var msg:String = textInput.text;
			if (msg.length != 0 && _streamOut)
			{
				textOutput.text += userNameInput.text + ": " + msg + "\n";
				_streamOut.send("onIm", userNameInput.text, msg);
				textInput.text = "";
			}
		}
		
		private function micChanged(event:Event):void
		{
			var oldMicIndex:int = micIndex;
			micIndex = micSelection.selectedIndex;
			
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			var oldMic:Microphone = Microphone.getMicrophone(oldMicIndex);
				
			mic.codec = oldMic.codec;
			mic.rate = oldMic.rate;
			mic.encodeQuality = oldMic.encodeQuality;
			mic.framesPerPacket = oldMic.framesPerPacket;
			mic.gain = oldMic.gain;
			mic.setSilenceLevel(oldMic.silenceLevel);
			
			if (callState == CallEstablished)
			{
				_streamOut.attachAudio(mic);
			}
			
			localSO.data.micIndex = micIndex;
			localSO.flush();
		}
					
		private function cameraChanged(event:Event):void
		{
			var oldCameraIndex:int = cameraIndex;
			cameraIndex = cameraSelection.selectedIndex;
			
			var camera:Camera = Camera.getCamera(cameraIndex.toString());
			var oldCamera:Camera = Camera.getCamera(oldCameraIndex.toString());
			
			camera.setMode(320, 240, 15);
			camera.setQuality(0, oldCamera.quality);
			
			// when user changes video device, we want to show preview
			localVideoDisplay.attachCamera(camera);
				
			if (callState == CallEstablished)
			{
				_streamOut.attachCamera(camera);
			}
			
			localSO.data.cameraIndex = cameraIndex;
			localSO.flush();
		}
		
		private function videoQualityChanged(e:SliderEvent):void
		{
			var camera:Camera = Camera.getCamera(cameraIndex.toString());
			if (camera)
			{
				camera.setQuality(0, e.value);
				status("Setting camera quality to: " + e.value + "\n");
			}
		}
		
		private function onAudioMuted():void
		{
			if (_streamIn)
			{
				_streamIn.receiveAudio(receiveAudioCheckbox.selected);
			}
		}
		
		private function onVideoPaused():void
		{
			if (_streamIn)
			{
				_streamIn.receiveVideo(receiveVideoCheckbox.selected);
			}
		}
		
		private function handleCodecChange(event:ItemClickEvent):void
		{
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			if (mic)
			{
				if (event.currentTarget.selectedValue == "speex")
				{
					codecPropertyStack.selectedChild = speexCanvas;
					mic.codec = SoundCodec.SPEEX;
					mic.framesPerPacket = 1;
					mic.encodeQuality = int(speexQualitySelector.selectedItem);
					mic.setSilenceLevel(0);
				}
				else
				{
					codecPropertyStack.selectedChild = nellymoserCanvas;
					
					mic.codec = SoundCodec.NELLYMOSER;
					mic.rate =  int(nellymoserRateSelector.selectedItem);
					mic.setSilenceLevel(10);
				}
			}
		}
		
		private function speexQuality(event:Event):void
		{
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			if (mic)
			{
				var quality:int = int(ComboBox(e.target).selectedItem);
				mic.encodeQuality = quality;
			
				status("Setting speex quality to: " + quality);
			}
		}
		
		private function nellymoserRate(event:Event):void
		{
			var mic:Microphone = Microphone.getMicrophone(micIndex);
			if (mic)
			{
				var rate:int = int(ComboBox(e.target).selectedItem);
				mic.rate = rate;
				
				status("Setting Nellymoser rate to: " + rate);
			}
		}
	}
}
/*
		]]>
	</mx:Script>
	<mx:Style>
		.buttonStyle {
			color: "0xFFFFFF";
			textRollOverColor: "0xFFFFFF";
			textSelectedColor: "0xFFFFFF";
		}
	</mx:Style>
	<mx:VBox>
		<mx:ViewStack selectedIndex="{loginState}" resizeToContent="true">
			<mx:HBox>
				<mx:Label text="User Name: " color="0xffffff"/>
				<mx:TextInput id="userNameInput" width="80" />
				<mx:Button label="CONNECT" click="onConnect()" enabled="{userNameInput.text.length > 0}" styleName="buttonStyle"/>
			</mx:HBox>
			<mx:HBox>
				<mx:Label text="Connecting to {ABODE_STRATUS_URL}" color="0xffffff"/>
				<mx:Button label="CANCEL" click="onDisconnect()" styleName="buttonStyle"/>
			</mx:HBox>
			<mx:HBox>
				<mx:Label text="Connected as {userNameInput.text}" color="0xffffff"/>
				<mx:Button label="DISCONNECT" click="onDisconnect()" styleName="buttonStyle"/>
			</mx:HBox>
			<mx:Canvas>
				<mx:Label text="Disconnecting from {ABODE_STRATUS_URL}" color="0xffffff"/>
			</mx:Canvas>
		</mx:ViewStack>
		<mx:ViewStack selectedIndex="{callState}" resizeToContent="true" creationPolicy="all" >
			<mx:Canvas>
				<mx:Label text="Please enter user name and connect" color="0xffffff"/>
			</mx:Canvas>
			<mx:HBox>
				<mx:TextInput id="calleeInput" enter="onCall()"/>
				<mx:Button label="CALL" click="onCall()" styleName="buttonStyle"/>
			</mx:HBox>
			<mx:HBox>
				<mx:Label text="Calling {remoteName}" color="0xffffff"/>
				<mx:Button label="CANCEL" click="cancelCall()" styleName="buttonStyle"/>
			</mx:HBox>
			<mx:HBox>
				<mx:Label text="Incoming call from: {remoteName}" color="0xffffff"/>
				<mx:Button label="ACCEPT" click="acceptCall()" styleName="buttonStyle"/>
				<mx:Button label="REJECT" click="rejectCall()" styleName="buttonStyle"/>
			</mx:HBox>
			<mx:HBox>
				<mx:Label text="Call in progress with {remoteName}" color="0xffffff"/>
				<mx:Button label="HANGUP" click="onHangup()" styleName="buttonStyle"/>
				<mx:Label id="callTimerText" color="0xffffff"/>
			</mx:HBox>
			<mx:HBox>
				<mx:Label text="Call failed to {calleeInput.text}" color="0xffffff"/>
				<mx:Button label="HANGUP" click="onHangup()" styleName="buttonStyle"/>
			</mx:HBox>
		</mx:ViewStack>
		<mx:HBox>
			<mx:VideoDisplay id="remoteVideoDisplay" width="320" height="240" />
			<mx:VBox>
				<mx:VideoDisplay id="localVideoDisplay" width="120" height="90" />
	            <mx:HBox>
	            	<mx:Label text="Microphone: " color="0xffffff"/>
	            	<mx:Label id="micActivityLabel" color="0xffffff"/>
	            </mx:HBox>
				<mx:HSlider id="micVolumeSlider" showDataTip="false" width="120" minimum="0" maximum="100" change="micVolumeChanged(event)"/>
				<mx:Label text="Speaker" color="0xffffff"/>
				<mx:HSlider id="speakerVolumeSlider" showDataTip="false" width="120" minimum="0" maximum="1" change="speakerVolumeChanged(event)"/>
				<mx:Label text="Receive:" color="0xffffff"/>
				<mx:HBox>
					<mx:CheckBox id="receiveAudioCheckbox" label="Audio" click="onAudioMuted()" enabled="{callState == CallEstablished}" selected="true" styleName="buttonStyle"/>
					<mx:CheckBox id="receiveVideoCheckbox" label="Video" click="onVideoPaused()" enabled="{callState == CallEstablished}" selected="true" styleName="buttonStyle"/>
				</mx:HBox>
			</mx:VBox>
		</mx:HBox>
		<mx:TextArea id="textOutput" width="450" height="100" editable="false" verticalScrollPolicy="auto" />
		<mx:HBox>
			<mx:TextInput id="textInput" width="390" />
			<mx:Button label="SEND" click="onSend()" styleName="buttonStyle" enabled="{textInput.text.length > 0 &amp;&amp; callState == CallEstablished}"/>
		</mx:HBox>
		<mx:TabBar dataProvider="{optionsStack}" width="452" styleName="buttonStyle"/>
		<mx:ViewStack id="optionsStack" borderStyle="solid" creationPolicy="all" >
			<mx:VBox label="STATUS" >
				<mx:TextArea id="statusArea" width="450" height="120" editable="false" verticalScrollPolicy="auto" />
				<mx:Button label="Clear" click="statusArea.text=''" />
			</mx:VBox>
			<mx:VBox label="DEVICES" enabled="{loginState == LoginConnected}" paddingTop="5" paddingLeft="5">
				<mx:HBox>
					<mx:Label text="Audio capture: " color="0xffffff"/>
					<mx:ComboBox id="micSelection" dataProvider="{micNames}" change="micChanged(event)" />
				</mx:HBox>
				<mx:HBox>
					<mx:Label text="Video capture: " color="0xffffff"/>
					<mx:ComboBox id="cameraSelection" dataProvider="{cameraNames}" change="cameraChanged(event)" />
				</mx:HBox>
			</mx:VBox>
			<mx:HBox label="AUDIO/VIDEO" enabled="{loginState == LoginConnected}">
				<mx:Panel borderStyle="solid" title="Audio Codec" width="220" height="120" backgroundColor="0xA0A0A0">
					<mx:HBox>
						<mx:RadioButtonGroup id="codecGroup" itemClick="handleCodecChange(event)"/>
   						<mx:RadioButton groupName="codecGroup" value="speex" label="Speex" selected="true" />
   						<mx:RadioButton groupName="codecGroup" value="nellymoser" label="Nellymoser" />
   					</mx:HBox>
   					<mx:ViewStack id="codecPropertyStack" resizeToContent="true" >
   						<mx:Canvas id="speexCanvas">
   							<mx:HBox>
   								<mx:Label text="Encode quality: " />
   								<mx:ComboBox id="speexQualitySelector" dataProvider="{[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}" selectedIndex="6" change="speexQuality(event)" />
   							</mx:HBox>
   						</mx:Canvas>
   						<mx:Canvas id="nellymoserCanvas">
   							<mx:HBox>
   								<mx:Label text="Encode rate [kHz]: " />
   								<mx:ComboBox id="nellymoserRateSelector" dataProvider="{[5, 8, 11, 16, 22, 44]}" selectedIndex="1" change="nellymoserRate(event)" />
   							</mx:HBox>
   						</mx:Canvas>
   					</mx:ViewStack>
   					<mx:CheckBox id="sendAudioCheckbox" label="Send Audio" click="startAudio()" selected="true" />
   				</mx:Panel >
   				<mx:Panel borderStyle="solid" title="Video Quality"  width="220" height="120" backgroundColor="0xA0A0A0">
            		<mx:HSlider showDataTip="false" tickInterval="25" labels="[0, 25, 50, 75, 100]" minimum="1" maximum="100" value="80" change="videoQualityChanged(event)"/>
            		<mx:CheckBox id="sendVideoCheckbox" label="Send Video" click="startVideo()" selected="true" />
            	</mx:Panel>
			</mx:HBox>
			<mx:VBox label="STATISTICS" enabled="{loginState == LoginConnected}">
				<mx:LineChart id="audioRateChart" dataProvider="{audioRateDisplay}" height="105" color="0xffffff">
					<mx:series>
 						<mx:LineSeries yField="Recv" displayName="Received Audio Rate [kbps]"/>
 						<mx:LineSeries yField="Sent" displayName="Sent Audio Rate [kbps]" />
       				</mx:series>
        		</mx:LineChart>
        		<mx:Legend dataProvider="{audioRateChart}" direction="horizontal" color="0xffffff"/>
           		<mx:LineChart id="videoRateChart" dataProvider="{videoRateDisplay}" height="105"  color="0xffffff">
					<mx:series>
       					<mx:LineSeries yField="Recv" displayName="Received Video Rate [kbps]"/>
       					<mx:LineSeries yField="Sent" displayName="Sent Video Rate [kbps]" />
       				</mx:series>
           		</mx:LineChart>
           		<mx:Legend dataProvider="{videoRateChart}" direction="horizontal" color="0xffffff"/>
           		<mx:LineChart id="rttChart" dataProvider="{srttDisplay}" height="105" color="0xffffff">
					<mx:series>
       					<mx:LineSeries yField="Data" displayName="RTT [ms]" />
       				</mx:series>
           		</mx:LineChart>
           		<mx:Legend dataProvider="{rttChart}" color="0xffffff"/>
			</mx:VBox>
		</mx:ViewStack>
	</mx:VBox>
</mx:Application>
*/
