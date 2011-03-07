package org.paazio {
	import flash.net.*;

	/**
	 * Interface to OpenID.
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.0.2
	 */
	public class OpenID {

		/**
		 * A user name.
		 */
		public var user:String = "";
		
		/**
		 * OpenID url of the user.
		 */
		public var url:String = "";
		
		/**
		 * Gateway to the backend.
		 */
		public var gateway:String = "";
		
		/**
		 * Net connector
		 */
		private var _connection:NetConnection;
		
		/**
		 * Responder for the incoming data.
		 */
		private var _responder:Responder;
		
		/**
		 * OpenID eliminates the need for multiple usernames across different websites, simplifying your online experience.
		 * @see http://openid.net/
		 */
		public function OpenID() 
		{
			_responder = new Responder(onResult, onStatus);
		}
		
		/**
		 * Get the NetConnection attached to this class.
		 */
		public function get connection():NetConnection {
			return this._connection;
		}
		
		/**
		 * Set the NetConnection for this class.
		 */
		public function set connection(conn:NetConnection):void 
		{
			this._connection = conn;
			this._connection.connect(gateway);
		}
		
		/**
		 * select user_id from user_openids where openid_url = url
		 * @param	url
		 * @return
		 */
		public function getUserId(url:String):String {
			this._connection.call("getUserId", this._responder);
			return "";
		}

		/**
		 * select openid_url from user_openids where user_id = user
		 * @param	user
		 * @return
		 */
		public function getOpenIDsByUser(user:String):String {
			return "";
		}

		/**
		 * insert into user_openids values (url, user)
		 * @param	url
		 * @param	user
		 */
		public function attachOpenID(url:String, user:String):void 
		{

		}

		/**
		 * delete from user_openids where openid_url = url and user_id = user
		 * @param	url
		 * @param	user
		 */
		public function detachOpenID(url:String, user:String):void 
		{

		}

		/**
		 * delete from user_openids where user_id = user
		 * @param	user
		 */
		public function detachOpenIDsByUser(user:String):void 
		{

		}
		
		/**
		 * 
		 * @param	obj
		 */
		private function onResult(obj:Object):void 
		{
			// Display the returned data
			trace(String(obj));
		}
		
		/**
		 * 
		 * @param	obj
		 */
		private function onStatus(obj:Object):void 
		{
			trace(String(obj.description));
		}
	}
}