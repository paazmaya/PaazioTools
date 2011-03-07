/**
 * @mxmlc -target-player=10.0.0 -debug
 *
 * Colors from Kuler: shark wrangler, http://kuler.adobe.com/#themeID/425255
 * 042836 background
 * 8B8C7D borders
 * E3E3C9 buttons text color, borders, bg for fields
 * FFFEE7
 * 961D18 button bg, field borders
 *
 * 121212 black used for text color when not a button.
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Security;
	import flash.text.*;

	[SWF( backgroundColor='0x042836',frameRate='33',width='400',height='200' )]

	public class TwitterPaazmayaTest extends Sprite
	{

		[Embed( source="../assets/nrkis.ttf",fontFamily="nrkis" )]
		private var Nrkis:String;

		private var _image:Loader;

		private var _nameField:TextField;

		private var _format:TextFormat;

		private var _statutes:Sprite;

		public function TwitterPaazmayaTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			loaderInfo.addEventListener( Event.INIT, onInit );
		}

		private function onInit( event:Event ):void
		{
			Security.loadPolicyFile( "http://twitter.com/crossdomain.xml" );

			_format = new TextFormat( "nrkis", 13, 0xFFFEE7 );

			_statutes = new Sprite();
			_statutes.name = "statutes";
			_statutes.x = 60;
			_statutes.y = 30;
			addChild( _statutes );

			_image = new Loader();
			addChild( _image );

			_nameField = new TextField();
			_nameField.defaultTextFormat = _format;
			_nameField.embedFonts = true;
			_nameField.selectable = false;
			_nameField.x = 60;
			_nameField.width = 300;
			_nameField.height = 20;
			addChild( _nameField );

			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.GET;
			request.url = "http://twitter.com/status/user_timeline/paazmaya.xml?count=4";
			//request.url = "http://twitter.com/users/show/paazmaya.xml";

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener( Event.COMPLETE, onComplete );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.load( request );
		}

		private function onComplete( event:Event ):void
		{
			trace( "onComplete. " + event.toString() );
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML( loader.data );
			//trace(xml.toXMLString());

			//trace(xml..text.text());
			//trace(xml..created_at.text());
			for each ( var stat:XML in xml.children() )
			{
				drawStatus( stat );
			}

			var imageUrl:String = xml..user[ 0 ].profile_image_url.text(); //xml.profile_image_url.text()
			var userName:String = xml..user[ 0 ].name.text(); // xml.name.text()
			var screenName:String = xml..user[ 0 ].screen_name.text(); // xml.screen_name.text()
			var statusesCount:String = xml..user[ 0 ].statuses_count.text(); // xml.statuses_count.text()
			var userUrl:String = xml..user[ 0 ].url.text(); // xml.url.text()

			_image.load( new URLRequest( imageUrl ) );
			_nameField.text = userName + " [" + screenName + "] (" + statusesCount +
				") <" + userUrl + ">";

		}

		private function onSecurityError( event:SecurityErrorEvent ):void
		{
			trace( "onSecurityError. " + event.toString() );
		}

		private function onIOError( event:IOErrorEvent ):void
		{
			trace( "onIOError. " + event.toString() );
		}

		private function drawStatus( data:XML ):void
		{
			var sp:Sprite = new Sprite();
			sp.name = "st_" + data.id.text();
			sp.mouseChildren = false;

			var tfC:TextField = new TextField();
			tfC.defaultTextFormat = _format;
			tfC.embedFonts = true;
			tfC.height = 20;
			tfC.width = 220;
			tfC.wordWrap = true;
			tfC.multiline = true;
			tfC.text = data.created_at.text();
			sp.addChild( tfC );

			var tfT:TextField = new TextField();
			tfT.defaultTextFormat = _format;
			tfT.embedFonts = true;
			tfT.height = 50;
			tfT.width = 220;
			tfT.wordWrap = true;
			tfT.multiline = true;
			tfT.text = data.text.text();
			tfT.y = 25;
			sp.addChild( tfT );

			var gr:Graphics = sp.graphics;
			gr.beginFill( 0x961D18 );
			gr.lineStyle( 2, 0x8B8C7D );
			gr.drawRoundRect( 0, 0, 230, 80, 10, 10 );
			gr.endFill();

			sp.y = ( sp.height + 5 ) * _statutes.numChildren;
			_statutes.addChild( sp );
		}

	}
} /*
   <status>
   <created_at>Mon Aug 24 06:51:23 +0000 2009</created_at>
   <id>3508234851</id>
   <text>How come helsinki.fi does not tell anything of this weeks "Helsinki Liikkeelle" event? Anyhow, Naginata for free today at 19:30 local time.</text>
   <source>web</source>
   <truncated>false</truncated>
   <in_reply_to_status_id/>
   <in_reply_to_user_id/>
   <favorited>false</favorited>
   <in_reply_to_screen_name/>
   <user>
   <id>12070122</id>
   <name>Juga Paazmaya</name>
   <screen_name>paazmaya</screen_name>
   <location>Finland</location>
   <description/>
   <profile_image_url>http://a1.twimg.com/profile_images/117273364/jukka-in-midair_normal.jpg</profile_image_url>
   <url>http://paazio.nanbudo.fi</url>
   <protected>false</protected>
   <followers_count>17</followers_count>
   <profile_background_color>0f89b8</profile_background_color>
   <profile_text_color>152a32</profile_text_color>
   <profile_link_color>0e43cd</profile_link_color>
   <profile_sidebar_fill_color>c6c4b9</profile_sidebar_fill_color>
   <profile_sidebar_border_color>000000</profile_sidebar_border_color>
   <friends_count>13</friends_count>
   <created_at>Thu Jan 10 13:48:34 +0000 2008</created_at>
   <favourites_count>0</favourites_count>
   <utc_offset>7200</utc_offset>
   <time_zone>Helsinki</time_zone>
   <profile_background_image_url>http://s.twimg.com/a/1250203207/images/themes/theme12/bg.gif</profile_background_image_url>
   <profile_background_tile>false</profile_background_tile>
   <statuses_count>126</statuses_count>
   <notifications/>
   <verified>false</verified>
   <following/>
   </user>
   </status>
 */ /*
   <user>
   <id>12070122</id>
   <name>Juga Paazmaya</name>
   <screen_name>paazmaya</screen_name>
   <location>Finland</location>
   <description/>
   <profile_image_url>http://a1.twimg.com/profile_images/117273364/jukka-in-midair_normal.jpg</profile_image_url>
   <url>http://paazio.nanbudo.fi</url>
   <protected>false</protected>
   <followers_count>17</followers_count>
   <profile_background_color>0f89b8</profile_background_color>
   <profile_text_color>152a32</profile_text_color>
   <profile_link_color>0e43cd</profile_link_color>
   <profile_sidebar_fill_color>c6c4b9</profile_sidebar_fill_color>
   <profile_sidebar_border_color>000000</profile_sidebar_border_color>
   <friends_count>13</friends_count>
   <created_at>Thu Jan 10 13:48:34 +0000 2008</created_at>
   <favourites_count>0</favourites_count>
   <utc_offset>7200</utc_offset>
   <time_zone>Helsinki</time_zone>
   <profile_background_image_url>http://s.twimg.com/a/1250203207/images/themes/theme12/bg.gif</profile_background_image_url>
   <profile_background_tile>false</profile_background_tile>
   <statuses_count>126</statuses_count>
   <notifications/>
   <verified>false</verified>
   <following/>
   <status>
   <created_at>Mon Aug 24 06:51:23 +0000 2009</created_at>
   <id>3508234851</id>
   <text>How come helsinki.fi does not tell anything of this weeks "Helsinki Liikkeelle" event? Anyhow, Naginata for free today at 19:30 local time.</text>
   <source>web</source>
   <truncated>false</truncated>
   <in_reply_to_status_id/>
   <in_reply_to_user_id/>
   <favorited>false</favorited>
   <in_reply_to_screen_name/>
   </status>
   </user>
 */
