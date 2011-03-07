/*
	AmfphpBinaryExample.as
	Lee Felarca
	http://www.zeropointnine.com/blog
	1-2009
		
	Source code licensed under a Creative Commons Attribution 3.0 License.
	http://creativecommons.org/licenses/by/3.0/
	Some Rights Reserved.
 */

package sandbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	
	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]
	
	/**
	 * Example of moving ByteArray data through AMFPHP.
	 * Requires AMFPHP package plus PHP service file "BinaryExampleService.php".
	 * See blog for further explanation.
	 */
	public class AmfphpBinaryExample extends Sprite
	{
    	public static const GATEWAY_URL:String = "http://www.zeropointnine.com/blog/assets/amfphpBinaryExamples/amfphp/gateway.php";
		
		private var netConnection:NetConnection;
		private var responder:Responder;
		
		private var recordCursor:int;
		private var numberOfRecords:int;

		
		public function AmfphpBinaryExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
			initUi();
			
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF3;
			
			netConnection = new NetConnection();
	        netConnection.connect(GATEWAY_URL);
	
	        getNumberOfRecords();
		}
		
		// =====================================================
		// SAVE IMAGE
		// =====================================================
		
		private function saveData():void
		{
			var byteArray:ByteArray = makeJpeg(sprImage);
			
			 // Save to database
			 responder = new Responder(onSaveResult, onFault);
			 netConnection.call("BinaryExampleService.save", responder, byteArray);
			
			 showMessage("Saving...", false);;
		}
		

		/**
		 * @param $result 	We're expecting either the index of the record that
		 * 					was inserted, or a string with some error info.
		 */
		private function onSaveResult($result:Object):void
		{
			var s:String = $result.toString();
			var num:Number = parseInt(s);
			
			if (isNaN(num))
			{
				// Fail
				showMessage("An error occurred: " + s, true);
			}
			else  {
				// Success
				showMessage("Imaged saved to record " + num.toString(), true);
				numberOfRecords = num;
				tfNum.text = recordCursor + " of " + numberOfRecords;
			}
		}
		
		// =====================================================
		// LOAD IMAGE
		// =====================================================
		
		private function loadData():void
		{
			responder = new Responder(onLoadResult, onFault);
			netConnection.call("BinaryExampleService.load", responder, recordCursor);

			tfNum.text = "Loading...";
			mouseEnabled = mouseChildren = false;
		}
		

		/**
		 * @param $result 	We're expecting either a ByteArray
		 * 					or a string with some error info.
		 */
		private function onLoadResult($result:Object):void
		{
			if (! ($result is ByteArray) && $result.data)
			{
				// Fail
				showMessage("Result is not a ByteArray. Check AMFPHP 'encoding' property", true);
				return;
			}
			
			var ba:ByteArray = $result as ByteArray;
			if (! ba)
			{
				// Fail
				showMessage("An error occurred: " + $result.toString(), true);
				return;
			}

			// Load JPEG ByteArray with Loader
			// (If we'd saved the image data as a ByteArray converted
			// directly from BitmapData, this step wouldn't be necessary)
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onByteArrayLoaded)
			loader.loadBytes(ba);
		}
		
		private function onByteArrayLoaded(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onByteArrayLoaded);

			var bitmapData:BitmapData = Bitmap(event.target.content).bitmapData;
			
			sprLoaded.graphics.clear();
			sprLoaded.graphics.beginBitmapFill(bitmapData);
			sprLoaded.graphics.drawRect(0,0,bitmapData.width, bitmapData.height);
			sprLoaded.graphics.endFill();
			
			tfNum.text = recordCursor + " of " + numberOfRecords;
			mouseEnabled = mouseChildren = true;
		}
		
		// =====================================================
		// GET NUMBER OF RECORDS
		// =====================================================
		
		private function getNumberOfRecords():void
		{
			 responder = new Responder(onGetNumberOfRecordsResult, onFault);
			 netConnection.call("BinaryExampleService.getNumberOfRecords", responder);

			 // Disable UI during asynchronous operation...
			 mouseEnabled = mouseChildren = false;
		}
		
		/**
		 * @param $result 	We're expecting either the number of records in the table,
		 * 					or a string with some error info.
		 */
		private function onGetNumberOfRecordsResult($result:Object):void
		{
			if (!$result)
			{
				// Fail
				numberOfRecords = 0;
				tfNum.text = recordCursor + " of " + numberOfRecords;
			 	mouseEnabled = mouseChildren = true;
				return;
			}

			var s:String = $result.toString();
			var num:Number = parseInt(s);
			
			if (isNaN(num))
			{
				// Fail
				showMessage("An error occurred: " + s, true);
			}
			else {
				// Success
				numberOfRecords = num;
				tfNum.text = recordCursor + " of " + numberOfRecords;
			 	mouseEnabled = mouseChildren = true;
			}
		}

		// =====================================================
		// NETCONNECTION FAULT HANDLER
		// =====================================================

		private function onFault($fault:Object):void
		{
			showMessage("A fault occurred: " + $fault.description, true);
			for (var s:String in $fault) trace(s, $fault[s]);
		}
		
		
		// =====================================================
		// MOSTLY PROSAIC UI STUFF, NOT AS IMPORTANT TO GROK
		// FOR PURPOSES OF TUTORIAL ...
		// =====================================================
		
		private var tfMessage:TextField;
		private var sprImage:Sprite;
		private var btnNew:Sprite;
		private var btnSave:Sprite;
		private var sprLoaded:Sprite;
		private var btnPrevious:Sprite;
		private var btnNext:Sprite;
		private var btnFirst:Sprite;
		private var btnLast:Sprite;
		private var tfNum:TextField;


		private function initUi():void
		{
			tfMessage = new TextField();
			tfMessage.width = 250;
			tfMessage.height = 40;
			tfMessage.x = 20;
			tfMessage.y = 12;
			tfMessage.defaultTextFormat = new TextFormat("_sans", null,null,null,null,null,null,null,"center");
			tfMessage.multiline = tfMessage.wordWrap = true;
			addChild(tfMessage);
			
			sprImage = new Sprite();
			sprImage.x = 20
			sprImage.y = 50;
			addChild(sprImage);
			drawOnSprite();

			btnNew = makeButton("Make a new image");
			btnNew.x = 20;
			btnNew.y = 160;
			btnNew.addEventListener(MouseEvent.CLICK, onNewClick);
			addChild(btnNew);

			btnSave = makeButton("Save");
			btnSave.x = 270 - btnSave.width;
			btnSave.y = 160;
			btnSave.addEventListener(MouseEvent.CLICK, onSaveClick);
			addChild(btnSave);

			sprLoaded = new Sprite();
			sprLoaded.x = 20;
			sprLoaded.y = 210;
			sprLoaded.graphics.beginFill(0x888888);
			sprLoaded.graphics.drawRect(0,0,250,100);
			sprLoaded.graphics.endFill();
			addChild(sprLoaded);

			btnFirst = makeButton("|<");
			btnFirst.x = 20;
			btnFirst.y = 320;
			btnFirst.addEventListener(MouseEvent.CLICK, onFirstClick);
			addChild(btnFirst);

			btnPrevious = makeButton("<");
			btnPrevious.x = btnFirst.x + btnFirst.width + 5;
			btnPrevious.y = 320;
			btnPrevious.addEventListener(MouseEvent.CLICK, onPreviousClick);
			addChild(btnPrevious);

			btnLast = makeButton(">|");
			btnLast.x = 270 - btnLast.width;
			btnLast.y = 320;
			btnLast.addEventListener(MouseEvent.CLICK, onLastClick);
			addChild(btnLast);
			
			btnNext = makeButton(">");
			btnNext.x = btnLast.x - btnNext.width - 5;
			btnNext.y = 320;
			btnNext.addEventListener(MouseEvent.CLICK, onNextClick);
			addChild(btnNext);
			
			tfNum = new TextField();
			tfNum.width = 80;
			tfNum.height = 20;
			tfNum.x = 100;
			tfNum.y = 323;
			tfNum.defaultTextFormat = new TextFormat("_sans", null,null,null,null,null,null,null,"center");
			addChild(tfNum);
			
			graphics.beginFill(0xe5e5e5);
			graphics.drawRect(15,45, 260, 145);
			graphics.endFill();

			graphics.beginFill(0xe5e5e5);
			graphics.drawRect(15,205, 260, 145);
			graphics.endFill();
		}
		
		private function drawOnSprite():void
		{
			sprImage.graphics.clear();
			sprImage.graphics.beginFill(0x00);
			sprImage.graphics.drawRect(0,0,250,100);
			sprImage.graphics.endFill();
			
			var color:uint;
			var num:int = (5 + int(Math.random() * 10)) * 3;
			for (var i:int = 0; i < num; ++i)
			{
				if (i % (num/3) == 0) color = int(Math.random()*0xffffff);
				sprImage.graphics.beginFill(color);
				sprImage.graphics.drawCircle(20+Math.random()*210, 20+Math.random()*60, 5+Math.random()*15);
				sprImage.graphics.endFill();
			}
			
			showMessage("AMFPHP Binary Example",true);
		}
				
		private function makeButton($s:String):Sprite
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("_sans", null,null,null,null,null,null,null,"center");
			tf.text = $s;
			tf.width = tf.textWidth + 5;
			tf.height = tf.textHeight + 3;
			tf.x = tf.y = 3;
			tf.mouseEnabled = false;
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xaaaaaa);
			s.graphics.drawRect(0, 0, tf.width + 6,tf.height + 6);
			s.graphics.endFill();
			s.buttonMode = true;
			s.addChild(tf);
			
			return s;
		}

		private function makeJpeg($s:Sprite):ByteArray
		{
			var bitmapData:BitmapData = new BitmapData($s.width, $s.height, false);
			bitmapData.draw(sprImage);
			var jpegEnc:JPEGEncoder = new JPEGEncoder();
			return jpegEnc.encode(bitmapData);
		}
		
		private function showMessage($s:String, $mouseEnabled:Boolean):void
		{
			tfMessage.text = $s;
			mouseEnabled = mouseChildren = $mouseEnabled;
		}
		
		
		private function onNewClick($event:Event):void
		{
			drawOnSprite();
		}
				
		private function onSaveClick($event:Event):void
		{
			saveData();
		}
		
		private function onPreviousClick($event:Event):void
		{
			if (recordCursor <= 1) return;
			recordCursor--;
			loadData();
			
		}
		private function onNextClick($event:Event):void
		{
			if (recordCursor >= numberOfRecords) return;
			recordCursor++;
			loadData();
		}
		
		private function onFirstClick($event:Event):void
		{
			if (numberOfRecords < 1) return;
			recordCursor = 1;
			loadData();
		}
		private function onLastClick($event:Event):void
		{
			if (numberOfRecords < 1) return;
			recordCursor = numberOfRecords;
			loadData();
		}
	}
}
