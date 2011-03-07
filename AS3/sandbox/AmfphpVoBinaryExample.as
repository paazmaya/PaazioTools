/*
	AmfphpVoBinaryExample.as
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
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import vos.Canvas;
	import vos.Stroke;
	
	/**
	 * Example of moving VO's encoded as ByteArray data through AMFPHP.
	 * Requires AMFPHP package plus PHP service file "VoBinaryExampleService.php".
	 * See blog for further explanation.
	 */

	[SWF(backgroundColor = '0x042836', frameRate = '60', width = '900', height = '700')]
	
	public class AmfphpVoBinaryExample extends Sprite
	{
    	public static const GATEWAY_URL:String = "http://localhost/amfphp/gateway.php";
		
		private var netConnection:NetConnection;
		private var responder:Responder;
		
		private var recordCursor:int;
		private var numberOfRecords:int;

		
		public function AmfphpVoBinaryExample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void 
		{
			initUi();

			// !IMPORTANT
			registerClassAlias( "vos::Canvas", Canvas );
			registerClassAlias( "vos::Stroke", Stroke );
			
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF3;
			
			netConnection = new NetConnection();
	        netConnection.connect(GATEWAY_URL);
	
	        getNumberOfRecords();
		}
		
		
		// =====================================================
		// SAVE DATA
		// =====================================================
		
		private function saveData():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(userCanvas);
			byteArray.compress();
			
			 responder = new Responder(onSaveResult, onFault);
			 netConnection.call("VoBinaryExampleService.save", responder, byteArray);
			
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
				// Fail
				showMessage("An error occurred: " + s, true);
			else
			{
				// Success
				showMessage("Imaged saved to record " + num.toString(), true);
				numberOfRecords = num;
				tfNum.text = recordCursor + " of " + numberOfRecords;
				
				resetUserCanvas();
			}
		}
		
		// =====================================================
		// LOAD DATA
		// =====================================================
		
		private function loadData():void
		{
			responder = new Responder(onLoadResult, onFault);
			netConnection.call("VoBinaryExampleService.load", responder, recordCursor);

			tfNum.text = "Loading...";
			mouseEnabled = mouseChildren = false;
		}
		

		/**
		 * @param $result 	Expecting either a ByteArray
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
			
			ba.uncompress();
			loadedCanvas = ba.readObject() as Canvas;
			
			if (! loadedCanvas || ! loadedCanvas.strokes)
			{
				// Fail
				showMessage("An error occurred. Ugh.", true);
				return;
			}

			// Success
			
			tfNum.text = recordCursor + " of " + numberOfRecords;
			mouseEnabled = mouseChildren = true;
			
			playback();
		}
		
		// =====================================================
		// GET NUMBER OF RECORDS
		// =====================================================
		
		private function getNumberOfRecords():void
		{
			 responder = new Responder(onGetNumberOfRecordsResult, onFault);
			 netConnection.call("VoBinaryExampleService.getNumberOfRecords", responder);

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
		// UI STUFF, RECORDING/PLAYBACK LOGIC,
		// NOT AS IMPORTANT TO EXAMINE FOR PURPOSES OF TUTORIAL
		// =====================================================
		
		private var tfMessage:TextField;
		private var sprUserCanvas:Sprite;
		private var btnNew:Sprite;
		private var btnSave:Sprite;
		private var sprLoadedCanvas:Sprite;
		private var btnPrevious:Sprite;
		private var btnNext:Sprite;
		private var btnFirst:Sprite;
		private var btnLast:Sprite;
		private var tfNum:TextField;
		private var swatch1:Sprite;
		private var swatch2:Sprite;
		private var swatch3:Sprite;


		private function initUi():void
		{
			tfMessage = new TextField();
			tfMessage.width = 250;
			tfMessage.height = 40;
			tfMessage.x = 20;
			tfMessage.y = 6;
			tfMessage.defaultTextFormat = new TextFormat("_sans", null,null,null,null,null,null,null,"center");
			tfMessage.text = "AMFPHP VO/Binary Example";
			tfMessage.multiline = tfMessage.wordWrap = true;
			addChild(tfMessage);
			
			sprUserCanvas = new Sprite();
			sprUserCanvas.x = 20
			sprUserCanvas.y = 50;
			sprUserCanvas.buttonMode = true;
			sprUserCanvas.addEventListener(MouseEvent.MOUSE_DOWN, onCanvasMouseDown);
			sprUserCanvas.addEventListener(Event.ENTER_FRAME, onCanvasEnterFrame);
			addChild(sprUserCanvas);

			btnNew = makeButton("New canvas");
			btnNew.x = 20;
			btnNew.y = 260;
			btnNew.addEventListener(MouseEvent.CLICK, onNewClick);
			addChild(btnNew);

			btnSave = makeButton("Save");
			btnSave.x = 270 - btnSave.width;
			btnSave.y = 260;
			btnSave.addEventListener(MouseEvent.CLICK, onSaveClick);
			addChild(btnSave);

			swatch1 = new Sprite();
			swatch1.addEventListener(MouseEvent.CLICK, onSwatch1Click);
			addChild(swatch1);
			
			swatch2 = new Sprite();
			swatch2.addEventListener(MouseEvent.CLICK, onSwatch2Click);
			addChild(swatch2);
			
			swatch3 = new Sprite();
			swatch3.addEventListener(MouseEvent.CLICK, onSwatch3Click);
			addChild(swatch3);
			
			swatch1.buttonMode = swatch2.buttonMode = swatch3.buttonMode = true;
			swatch1.y = swatch2.y = swatch3.y = 260;
			swatch1.x = btnNew.x + btnNew.width + 27;
			swatch2.x = swatch1.x + 28;
			swatch3.x = swatch2.x + 28;
			
			//
			
			sprLoadedCanvas = new Sprite();
			sprLoadedCanvas.x = 20;
			sprLoadedCanvas.y = 310;
			sprLoadedCanvas.graphics.beginFill(0xffffff);
			sprLoadedCanvas.graphics.drawRect(0,0,250,200);
			sprLoadedCanvas.graphics.endFill();
			addChild(sprLoadedCanvas);

			btnFirst = makeButton("|<");
			btnFirst.x = 20;
			btnFirst.y = 520;
			btnFirst.addEventListener(MouseEvent.CLICK, onFirstClick);
			addChild(btnFirst);

			btnPrevious = makeButton("<");
			btnPrevious.x = btnFirst.x + btnFirst.width + 5;
			btnPrevious.y = 520;
			btnPrevious.addEventListener(MouseEvent.CLICK, onPreviousClick);
			addChild(btnPrevious);

			btnLast = makeButton(">|");
			btnLast.x = 270 - btnLast.width;
			btnLast.y = 520;
			btnLast.addEventListener(MouseEvent.CLICK, onLastClick);
			addChild(btnLast);
			
			btnNext = makeButton(">");
			btnNext.x = btnLast.x - btnNext.width - 5;
			btnNext.y = 520;
			btnNext.addEventListener(MouseEvent.CLICK, onNextClick);
			addChild(btnNext);
			
			tfNum = new TextField();
			tfNum.width = 80;
			tfNum.height = 20;
			tfNum.x = 100;
			tfNum.y = 523;
			tfNum.defaultTextFormat = new TextFormat("_sans", null,null,null,null,null,null,null,"center");
			addChild(tfNum);
			
			graphics.beginFill(0xe5e5e5);
			graphics.drawRect(15,45, 260, 245);
			graphics.endFill();

			graphics.beginFill(0xe5e5e5);
			graphics.drawRect(15,305, 260, 245);
			graphics.endFill();
			
			showMessage("AMFPHP VO + Binary Example\rCreate drawing below",true);
			resetUserCanvas();
		}
		
		private function resetUserCanvas():void
		{
			sprUserCanvas.graphics.clear();
			sprUserCanvas.graphics.beginFill(0xffffff);
			sprUserCanvas.graphics.drawRect(0,0,250,200);
			sprUserCanvas.graphics.endFill();

			userCanvas = new Canvas();
			userCanvas.strokes = [];
			saveFrameNum = 0;
			strokeThickness = 2;
			
			var u:uint = int(Math.random()*0xffffff);
			swatch1.name = u.toString(); // heh
			drawSwatch(swatch1, u);
			strokeColor = u;
			
			u = int(Math.random()*0xffffff);
			swatch2.name = u.toString();
			drawSwatch(swatch2, u);
			
			u = int(Math.random()*0xffffff);
			swatch3.name = u.toString();
			drawSwatch(swatch3, u);
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
		
		private function drawSwatch($s:Sprite, $col:uint):void
		{
			$s.graphics.beginFill($col);
			$s.graphics.drawRect(0,0,24,24);
			$s.graphics.endFill();
		}

		private function showMessage($s:String, $mouseEnabled:Boolean):void
		{
			tfMessage.text = $s;
			mouseEnabled = mouseChildren = $mouseEnabled;
		}
		
		
		private function onNewClick($event:Event):void
		{
			showMessage("Create drawing below:",true);
			resetUserCanvas();
		}

		private function onSaveClick($event:Event):void
		{
			if (userCanvas.strokes.length == 0) return;
			
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
		
		private function onSwatch1Click($event:Event):void
		{
			strokeColor = parseInt($e.target.name) || 0x00;
		}
		private function onSwatch2Click($event:Event):void
		{
			strokeColor = parseInt($e.target.name) || 0x00;
		}
		private function onSwatch3Click($event:Event):void
		{
			strokeColor = parseInt($e.target.name) || 0x00;
		}
		
		// =============================================================
		// 'RECORDING' LOGIC
		// =============================================================
		
		private const MAXSTROKES:int = 1000;
		private var strokeThickness:int;
		private var strokeColor:uint;
		private var isRecording:Boolean;
		private var lastPos:Point;
		private var saveFrameNum:int;
		private var userCanvas:Canvas;
		
		
		private function onCanvasMouseDown($event:Event):void
		{
			lastPos = new Point(sprUserCanvas.mouseX, sprUserCanvas.mouseY);
			sprUserCanvas.addEventListener(MouseEvent.MOUSE_UP, onCanvasMouseUp);
			sprUserCanvas.addEventListener(MouseEvent.ROLL_OUT, onCanvasMouseUp);
			
			sprUserCanvas.graphics.lineStyle(strokeThickness, strokeColor);
		}
		
		private function onCanvasEnterFrame($event:Event):void
		{
			saveFrameNum++;
			
			if (!lastPos) return;
			if (userCanvas.strokes.length > MAXSTROKES) return;
			
			if (sprUserCanvas.mouseX != lastPos.x || sprUserCanvas.mouseY != lastPos.y)
			{
				if (userCanvas.strokes.length == 0) saveFrameNum = 0;
				
				var s:Stroke = new Stroke();
				s.xFrom = lastPos.x;
				s.yFrom = lastPos.y;
				s.xTo = sprUserCanvas.mouseX;
				s.yTo = sprUserCanvas.mouseY;
				s.color = strokeColor;
				s.thickness = strokeThickness;
				s.frameNum = saveFrameNum;
				userCanvas.strokes.push(s);
				
				sprUserCanvas.graphics.moveTo(lastPos.x, lastPos.y);
				sprUserCanvas.graphics.lineTo(sprUserCanvas.mouseX, sprUserCanvas.mouseY);
				
				lastPos = new Point(sprUserCanvas.mouseX, sprUserCanvas.mouseY);
			}
			
			if ( int(userCanvas.strokes.length / MAXSTROKES * 100) % 10 == 0 && int((userCanvas.strokes.length-1) / MAXSTROKES * 100) % 10 != 0)
				showMessage( int(userCanvas.strokes.length / MAXSTROKES * 100).toString() + '% full', true);
		}
		
		private function onCanvasMouseUp($event:Event):void
		{
			lastPos = null;
		}
		
		
		// =============================================================
		// PLAYBACK LOGIC
		// =============================================================

		private var loadedCanvas:Canvas;
		private var playFrameNum:int;
		private var playCursor:int;
		
		
		private function playback():void
		{
			playCursor = 0;
			playFrameNum = Stroke(loadedCanvas.strokes[0]).frameNum - 1;
			sprLoadedCanvas.addEventListener(Event.ENTER_FRAME, onPlaybackEnterFrame);
		}
		
		private function onPlaybackEnterFrame($event:Event):void
		{
			if (playCursor == 0)
			{
				sprLoadedCanvas.graphics.lineStyle();
				sprLoadedCanvas.graphics.beginFill(0xffffff);
				sprLoadedCanvas.graphics.drawRect(0,0,250,200);
				sprLoadedCanvas.graphics.endFill();
			}
			
			playFrameNum++;
			
			var s:Stroke = loadedCanvas.strokes[playCursor];
			if (s.frameNum == playFrameNum)
			{
				sprLoadedCanvas.graphics.lineStyle(s.thickness, s.color);
				sprLoadedCanvas.graphics.moveTo(s.xFrom, s.yFrom);
				sprLoadedCanvas.graphics.lineTo(s.xTo, s.yTo);
				
				playCursor++;
				
				if (playCursor >= loadedCanvas.strokes.length)
			{
					sprLoadedCanvas.removeEventListener(Event.ENTER_FRAME, onPlaybackEnterFrame);
					return;
				}
				
				if (playCursor + 1 < loadedCanvas.strokes.length)
			{
					// Don't pause more than 30 frames
					var nextFrame:int = Stroke(loadedCanvas.strokes[playCursor]).frameNum;
					if (nextFrame - s.frameNum > 30) playFrameNum = nextFrame - 30;
				}
			}
		}
	}
}
