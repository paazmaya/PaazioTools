/**
 * @mxmlc -target-player=10.0.0
 */
package sandbox
{
    import flash.display.*;
    import flash.events.*;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	import org.paazio.lang.Japanese;
	
	import com.greensock.TweenLite;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '300')]

	/**
	 * Kanas are moving randomly. Click on each per the sound.
	 * @license http://creativecommons.org/licenses/by-sa/3.0/
	 * @author Juga Paazmaya
	 * @see http://paazio.nanbudo.fi
	 */
    public class KanaAudioTest extends Sprite
	{
		private const MARGIN:Number = 10;
		private const RADIUS:Number = 20;
		private const INTERVAL:Number = 200;
		private const TWEEN_TIME:Number = 3.0;
		
		[Embed(source = "../assets/maru_hira-kata-roma_only.ttf", fontFamily = "marukana")]
		private var Maru:String;
		
		// http://thejapanesepage.com/beginners/hiragana
		[Embed(source = "../assets/aiueo.mp3")]
		private var Aiueo:Class;
		
		// http://www.kanji.org/kanji/japanese/kanaroma/kanaroma.htm
		
		private var _container:Sprite;
		private var _timer:Timer;
		private var _mouseTarget:Sprite;
		private var _tweens:Dictionary;
		private var _calledKana:String = ""; // hira_ka0 == か
		private var _freePoints:Vector.<Point>;
		private var _sound:Sound;
		private var _audioData:ByteArray;

        public function KanaAudioTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			_container = new Sprite();
			addChild(_container);
			
			_tweens = new Dictionary();
			_freePoints = new Vector.<Point>();
			_audioData = new ByteArray();
			_sound = new Aiueo() as Sound;
			_sound.extract(_audioData, _sound.length);
			
			drawItems();
			
			_timer = new Timer(INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        }

		private function drawItems():void
		{
			_container.graphics.clear();
			_container.graphics.lineStyle(2, 0xE3E3C9);
			_container.graphics.drawRoundRect(MARGIN, MARGIN, stage.stageWidth - MARGIN * 2, stage.stageHeight - MARGIN * 2, RADIUS);
			
			var num:uint = _container.numChildren;
			while (num > 0)
			{
				--num;
				_container.removeChildAt(num);
			}
			
			var numH:Number = (stage.stageWidth - MARGIN * 2 - RADIUS * 2) / 12;
			var numV:Number = (stage.stageHeight - MARGIN * 2 - RADIUS * 2) / 9;
			for (var i:uint = 0; i < 12; ++i)
			{
				for (var j:uint = 0; j < 9; ++j)
				{
					var point:Point = new Point(MARGIN + RADIUS + i * numH + numH / 2, MARGIN + RADIUS + j * numV + numV / 2);
					_freePoints.push(point);
				}
			}
			
			for (var kana:String in Japanese.hiragana)
			{
				var sp:Sprite = new Sprite();
				sp.name = "hira_" + kana;
				sp.mouseChildren = false;
				sp.addEventListener(MouseEvent.MOUSE_DOWN, onKanaMouse);
				sp.addEventListener(MouseEvent.MOUSE_UP, onKanaMouse);
				
				var field:TextField = createField(RADIUS, Japanese.hiragana[kana]);
				field.x = -field.width / 2;
				field.y = -field.height / 2;
				sp.addChild(field);
				
				var gra:Graphics = sp.graphics;
				gra.lineStyle(1, 0x8B8C7D);
				gra.beginFill(0x961D18);
				gra.drawCircle(0, 0, RADIUS);
				gra.endFill();
				
				var pos:Point = _freePoints.shift();
				sp.x = pos.x;
				sp.y = pos.y;
				
				//sp.x = Math.random() * (stage.stageWidth - MARGIN * 2 - sp.width) + MARGIN + sp.width / 2;
				//sp.y = Math.random() * (stage.stageHeight - MARGIN * 2 - sp.height) + MARGIN + sp.height / 2;
				_container.addChild(sp);
			}
		}
		
		private function onKanaMouse(event:MouseEvent):void
		{
			var sp:Sprite = event.target as Sprite;
			_container.setChildIndex(sp, _container.numChildren - 1);
			var tween:TweenLite = _tweens[sp] as TweenLite;
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				_mouseTarget = sp;
				if (tween != null)
				{
					tween.pause();
				}
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				_mouseTarget = null;
				if (tween != null)
				{
					tween.resume();
				}
				checkCorrect(sp);
			}
		}
		
		private function onStageMouseUp(event:MouseEvent):void
		{
			if (_mouseTarget != null)
			{
				var tween:TweenLite = _tweens[_mouseTarget] as TweenLite;
				if (tween != null)
				{
					tween.resume();
				}
				checkCorrect(_mouseTarget);
				_mouseTarget = null;
			}
		}
		
		private function checkCorrect(sp:Sprite):void
		{
			trace("checkCorrect. sp: " + sp.name);
			if (sp.name == _calledKana)
			{
				var gra:Graphics = sp.graphics;
				gra.clear();
				gra.lineStyle(1, 0x8B8C7D);
				gra.beginFill(0x1D1896);
				gra.drawCircle(0, 0, RADIUS);
				gra.endFill();
			}
		}
		
		
		private function onTimer(event:TimerEvent):void
		{
			var index:uint = Math.round(Math.random() * (_container.numChildren - 1));
			var sp:Sprite = _container.getChildAt(index) as Sprite;
			_container.setChildIndex(sp, 0);
			
			// Move only one item at a time and it is not clicked right now.
			if (_tweens[sp] == null && _mouseTarget != sp)
			{
				var point:Point = new Point(sp.x, sp.y);
				_freePoints.push(point);
				point = _freePoints.shift();
				_tweens[sp] = TweenLite.to(sp, TWEEN_TIME, { x: point.x, y: point.y, onComplete: onTweenComplete, onCompleteParams: [sp] } );
				
				//var xPos:Number = Math.random() * (stage.stageWidth - MARGIN * 2 - sp.width) + MARGIN + sp.width / 2;
				//var yPos:Number = Math.random() * (stage.stageHeight - MARGIN * 2 - sp.height) + MARGIN + sp.height / 2;
				//var scale:Number = Math.random() * 0.5 + 0.75;
				//_tweens[sp] = TweenLite.to(sp, TWEEN_TIME, { x: xPos, y: yPos, scaleX: scale, scaleY: scale } );
			}
		}
		
		private function onTweenComplete(sp:Sprite):void
		{
			delete _tweens[sp];
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				drawItems();
			}
		}
		
		private function createField(size:Number, text:String):TextField
		{
			var format:TextFormat = new TextFormat();
			format.font = "marukana";
			format.size = size;
			format.align = TextFormatAlign.CENTER;
			format.color = 0xE3E3C9;
			
			var field:TextField = new TextField();
			field.defaultTextFormat = format;
			field.embedFonts = true;
			field.selectable = false;
			field.width = size * 1.2;
			field.height = size * 1.2;
			field.text = text;
			return field;
		}
    }
}
