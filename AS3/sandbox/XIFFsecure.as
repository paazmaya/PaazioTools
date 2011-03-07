/**
 * @mxmlc -target-player=10.0.0 -source-path=O:/www/xiff-tls -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.ui.Keyboard;
	import flash.system.Security;

	import org.igniterealtime.xiff.core.*;
	import org.igniterealtime.xiff.auth.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.events.*;
	import org.igniterealtime.xiff.conference.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.im.*;
	import org.igniterealtime.xiff.data.disco.*;
	import org.igniterealtime.xiff.data.browse.*;
	import org.igniterealtime.xiff.data.im.*;
	import org.igniterealtime.xiff.data.muc.*;
	import org.igniterealtime.xiff.data.vcard.*;
	
	import com.hurlant.crypto.tls.*;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '400')]
	
	/**
	 * Connect to the Google talk service:
	 * - The service is hosted at talk.google.com on port 5222
     * - TLS is required
     * - The only supported authentication mechanism is SASL PLAIN
	 * - user@gmail.com
	 *
	 * Connect to the Ovi Chat service:
	 * - Server chat.ovi.com, port 5223
	 * - Old style SSL
	 * - Zlib compression, authentication SASL PLAIN
	 * - user@ovi.com
	 */
	public class XIFFsecure extends Sprite
	{
		private const SERVER:String = "192.168.1.37"; // "talk.google.com"; // "chat.ovi.com";
		private const PORT:int = 5222;
		private const USERNAME:String =  "flasher"; // "olavic@gmail.com"; // "paazmaya@ovi.com";
		private const PASSWORD:String = "flasher";
		private const RESOURCE_NAME:String = "Apina";
		private const CHECK_POLICY:Boolean = true;
		private const POLICY_PORT:int = 5229;
		private const COMPRESS:Boolean = true;
		
		private var _connection:XMPPTLSConnection;
		private var _browser:Browser;
		private var _room:Room;
		private var _invite:InviteListener;
		private var _roster:Roster;

		private var _keepAlive:Timer;
		private var _people:Dictionary;
		
		private var _config:TLSConfig;

		public function XIFFsecure()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			if (CHECK_POLICY)
			{
				Security.loadPolicyFile("xmlsocket://" + SERVER + ":" + POLICY_PORT);
				Security.loadPolicyFile("xmlsocket://" + SERVER + ":" + PORT);
			}
			initChat();
		}

		private function initChat():void
		{
			_config = new TLSConfig(TLSEngine.CLIENT);
			_config.trustSelfSignedCertificates = true;
			
			createConnection();
			
			_browser = new Browser(_connection);
			
			_connection.connect();
			
			_people = new Dictionary();
			
			_keepAlive = new Timer(100000);
			_keepAlive.addEventListener(TimerEvent.TIMER, onKeepAliveLoop);
		}
		
		private function createConnection():void
		{
			_connection = new XMPPTLSConnection();
			_connection.addEventListener(ChangePasswordSuccessEvent.PASSWORD_SUCCESS, onPasswordSuccess);
			_connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess);
			_connection.addEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
			_connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, onXiffError);
			_connection.addEventListener(IncomingDataEvent.INCOMING_DATA, onIncomingData);
			_connection.addEventListener(LoginEvent.LOGIN, onLogin);
			_connection.addEventListener(MessageEvent.MESSAGE, onMessage);
			_connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData);
			_connection.addEventListener(PresenceEvent.PRESENCE, onPresence);
			_connection.addEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS, onRegistrationSuccess);
			
			_connection.server = SERVER;
			_connection.username = USERNAME;
			_connection.password = PASSWORD;
			_connection.port = PORT;
			_connection.resource = RESOURCE_NAME;
			_connection.compress = COMPRESS;
			_connection.config = _config;
		}
		
		private function createRoster():void
		{
			_roster = new Roster(_connection);
			_roster.addEventListener(RosterEvent.ROSTER_LOADED, onRoster);
			_roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL, onRoster);
			_roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST, onRoster);
			_roster.addEventListener(RosterEvent.SUBSCRIPTION_REVOCATION, onRoster);
			_roster.addEventListener(RosterEvent.USER_ADDED, onRoster);
			_roster.addEventListener(RosterEvent.USER_AVAILABLE, onRoster);
			_roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED, onRoster);
			_roster.addEventListener(RosterEvent.USER_REMOVED, onRoster);
			_roster.addEventListener(RosterEvent.USER_SUBSCRIPTION_UPDATED, onRoster);
			_roster.addEventListener(RosterEvent.USER_UNAVAILABLE, onRoster);
		}

		private function createRoom():void
		{
			_room = new Room(_connection);
			_room.addEventListener(RoomEvent.ADMIN_ERROR, onRoom);
			_room.addEventListener(RoomEvent.AFFILIATIONS, onRoom);
			_room.addEventListener(RoomEvent.BANNED_ERROR, onRoom);
			_room.addEventListener(RoomEvent.CONFIGURE_ROOM, onRoom);
			_room.addEventListener(RoomEvent.DECLINED, onRoom);
			_room.addEventListener(RoomEvent.GROUP_MESSAGE, onRoom);
			_room.addEventListener(RoomEvent.LOCKED_ERROR, onRoom);
			_room.addEventListener(RoomEvent.MAX_USERS_ERROR, onRoom);
			_room.addEventListener(RoomEvent.NICK_CONFLICT, onRoom);
			_room.addEventListener(RoomEvent.PASSWORD_ERROR, onRoom);
			_room.addEventListener(RoomEvent.PRIVATE_MESSAGE, onRoom);
			_room.addEventListener(RoomEvent.REGISTRATION_REQ_ERROR, onRoom);
			_room.addEventListener(RoomEvent.ROOM_JOIN, onRoom);
			_room.addEventListener(RoomEvent.ROOM_LEAVE, onRoom);
			_room.addEventListener(RoomEvent.SUBJECT_CHANGE, onRoom);
			_room.addEventListener(RoomEvent.USER_BANNED, onRoom);
			_room.addEventListener(RoomEvent.USER_DEPARTURE, onRoom);
			_room.addEventListener(RoomEvent.USER_JOIN, onRoom);
			_room.addEventListener(RoomEvent.USER_KICKED, onRoom);
		}
		
		private function getTime():String
		{
			var date:Date = new Date();
			var out:String = "";
			if (date.hours < 10)
			{
				out += "0";
			}
			out += date.hours + ":"
			if (date.minutes < 10)
			{
				out += "0";
			}
			out += date.minutes + ".";
			if (date.seconds < 10)
			{
				out += "0";
			}
			out += date.seconds;
			return out;
		}
		
		private function onPasswordSuccess(event:ChangePasswordSuccessEvent):void
		{
			trace("onPasswordSuccess. " + event.toString());
		}
		private function onConnectSuccess(event:ConnectionSuccessEvent):void
		{
			trace("onConnectSuccess. " + event.toString());
			createRoster();
		}
		private function onDisconnect(event:DisconnectionEvent):void
		{
			trace("onDisconnect. " + event.toString());
		}
		private function onXiffError(event:XIFFErrorEvent):void
		{
			trace("onXiffError. " + event.toString());
			trace("onXiffError. errorMessage: " + event.errorMessage);
			trace("onXiffError. errorCondition: " + event.errorCondition);
		}
		private function onIncomingData(event:IncomingDataEvent):void
		{
			trace("onIncomingData. " + event.toString());
			trace("onIncomingData. (" + getTime() + ") data: " + event.data);
		}
		private function onLogin(event:LoginEvent):void
		{
			trace("onLogin. " + event.toString());
			
			var presence:Presence = new Presence(null, _connection.jid.escaped);
			_connection.send(presence);

			_keepAlive.start();
		}
		private function onMessage(event:MessageEvent):void
		{
			trace("onMessage. " + event.toString());
			trace("onMessage. time: " + event.data.time);
		}
		private function onOutgoingData(event:OutgoingDataEvent):void
		{
			trace("onOutgoingData. " + event.toString());
			trace("onOutgoingData. (" + getTime() + ") data: " + event.data);
		}
		private function onPresence(event:PresenceEvent):void
		{
			trace("onPresence. " + event.toString());
		}
		private function onRegistrationSuccess(event:RegistrationSuccessEvent):void
		{
			trace("onRegistrationSuccess. " + event.toString());
		}

		private function onRoom(event:RoomEvent):void
		{
			trace("onRoom. " + event.toString());
			trace("onRoom. data: " + event.data);
			switch (event.type)
			{
				case RoomEvent.ADMIN_ERROR :
					break;
					
				case RoomEvent.AFFILIATIONS :
					break;
					
				case RoomEvent.BANNED_ERROR :
					break;
					
				case RoomEvent.CONFIGURE_ROOM :
					break;
					
				case RoomEvent.DECLINED :
					break;
					
				case RoomEvent.GROUP_MESSAGE :
					break;
					
				case RoomEvent.LOCKED_ERROR :
					break;
					
				case RoomEvent.MAX_USERS_ERROR :
					break;
					
				case RoomEvent.NICK_CONFLICT :
					break;
					
				case RoomEvent.PASSWORD_ERROR :
					break;
					
				case RoomEvent.PRIVATE_MESSAGE :
					break;
					
				case RoomEvent.REGISTRATION_REQ_ERROR :
					break;
					
				case RoomEvent.ROOM_JOIN :
					break;
					
				case RoomEvent.ROOM_LEAVE :
					break;
					
				case RoomEvent.SUBJECT_CHANGE :
					break;
					
				case RoomEvent.USER_BANNED :
					break;
					
				case RoomEvent.USER_DEPARTURE :
					break;
					
				case RoomEvent.USER_JOIN :
					break;
					
				case RoomEvent.USER_KICKED :
					break;
			}
		}


		private function onInvite(event:InviteEvent):void
		{
			trace("onInvite. " + event.toString());
			switch (event.type)
			{
				case InviteEvent.INVITED :
					break;
			}
		}

		private function onKeepAliveLoop(event:TimerEvent):void
		{
			_connection.sendKeepAlive();
		}
			
		private function onRoster(event:RosterEvent):void
		{
			trace("onRoster. " + event.toString());
			trace("onRoster. data: " + event.data);
			switch (event.type)
			{
				case RosterEvent.ROSTER_LOADED :
					break;
					
				case RosterEvent.SUBSCRIPTION_DENIAL :
					break;
					
				case RosterEvent.SUBSCRIPTION_REQUEST :
					// If the JID is in the _roster, accept immediately
					if (_roster.getPresence(event.jid) != null)
					{
						_roster.grantSubscription(event.jid, true);
					}
					break;
					
				case RosterEvent.SUBSCRIPTION_REVOCATION :
					break;
					
				case RosterEvent.USER_ADDED :
					_people[event.jid.toString()] = event.data;
					break;
					
				case RosterEvent.USER_AVAILABLE :
					break;
					
				case RosterEvent.USER_PRESENCE_UPDATED :
					break;
					
				case RosterEvent.USER_REMOVED :
					break;
					
				case RosterEvent.USER_SUBSCRIPTION_UPDATED :
					break;
					
				case RosterEvent.USER_UNAVAILABLE :
					break;
			}
		}
	}
}
