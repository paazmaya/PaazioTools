/**
 * @mxmlc -target-player=10.0.0 -debug -source-path+=../../../www/xiff-xmlnode-to-xml
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
	import flash.geom.Matrix;
    import flash.text.*;
    import flash.utils.*;
	import flash.system.Security;
    import flash.ui.Keyboard;

    import org.igniterealtime.xiff.conference.*;
    import org.igniterealtime.xiff.core.*;
    import org.igniterealtime.xiff.data.*;
    import org.igniterealtime.xiff.data.disco.*;
    import org.igniterealtime.xiff.data.im.*;
    import org.igniterealtime.xiff.data.muc.*;
	import org.igniterealtime.xiff.data.vcard.*;
    import org.igniterealtime.xiff.events.*;
    import org.igniterealtime.xiff.exception.*;
    import org.igniterealtime.xiff.im.*;
    import org.igniterealtime.xiff.util.*;
	import org.igniterealtime.xiff.vcard.VCard;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]

	/**
	 * A test chat application which should include every functionality offered by XIFF.
	 */
    public class Mugamae extends Sprite
	{
		private const SERVER:String = "192.168.1.37";
		private const PORT:uint = 5222;
		private const USERNAME:String = "flasher";
		private const PASSWORD:String = "flasher";
		private const RESOURCE_NAME:String = "AvatarTest";
		private const CHECK_POLICY:Boolean = true;
		private const SEND_STATES:Boolean = true;
		private const POLICY_PORT:uint = 5229;
		private const COMPRESS:Boolean = false;
		private const METHOD:uint = XMPPConnection.STREAM_TYPE_STANDARD;
		private const STATISTICS_INTERVAL:Number = 2;
		
		// Chat state timeouts
		private const TIMEOUT_PAUSED:Number = 10;
		private const TIMEOUT_INACTIVE:Number = 2 * 60;
		private const TIMEOUT_GONE:Number = 8 * 60;
		private const STATE_INTERVAL:Number = 3;
		
		/**
		 * How often the keep alive call is made, seconds.
		 */
		private const KEEP_ALIVE_INTERVAL:Number = 30;
		
		
        private var _connection:XMPPConnection;
        private var _roster:Roster;
		private var _listener:InviteListener;
        private var _browser:Browser;
        private var _room:Room;
		
		private var _inputField:TextField;
		private var _keepAlive:Timer;
		private var _outputField:TextField;
        private var _rosterCont:Sprite;
        private var _roomCont:Sprite;
		private var _stateTimer:Timer;
		private var _statField:TextField;
		private var _statTimer:Timer;
		private var _vcards:Array = [];
        private var _chattingWith:EscapedJID;
		private var _conferenceServer:String = "";
		
		private var _outgoingNonCompressed:uint = 0;
		private var _incomingNonCompressed:uint = 0;
		
		/**
		 * Current state. One of the Message.STATE_... constants.
		 */
		private var _currentState:String;
		
		/**
		 * Save the previous state to check in the timer and avoid unnessesary data transfer.
		 */
		private var _previousState:String;
			
		/**
		 * getTimer() of the last KeyUp event.
		 */
		private var _lastActivity:Number = 0;
		
		
		/**
		 * @see http://xmpp.org/registrar/namespaces.html
		 * @see https://support.process-one.net/doc/display/MESSENGER/XMPP+Namespaces
		 */
		public function Mugamae()
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
			}
			_stateTimer = new Timer(STATE_INTERVAL * 1000);
			_stateTimer.addEventListener(TimerEvent.TIMER, onStateInterval);
			
			_keepAlive = new Timer(KEEP_ALIVE_INTERVAL * 1000);
			_keepAlive.addEventListener(TimerEvent.TIMER, onKeepAliveLoop);
			
            _statTimer = new Timer(STATISTICS_INTERVAL * 1000);
            _statTimer.addEventListener(TimerEvent.TIMER, onStatTimer);
			_statTimer.start();
			
            _rosterCont = new Sprite();
			_rosterCont.name = "rosterCont";
			_rosterCont.x = 10;
			_rosterCont.y = 80;
			addChild(_rosterCont);
			
			_roomCont = new Sprite();
			_roomCont.name = "roomCont";
			_roomCont.x = 320;
			_roomCont.y = 290;
			addChild(_roomCont);
			
			createAllFields();
			
            connect();
        }
		private function createAllFields():void
		{
			_statField = createField("statField", 10, 10, 300, 60);
            addChild(_statField);
			
			_outputField = createField("output", 320, 10, stage.stageWidth - 340, 220);
			addChild(_outputField);
			
			_inputField = createField("input", 320, 240, stage.stageWidth - 340, 40);
			_inputField.type = TextFieldType.INPUT;
			_inputField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addChild(_inputField);
		}
		
        private function connect():void
		{
            _connection = new XMPPConnection();
			_connection.addEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
			_connection.addEventListener(IncomingDataEvent.INCOMING_DATA, onIncomingData);
            _connection.addEventListener(LoginEvent.LOGIN, onLogin);
            _connection.addEventListener(MessageEvent.MESSAGE, onMessage);
            _connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData);
            _connection.addEventListener(PresenceEvent.PRESENCE, onPresence);
            _connection.addEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS, onRegistrationSuccess);
            _connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, onXiffError);

			_connection.username = USERNAME;
			_connection.password = PASSWORD;
			_connection.server = SERVER;
			_connection.port = PORT;
			_connection.resource = RESOURCE_NAME;
			_connection.compress = COMPRESS;
			_connection.connect(METHOD);
			
			_statTimer.start();
			
            MUC.enable();

            _roster = new Roster(_connection);
            _roster.addEventListener(RosterEvent.ROSTER_LOADED, onRoster);
            _roster.addEventListener(RosterEvent.USER_ADDED, onRoster);
			
            _room = new Room(_connection);
            _room.addEventListener(RoomEvent.ADMIN_ERROR, onRoom);
            _room.addEventListener(RoomEvent.AFFILIATIONS, onRoom);
            _room.addEventListener(RoomEvent.BANNED_ERROR, onRoom);
            _room.addEventListener(RoomEvent.CONFIGURE_ROOM, onRoom);
            _room.addEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, onRoom);
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
			
            _browser = new Browser(_connection);
        }
		
		private function visualiseRoster():void
		{
			var items:Array = _roster.toArray();
			var len:uint = items.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var item:RosterItemVO = items[i] as RosterItemVO;
				var box:Sprite = createUserBox(item);
				box.x = 10;
				box.y = 10 + box.height * i;
				_rosterCont.addChild(box);
				
				var vCard:VCard = VCard.getVCard(_connection, item);
				vCard.addEventListener(VCardEvent.LOADED, onVCard);
				vCard.addEventListener(VCardEvent.AVATAR_LOADED, onVCard);
				vCard.addEventListener(VCardEvent.ERROR, onVCard);
				_vcards.push(vCard);
			}
		}
		
        private function createUserBox(item:RosterItemVO):Sprite
		{
            var sp:Sprite = new Sprite();
            sp.name = item.jid.bareJID;
            sp.mouseChildren = false;
            sp.buttonMode = true;
			
			var bm:Bitmap = new Bitmap(new BitmapData(100, 100));
			bm.name = "avatar";
			bm.bitmapData.perlinNoise(40, 60, 4, 4, true, false);
			bm.x = 2;
			bm.y = 2;
			sp.addChild(bm);

            var tx:TextField = new TextField();
			tx.name = "jid";
			tx.defaultTextFormat = new TextFormat("Arial", 11, 0x121212);
            tx.text = item.jid.bareJID;
			tx.multiline = true;
			tx.wordWrap = true;
            tx.x = 104;
            tx.y = 2;
			tx.width = 170;
            sp.addChild(tx);
			
			var sh:Shape = new Shape();
			sh.name = "presence";
			sh.x = 104;
			sh.y = 30;
			sp.addChild(sh);
			
			updateRosterStatus(sp);
			
			drawBoxBackground(sp);

            sp.addEventListener(MouseEvent.CLICK, onUserBoxClick);
			return sp;
        }
		
		private function updateSelectedUserbox():void
		{
			var num:uint = _rosterCont.numChildren;
			for (var i:uint = 0; i < num; ++i)
			{
				var sp:Sprite = _rosterCont.getChildAt(i) as Sprite;
				drawBoxBackground(sp);
			}
		}
		private function updateRosterStatus(sp:Sprite):void
		{
			var sh:Shape = sp.getChildByName("presence") as Shape;
			var pres:Presence = _roster.getPresence(new UnescapedJID(sp.name));
			var color:uint = 0x6A6A6A;
			
			if (pres != null && pres.show != null)
			{
				if (pres.show == Presence.SHOW_CHAT)
				{
					color = 0x00FF44;
				}
				else if (pres.show == Presence.SHOW_DND)
				{
					color = 0xFF4400;
				}
				else if (pres.show == Presence.SHOW_AWAY)
				{
					color = 0x886600;
				}
				else if (pres.show == Presence.SHOW_XA)
				{
					color = 0xDFDFDF;
				}
			}
			
			var gr:Graphics = sh.graphics;
			gr = sh.graphics;
			gr.clear();
			gr.beginFill(color);
			gr.drawCircle(5, 5, 5);
			gr.endFill();
		}
		
		private function drawBoxBackground(sp:Sprite):void
		{
			var color:uint = 0x9F9F9F;
			if (_chattingWith != null && sp.name == _chattingWith.toString())
			{
				color = 0x5B5B5B;
			}
            var gr:Graphics = sp.graphics;
			gr.clear();
            gr.beginFill(color);
            gr.lineStyle(1, 0x1A1A1A);
            gr.drawRoundRect(0, 0, sp.width + 4, sp.height + 4, 8, 8);
            gr.endFill();
		}
		
		private function updateUserBox(item:VCard):void
		{
			var loader:Loader = new Loader();
			loader.name = item.jid.bareJID;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaderComplete);
			loader.loadBytes(item.avatar);
		}
		
		private function onAvatarLoaderComplete(event:Event):void
		{
			var info:LoaderInfo = event.target as LoaderInfo;
			var loader:Loader = info.loader;
			
			var sp:Sprite = _rosterCont.getChildByName(loader.name) as Sprite;
			if (sp != null)
			{
				var bm:Bitmap = sp.getChildByName("avatar") as Bitmap;
				
				// Wanna get a square
				var scale:Number = Math.max(bm.width / loader.width, bm.height / loader.height);
				var mat:Matrix = new Matrix();
				mat.scale(scale, scale);
				mat.tx = bm.width - scale * loader.width;
				mat.ty = bm.height - scale * loader.height;
				trace("onAvatarLoaderComplete. mat: " + mat);
				
				bm.bitmapData.draw(loader, mat);
			}
		}
		
		private function drawInvDialog(roomName:String, user:String):void
		{
			var sp:Sprite = new Sprite();
			sp.name = roomName;
			sp.mouseChildren = false;
			sp.x = 200;
			sp.y = 10 + Math.random() * 100;
			sp.addEventListener(MouseEvent.MOUSE_OVER, onInvDialogMouse);
			sp.addEventListener(MouseEvent.CLICK, onInvDialogMouse);
			
			var w:Number = 200;
			var h:Number = 60;

			var gra:Graphics = sp.graphics;
			gra.beginFill(0x0066FF);
			gra.drawRoundRect(0, 0, w, h, 10, 10);
			gra.endFill();
			gra.beginFill(0x3399FF);
			gra.drawRoundRect(5, 5, w - 10, h - 10, 10, 10);
			gra.endFill();
			
			var format:TextFormat = new TextFormat("Verdana", 12, 0x121212);

			var field:TextField = new TextField();
			field.name = "field";
			field.multiline = true;
			field.wordWrap = true;
			field.text = "You have been invited to a conference room [" + roomName + "] by user [" + user + "]";
			field.x = 7;
			field.y = 7;
			field.width = sp.width - 14;
			field.height = sp.height - 14;
			sp.addChild(field);

			_roomCont.addChild(sp);
		}
		
		private function onInvDialogMouse(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			
			if (event.type == MouseEvent.MOUSE_OVER)
			{
				_roomCont.swapChildren(sp, _roomCont.getChildAt(_roomCont.numChildren - 1));
			}
			else if (event.type == MouseEvent.CLICK)
			{
				if (_room.isActive)
				{
					_room.leave();
				}
				_room.roomJID = new UnescapedJID(sp.name);
				_room.join();
			}
		}

		private function onInvited(event:InviteEvent):void
		{
			drawInvDialog(event.room.roomJID.toString(), event.from.toString());
		}
		
        private function onVCard(event:VCardEvent):void
		{
            trace("onVCard. " + event.toString());
			if (event.type == VCardEvent.AVATAR_LOADED)
			{
				updateUserBox(event.vcard);
			}
			else if (event.type == VCardEvent.ERROR)
			{
				// Triggered only by _vCardSent in VCard.
				trace("onVCard. ERROR. " + event.vcard);
			}
        }
		
        private function onMessage(event:MessageEvent):void
		{
			trace("onMessage. " + event.toString());
			var message:Message = event.data as Message;
			
			if (message.body != null)
			{
				addMessage(message);
			}
			if (message.state != null)
			{
				updateState(message);
			}
        }
		
        private function onPresence(event:PresenceEvent):void
		{
			trace("onPresence. " + event.toString());
			var len:uint = event.data.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var presence:Presence = event.data[i] as Presence;
				trace("onPresence. " + i + " show: " + presence.show);
				trace("onPresence. " + i + " type: " + presence.type);
				trace("onPresence. " + i + " status: " + presence.status);
				trace("onPresence. " + i + " from: " + presence.from);
				trace("onPresence. " + i + " to: " + presence.to);
				
				switch (presence.type)
				{
					case Presence.TYPE_SUBSCRIBE :
						// Automatically add all those to _roster whom have requested to be our friend.
						_roster.grantSubscription(presence.from.unescaped, true);
						break;
					case Presence.TYPE_SUBSCRIBED :
						break;
				}
			}
		}
		
        private function onRegistrationSuccess(event:RegistrationSuccessEvent):void
		{
            trace("onRegistrationSuccess. " + event.toString());
        }

        private function onRoster(event:RosterEvent):void
		{
            trace("onRoster. " + event.toString());
            switch (event.type)
			{
                case RosterEvent.ROSTER_LOADED :
					visualiseRoster();
                    break;
                case RosterEvent.USER_ADDED :
                    break;
            }
        }
		
        private function onKeyUp(event:KeyboardEvent):void
		{
            switch(event.keyCode)
			{
                case Keyboard.ENTER :
                    messageSend();
                    break;
            }
        }
		
        private function messageSend():void
		{
			/*
            var txt:String = _inputField.text;
            if (_connection.isLoggedIn() && _room.isActive)
			{
                _room.sendMessage(txt);
                _inputField.text = "";
            }*/
			var messageSent:Boolean = false;
            var txt:String = _inputField.text;
			if (txt != "" && _chattingWith != null)
			{
				var message:Message = new Message(_chattingWith, null, txt, null, Message.TYPE_CHAT);
				if (SEND_STATES)
				{
					message.state = Message.STATE_ACTIVE;
					_currentState = Message.STATE_ACTIVE;
				}
				if (_connection.isLoggedIn())
				{
					message.from = _connection.jid.escaped;
					_connection.send(message);
					_inputField.text = "";
					addMessage(message);
					messageSent = true;
				}
				_lastActivity = getTimer();
				if (SEND_STATES && !messageSent)
				{
					_currentState = Message.STATE_COMPOSING;
					sendState();
				}
			}
        }
		
        private function addMessage(message:Message):void
		{
			var date:Date = new Date();
			if (message.time != null)
			{
				date = message.time;
			}
			var text:String = "[" + DateTimeParser.time2string(date) + " | ";
			if (message.type == Message.TYPE_GROUPCHAT)
			{
				text += message.from.resource + " > room:" + message.from.node;
			}
			else
			{
				text += message.from.node + " > " + message.to.node;
			}
			text += "] " + message.body;
			
			_outputField.appendText(text + "\n");
			_outputField.scrollV = _outputField.maxScrollV;
		}
		
		private function updateState(message:Message):void
		{
			var from:String = message.from.bareJID;
			var sp:Sprite = _rosterCont.getChildByName(from) as Sprite;
			if (sp != null)
			{
				var tx:TextField = sp.getChildByName("jid") as TextField;
				tx.text = from + " is " + message.state;
			}
		}
		
		
        private function onUserBoxClick(event:MouseEvent):void
		{
            var sp:Sprite = event.target as Sprite;
			_chattingWith = new EscapedJID(sp.name);
			updateSelectedUserbox();
        }

        private function onKeepAliveLoop(event:TimerEvent):void
		{
            if (_connection.isLoggedIn())
			{
                _connection.sendKeepAlive();
            }
        }
		
		private function onStatTimer(event:TimerEvent):void
		{
			if (_connection != null)
			{
				_statField.text = "Compressed / Uncompressed\n"
					+ "Incoming KB: " + Math.round(_connection.incomingBytes / 1024) + " / "
					+ Math.round(_incomingNonCompressed / 1024) + "\n"
					+ "Outgoing KB: " + Math.round(_connection.outgoingBytes / 1024) + " / "
					+ Math.round(_outgoingNonCompressed / 1024) + "\n";
			}
		}
		
		/**
		 * New state will not be send if it is the same as the previous.
		 *
		 *                 o (start)
		 *                 |
		 *                 |
		 * INACTIVE <--> ACTIVE <--> COMPOSING
		 *     |           ^            |
		 *     |           |            |
		 *     + <------ PAUSED <-----> +
		 *
		 * @see http://xmpp.org/extensions/xep-0085.html#statechart
		 * @param	event
		 */
		private function onStateInterval(event:TimerEvent):void
		{
			var diff:Number = (getTimer() - _lastActivity) / 1000;
			if (diff >  TIMEOUT_GONE)
			{
				_currentState = Message.STATE_GONE;
			}
			else if (diff > TIMEOUT_INACTIVE)
			{
				_currentState = Message.STATE_INACTIVE;
			}
			else if (diff > TIMEOUT_PAUSED)
			{
				_currentState = Message.STATE_PAUSED;
			}
			
			trace("onStateInterval. getTimer: " + getTimer() + ", currentCount: "
				+ _stateTimer.currentCount + ", _currentState: " + _currentState
				+ ", diff: " + diff);
			
			// TODO: Should check for the ordering according to the state chart
			sendState();
		}
		
		private function sendState():void
		{
			if (_chattingWith != null && _currentState != _previousState)
			{
				_previousState = _currentState;
				
				var message:Message = new Message(_chattingWith, null, null, null, Message.TYPE_CHAT);
				message.state = _currentState;
				_connection.send(message);
			}
		}
		
        private function onLogin(event:LoginEvent):void
		{
            trace("onLogin. " + event.toString());
            _keepAlive.start();
			
			var presence:Presence = new Presence(null, _connection.jid.escaped, null, null, null, 1);
            _connection.send(presence);
			
            var serverJID:EscapedJID = new EscapedJID(SERVER);
			_browser.browseItem(serverJID, "browseItemCall", this);
			_browser.getNodeInfo(serverJID, "", "getNodeInfoCall", this);
			_browser.getNodeItems(serverJID, "", "getNodeItemsCall", this);
            _browser.getServiceInfo(serverJID, "serviceInfoCall", this);
            _browser.getServiceItems(serverJID, "serviceItemsCall", this);
        }
		
        private function onRoom(event:RoomEvent):void
		{
            trace("onRoom. " + event.toString());
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
                case RoomEvent.CONFIGURE_ROOM_COMPLETE :
                    break;
                case RoomEvent.DECLINED :
                    break;
                case RoomEvent.GROUP_MESSAGE :
                    // Could also use MessageEvent event of the XMPPConnection.
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
		
        private function createButton(txt:String, jid:String, counter:uint, xPos:Number = 0):void
		{
            var sp:Sprite = new Sprite();
            sp.name = jid;
            sp.mouseChildren = false;
            sp.buttonMode = true;
			sp.alpha = 0.6;

            var tx:TextField = new TextField();
            tx.text = txt;
            tx.textColor = 0xE3E3C9;
            tx.autoSize = TextFieldAutoSize.LEFT;
            tx.y = 2;
            tx.x = 2;
            sp.addChild(tx);

            var gr:Graphics = sp.graphics;
            gr.beginFill(0x961D18);
            gr.lineStyle(1, 0xE3E3C9);
            gr.drawRoundRect(0, 0, sp.width + 4, 22, 8, 8);
            gr.endFill();

			if (txt == "Public Chatrooms")
			{
				_conferenceServer = jid;
				sp.addEventListener(MouseEvent.CLICK, onConferenceMouse);
				sp.alpha = 1.0;
			}
			else if (_conferenceServer != "" && jid.split("@").pop() == _conferenceServer)
			{
				sp.addEventListener(MouseEvent.CLICK, onRoomMouse);
				sp.alpha = 1.0;
			}
			sp.x = xPos;
			sp.y = sp.height * counter;
			//_serviceButtons.addChild(sp);
        }

        private function onConferenceMouse(event:MouseEvent):void
		{
            var jid:EscapedJID = new EscapedJID(_conferenceServer);
            _browser.getServiceItems(jid, "serviceItemsCall", this);
        }

        private function onRoomMouse(event:MouseEvent):void
		{
            var jid:EscapedJID = new EscapedJID(event.target.name);
			if (_room.isActive)
			{
				_room.leave();
			}
			_room.roomJID = jid.unescaped;
			_room.join();
        }

        public function browseItemCall(iq:IQ):void
		{
            var extensions:Array = iq.getAllExtensions();
            for (var s:int = 0; s < extensions.length; ++s)
			{
                var disco:ItemDiscoExtension = extensions[s];
                var items:Array = disco.items;
                trace("-- browseItemCall. round " + s + ". items.length: " + items.length);
                for (var i:uint = 0; i < items.length; ++i)
				{
                    var obj:Object = items[i] as Object;
                    trace("-- name: " + obj.name + ", jid: " + obj.jid + ", node: " + obj.node + ", action: " + obj.action);
                }
            }
        }
        public function getNodeInfoCall(iq:IQ):void
		{
            var extensions:Array = iq.getAllExtensions();
            for (var s:int = 0; s < extensions.length; ++s)
			{
                var disco:ItemDiscoExtension = extensions[s];
                var items:Array = disco.items;
                trace("-- getNodeInfoCall. round " + s + ". items.length: " + items.length);
                for (var i:uint = 0; i < items.length; ++i)
				{
                    var obj:Object = items[i] as Object;
                    trace("-- name: " + obj.name + ", jid: " + obj.jid + ", node: " + obj.node + ", action: " + obj.action);
                }
            }
        }
        public function getNodeItemsCall(iq:IQ):void
		{
            var extensions:Array = iq.getAllExtensions();
            for (var s:int = 0; s < extensions.length; ++s)
			{
                var disco:ItemDiscoExtension = extensions[s];
                var items:Array = disco.items;
                trace("-- getNodeItemsCall. round " + s + ". items.length: " + items.length);
                for (var i:uint = 0; i < items.length; ++i)
				{
                    var obj:Object = items[i] as Object;
                    trace("-- name: " + obj.name + ", jid: " + obj.jid + ", node: " + obj.node + ", action: " + obj.action);
                }
            }
        }

        public function serviceItemsCall(iq:IQ):void
		{
			//var xPos:Number = _serviceButtons.width;
            var extensions:Array = iq.getAllExtensions();
            for (var s:int = 0; s < extensions.length; ++s)
			{
                var disco:ItemDiscoExtension = extensions[s];
                var items:Array = disco.items;
                trace(">> serviceItemsCall. round " + s + ". items.length: " + items.length);
                for (var i:uint = 0; i < items.length; ++i)
				{
                    var obj:Object = items[i] as Object;
              //      createButton(String(obj.name), String(obj.jid), i, xPos);
                    trace(">> name: " + obj.name + ", jid: " + obj.jid + ", node: " + obj.node + ", action: " + obj.action);
                }
            }
        }

        public function serviceInfoCall(iq:IQ):void
		{
            var extensions:Array = iq.getAllExtensions();
            for (var s:int = 0; s < extensions.length; ++s)
			{
                var disco:InfoDiscoExtension = extensions[s];
                var features:Array = disco.features;
                for (var r:int = 0; r < features.length; ++r)
				{
                    trace("** serviceInfoCall. " + r + " [" + features[r] + "]");
                }
                var identities:Array = disco.identities;
                for (var i:int = 0; i < identities.length; ++i)
				{
                    var obj:Object = identities[i] as Object;
                    trace("** serviceInfoCall. name: " + obj.name + ", type: " + obj.type + ", category: " + obj.category);
                }
            }
        }
		
		private function onDisconnect(event:DisconnectionEvent):void
		{
            trace("onDisconnect. " + event.toString());
            _keepAlive.stop();
		}
		
        private function onXiffError(event:XIFFErrorEvent):void
		{
            trace("onXiffError. " + event.toString());
			trace("onXiffError.errorMessage: " + event.errorMessage);
        }
		
		private function onIncomingData(event:IncomingDataEvent):void
		{
			trace("onIncomingData. " + event.toString());
			trace("onIncomingData. data: " + event.data.toString());
			_incomingNonCompressed += event.data.length;
		}
		
		private function onOutgoingData(event:OutgoingDataEvent):void
		{
			trace("onOutgoingData. " + event.toString());
			trace("onOutgoingData. data: " + event.data.toString());
			_outgoingNonCompressed += event.data.length;
		}
		
		private function createField(name:String, xPos:Number,
			yPos:Number, w:Number, h:Number):TextField
		{
			var format:TextFormat = new TextFormat("Verdana", 12, 0x121212);
			var bgColor:uint = 0xE3E3C9;
			var borderColor:uint = 0x961D18;
			
			var field:TextField = new TextField();
			field.name = name;
			field.defaultTextFormat = format;
			field.background = true;
			field.backgroundColor = bgColor;
			field.border = true;
			field.borderColor = borderColor;
            field.multiline = true;
			field.wordWrap = true;
			field.mouseWheelEnabled = true;
			field.x = xPos;
			field.y = yPos;
			field.width = w;
			field.height = h;
			
			return field;
		}
    }
}
