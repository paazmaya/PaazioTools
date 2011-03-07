/**
 * @mxmlc -target-player=10.0.0 -debug -noplay -source-path=D:/AS3libs
 */

package sandbox
{
	import flash.display.*;
	import com.aol.api.wim.*;
	import com.aol.api.wim.data.*;
	import com.aol.api.wim.data.types.*;
	import com.aol.api.wim.events.*;
	import com.aol.api.wim.transactions.*;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '600', height = '400')]
	
	public class AimChat extends Sprite
	{
		
		private var devID:String = "xxxxxx";
		private var user:String = "paazmaya";
		private var pass:String = "xxxxx";
		
		private var session:Session;
		
		public function AimChat()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			session = new Session(stage, devID, "WIM Test Client", ".1");
			session.addEventListener(AuthChallengeEvent.AUTHENTICATION_CHALLENGED, onAuthChallengeEvent);
			
			session.addEventListener(BuddyListEvent.BUDDY_ADD_RESULT, onBuddyListEvent);
			session.addEventListener(BuddyListEvent.BUDDY_ADDING, onBuddyListEvent);
			session.addEventListener(BuddyListEvent.BUDDY_REMOVE_RESULT, onBuddyListEvent);
			session.addEventListener(BuddyListEvent.BUDDY_REMOVING, onBuddyListEvent);
			session.addEventListener(BuddyListEvent.GROUP_ADD_RESULT, onBuddyListEvent);
			session.addEventListener(BuddyListEvent.GROUP_REMOVE_RESULT, onBuddyListEvent);
			session.addEventListener(BuddyListEvent.LIST_RECEIVED, onBuddyListEvent);
			
			session.addEventListener(IMEvent.IM_RECEIVED, onImEvent);
			session.addEventListener(IMEvent.IM_SEND_RESULT, onImEvent);
			session.addEventListener(IMEvent.IM_SENDING, onImEvent);
			
			session.addEventListener(SessionEvent.EVENTS_FETCHED, onSessionEvent);
			session.addEventListener(SessionEvent.EVENTS_FETCHING, onSessionEvent);
			session.addEventListener(SessionEvent.SESSION_AUTHENTICATING, onSessionEvent);
			session.addEventListener(SessionEvent.SESSION_ENDING, onSessionEvent);
			session.addEventListener(SessionEvent.SESSION_STARTING, onSessionEvent);
			session.addEventListener(SessionEvent.STATE_CHANGED, onSessionEvent);
			
			session.addEventListener(SessionState.AUTHENTICATING, onSessionState);
			session.addEventListener(SessionState.AUTHENTICATION_CHALLENGED, onSessionState);
			session.addEventListener(SessionState.AUTHENTICATION_FAILED, onSessionState);
			session.addEventListener(SessionState.DISCONNECTED, onSessionState);
			session.addEventListener(SessionState.OFFLINE, onSessionState);
			session.addEventListener(SessionState.ONLINE, onSessionState);
			session.addEventListener(SessionState.RATE_LIMITED, onSessionState);
			session.addEventListener(SessionState.RECONNECTING, onSessionState);
			session.addEventListener(SessionState.STARTING, onSessionState);
			session.addEventListener(SessionState.UNAUTHENTICATED, onSessionState);
			
			session.addEventListener(UserEvent.BUDDY_PRESENCE_UPDATED, onUserEvent);
			session.addEventListener(UserEvent.MY_INFO_UPDATED, onUserEvent);
			session.addEventListener(UserEvent.PRESENCE_STATE_UPDATE_RESULT, onUserEvent);
			session.addEventListener(UserEvent.PRESENCE_STATE_UPDATING, onUserEvent);
			session.addEventListener(UserEvent.STATUS_MSG_UPDATE_RESULT, onUserEvent);
			session.addEventListener(UserEvent.STATUS_MSG_UPDATING, onUserEvent);
			
			session.signOn(user, pass);
		}
		
		private function onAuthChallengeEvent(event:AuthChallengeEvent):void
		{
			trace("onAuthChallengeEvent: " + event.type);
		}
		private function onBuddyListEvent(event:BuddyListEvent):void
		{
			trace("onBuddyListEvent: " + event.type);
			//displayBuddyList(event.buddyList);
		}
		private function onImEvent(event:IMEvent):void
		{
			trace("onImEvent: " + event.type);
			//check event.im.recipient and event.im.sender to make sure you want to listen for the event
		}
		private function onSessionEvent(event:SessionEvent):void
		{
			trace("onSessionEvent: " + event.type);
		}
		private function onSessionState(event:SessionState):void
		{
			trace("onSessionState: " + event);
		}
		private function onUserEvent(event:UserEvent):void
		{
			trace("onUserEvent: " + event.type);
		}
		
		

		private function displayBuddyList(list:BuddyList):void
		{
			//parse the buddy list and display it here.
		}
		
		
	}
}


/*
//send the IM
session.sendIMToBuddy("chattingchuck", "Hey, how is it going?");

//request the buddy information. Either pass a string or an array of strings.
session.requestBuddyInfo("chattingchuck");
 */
