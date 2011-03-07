/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	import flash.media.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]
	
	public class p2p extends Sprite
	{
		private var fmsPath:String;
		private var myNC:NetConnection;
		private var controlStream:NetStream;
		private var outgoingStream:NetStream;
		private var incomingStream:NetStream;
		private var listenerStream:NetStream;
		private var yourName:String;
		private var yourID:String;
		private var oppName:String;
		private var oppID:String;
		private var WebServiceUrl:String;
		
		// --

		
		private var sendBtn:Sprite;
		private var callBtn:Sprite;
		private var acceptBtn:Sprite;
		
		private var localVideoDisplay:Video;
		private var remoteVideoDisplay:Video;
		
		
		//正式开始喽
		public function p2p()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{

			sendBtn = drawButton("send");
			sendBtn.y = 10;
			sendBtn.x = 10;
			addChild(sendBtn);
			
			callBtn = drawButton("call");
			callBtn.y = 40;
			callBtn.x = 10;
			addChild(callBtn);
			
			acceptBtn = drawButton("accept");
			acceptBtn.y = 70;
			acceptBtn.x = 10;
			addChild(acceptBtn);
			
			localVideoDisplay = new Video();
			localVideoDisplay.y = 200;
			addChild(localVideoDisplay);
			remoteVideoDisplay = new Video();
			remoteVideoDisplay.y = 200;
			remoteVideoDisplay.x = 400;
			addChild(remoteVideoDisplay);
			
			init();
		}
		
		private function drawButton(text:String):Sprite
		{
			var sp:Sprite = new Sprite();
			var gra:Graphics = sp.graphics;
			gra.beginFill(0x567440);
			gra.drawRoundRect(0, 0, 100, 22, 10, 10);
			gra.endFill();
			var tx:TextField = new TextField();
			tx.y = 2;
			tx.x = 2;
			tx.text = text;
			sp.addChild(tx);
			sp.mouseChildren = false;
			return sp;
		}
			
		//初始化工作
		private function init():void
		{
			fmsPath = "rtmfp://stratus.adobe.com/HawkPrerelease-4e4efa13755c/FMSer.cn";
			WebServiceUrl = "http://76.74.170.61/cgi-bin/reg";
			myNC = new NetConnection();
			myNC.client = this;
			myNC.objectEncoding = ObjectEncoding.AMF3;
			myNC.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
			myNC.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			myNC.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncError);
			//开始连接服务器
			myNC.connect(fmsPath);
			//随机生成用户名
			trace("FMSer"+int(Math.random()*100));
			sendBtn.addEventListener(MouseEvent.CLICK,sendChatMsg);
		}

		private function asyncError(e:AsyncErrorEvent):void
		{
		}
		
		private function securityError(e:SecurityErrorEvent):void
		{
		}
			
		//连接功能后将自己的用户名和ID传给WEB服务器暂存
		private function netStatus(e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success" :
				trace("连接成功！");
				trace(myNC.nearID);
				callWebService();
				break;
				case "NetConnection.Connect.Failed" :
				trace("连接失败！");
				break;
				case "NetConnection.Connect.Rejected" :
				trace("连接失败！");
				break;
				case "NetConnection.Connect.Closed" :
				trace("连接中断！");
				break;
			}

		}
			
		//完成用户信息提交工作
		private function callWebService():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
			var urlRequest:URLRequest = new URLRequest(WebServiceUrl);
			var parameter:URLVariables = new URLVariables  ;
			parameter.username = "username";
			parameter.identity = "identity";
			urlRequest.data = parameter;
			urlLoader.load(urlRequest);
		}
			
		//准备呼叫和被呼叫
		private function completeHandler(event:Event):void
		{
			callBtn.addEventListener(MouseEvent.CLICK,startCall);
			completeRegistration();
		}
		
		private function ioerrorHandler(e:IOErrorEvent):void
		{
		}
		
		//开始呼叫
		private function startCall(e:MouseEvent):void
		{
			oppName = "oppName";
			oppID = "oppID";
			placeCall(oppName,oppID);
		}
		
		//呼叫主函数
		private function placeCall(tmpOppName:String,tmpOppID:String):void
		{
			trace("正在呼叫:" + tmpOppName + "...");
			//尝试播放对方视频
			controlStream = new NetStream(myNC,tmpOppID);
			controlStream.addEventListener(NetStatusEvent.NET_STATUS,controlHandler);
			controlStream.play("control" +tmpOppName);
			//对外发布点对点视频
			outgoingStream = new NetStream(myNC,NetStream.DIRECT_CONNECTIONS);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS,outgoingStreamHandler);
			outgoingStream.publish("media-caller");
			var o:* = {};
			o.onPeerConnect  = function (tmpNS:NetStream):void{
				trace("正在建立P2P连接...");
			};
			outgoingStream.client = o;
			startAudio();
			startVideo();
			//接收来自外部的点对点视频
			incomingStream = new NetStream(myNC,tmpOppID);
			incomingStream.addEventListener(NetStatusEvent.NET_STATUS,incomingStreamHandler);
			incomingStream.play("media-callee");
			var st:*  = new SoundTransform(50);
			incomingStream.soundTransform = st;
			//被呼叫方接受连接时触发该事件
			var i:* = {};
			i.onCallAccepted  = function (tmpOppName:String):void{
				trace(tmpOppName + "已经接受了你的呼叫...");
			};
			//被呼叫方接受连接时触发该事件
			i.onIm = function (userName:String,chatMsg:String):void{
				trace(userName+ ": " + chatMsg + "\n");
			}

			incomingStream.client = i;
			remoteVideoDisplay.attachNetStream(incomingStream);
		}
			
		private function controlHandler(e:NetStatusEvent):void
		{
			trace(e.info.code);
		}
			
		private function outgoingStreamHandler(e:NetStatusEvent):void
		{
			outgoingStream.send("onIncomingCall","myname");
			trace(e.info.code);
		}
		
		private function startAudio():void
		{
			var myMic:Microphone = Microphone.getMicrophone(0);
			outgoingStream.attachAudio(myMic);
		}
		
		private function startVideo():void
		{
			var myCam:Camera = Camera.getCamera();
			localVideoDisplay.attachCamera(myCam);
			outgoingStream.attachCamera(myCam);
		}

		private function incomingStreamHandler(e:NetStatusEvent):void
		{
			trace(e.info.code);
		}
		
		//向Web服务器提交完信息后为连接做准备
		private function completeRegistration():void
		{
			listenerStream = new NetStream(myNC,NetStream.DIRECT_CONNECTIONS);
			listenerStream.addEventListener(NetStatusEvent.NET_STATUS,listenerHandler);
			listenerStream.publish("control" + "myname");
			
			var c:* = {};
			c.onPeerConnect = function (tmpNS:NetStream):void{
				var caller:*  = tmpNS;
				incomingStream = new NetStream(myNC,caller.farID);
				incomingStream.addEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
				incomingStream.play("media-caller");
				var st:SoundTransform =  new SoundTransform(50);
				incomingStream.soundTransform = st;
				incomingStream.receiveAudio(false);
				incomingStream.receiveVideo(false);
				var i:Object =  {};
				i.onIncomingCall = function (tmpOppName:String):void{
					trace(tmpOppName + "正在呼叫你,你接受吗?");
					acceptBtn.addEventListener(MouseEvent.CLICK,acceptCall)
				}
				i.onIm = function (userName:String,chatMsg:String):void{
					trace(userName+ ": " + chatMsg + "\n");
				}
				incomingStream.client = i;
			};
			listenerStream.client = c;
		}
		
		private function listenerHandler(e:NetStatusEvent):void
		{
			trace(e.info.code);
		}

			//接受呼叫
		public function acceptCall(e:MouseEvent):void
		{
			trace("你已经接受了对方的呼叫...");
			incomingStream.receiveAudio(true);
			incomingStream.receiveVideo(true);
			remoteVideoDisplay.attachNetStream(incomingStream);
			outgoingStream = new NetStream(myNC,NetStream.DIRECT_CONNECTIONS);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS,outgoingStreamHandler);
			outgoingStream.publish("media-callee");
			var o:* = {};
			o.onPeerConnect = function (tmpNS:NetStream):void
			{
				trace(tmpNS.farID);
			};
			outgoingStream.client = o;
			outgoingStream.send("onCallAccepted","username");
			startVideo();
			startAudio();
		}
			//发送聊天信息
		private function sendChatMsg(e:MouseEvent):void
		{
			var tmpMsg:* = "Ciao tonttu!";
			if (tmpMsg != 0 && outgoingStream)
			{
				trace(tmpMsg+"\n");
				outgoingStream.send("onIm", "myname", tmpMsg);
			}
			else
			{
				trace("发送内容为空或连接尚未建立!" + "\n");
			}
		}

	}
}
