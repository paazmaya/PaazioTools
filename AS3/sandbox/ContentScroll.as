/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '500', height = '330')]

	public class ContentScroll extends Sprite
	{
		private var backGlow:Shape;
		private var slider:Sprite;
		private var slideRect:Rectangle;
		private var bar:Sprite;
		private var masker:Shape;
		private var content:Sprite;

		private var sliderDragged:Boolean = false;
		private var arrowUpperDown:Boolean = false;
		private var arrowLowerDown:Boolean = false;
		private var arrowDownTimer:Timer;

		[Embed(source = '../assets/ContentScrollSymbols.swf', symbol = 'Arrow')]
		private var Arrow:Class;
		[Embed(source = '../assets/ContentScrollSymbols.swf', symbol = 'Bar')]
		private var Bar:Class;
		[Embed(source = '../assets/ContentScrollSymbols.swf', symbol = 'Slider')]
		private var Slider:Class;

		public function ContentScroll()
		{
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
			
		private function onInit(event:Event):void
		{
			backGlow = new Shape();
			addChild(backGlow);

			bar = new Bar() as Sprite;
			bar.x = 20;
			bar.y = 20;
			addChild(bar);

			var upper:Sprite = new Arrow() as Sprite;
			upper.name = "upper";
			upper.buttonMode = true;
			upper.x = 20;
			upper.y = bar.y - upper.height / 2;
			upper.addEventListener(MouseEvent.MOUSE_DOWN, onArrowMouse);
			upper.addEventListener(MouseEvent.MOUSE_UP, onArrowMouse);
			addChild(upper);

			var lower:Sprite = new Arrow() as Sprite;
			lower.name = "lower";
			lower.buttonMode = true;
			lower.x = 20;
			lower.y = upper.y + upper.height + bar.height;
			lower.scaleY = -1;
			lower.addEventListener(MouseEvent.MOUSE_DOWN, onArrowMouse);
			lower.addEventListener(MouseEvent.MOUSE_UP, onArrowMouse);
			addChild(lower);

			content = new Sprite();
			content.x = 50;
			content.y = 10;
			addChild(content);

			masker = new Shape();
			masker.x = content.x;
			masker.y = content.y;
			addChild(masker);

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			loader.load(new URLRequest("http://paazio.nanbudo.fi/img/0165_m.jpg"));
			content.addChild(loader);

			slider = new Slider() as Sprite;
			slider.buttonMode = true;
			slider.x = bar.x;
			slider.y = bar.y + slider.height / 2;
			slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderMouse);
			slider.addEventListener(MouseEvent.MOUSE_UP, onSliderMouse);
			addChild(slider);

			slideRect = new Rectangle(bar.x, bar.y + slider.height / 2, 0, bar.height - slider.height);

			arrowDownTimer = new Timer(60);
			arrowDownTimer.addEventListener(TimerEvent.TIMER, onArrowTimer);

			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onStageAdded(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
		}

		private function onLoad(event:Event):void
		{
			masker.graphics.clear();
			masker.graphics.beginFill(0xFF6633);
			masker.graphics.drawRoundRect(0, 0, content.width, bar.height + 20, 24, 24);
			masker.graphics.endFill();
			content.mask = masker;

			backGlow.x = masker.x - 2;
			backGlow.y = masker.y - 2;
			backGlow.graphics.beginFill(0xFFFFFF);
			backGlow.graphics.drawRoundRect(0, 0, masker.width + 4, masker.height + 4, 24, 24);
			backGlow.graphics.endFill();
			backGlow.filters = [new GlowFilter(0xFFFFFF, 1, 20, 20)];
		}

		private function onSliderMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				slider.startDrag(false, slideRect);
				sliderDragged = true;
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				slider.stopDrag();
				sliderDragged = false;
			}
		}

		private function onStageMouseUp(event:MouseEvent):void
		{
			if (event.eventPhase != EventPhase.BUBBLING_PHASE && sliderDragged)
			{
				slider.stopDrag();
				sliderDragged = false;
			}
		}

		private function onArrowMouse(event:MouseEvent):void
		{
			var cur:Sprite = event.target as Sprite;

			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				if (cur.name == "lower")
				{
					arrowLowerDown = true;
				}
				else if (cur.name == "upper")
				{
					arrowUpperDown = true;
				}
				arrowDownTimer.start();
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				arrowUpperDown = false;
				arrowLowerDown = false;
				arrowDownTimer.stop();
			}
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			slider.y -= event.delta * 2;
			checkLimits();
		}

		private function checkLimits():void
		{
			if (slider.y > slideRect.y + slideRect.height)
			{
				slider.y = slideRect.y + slideRect.height;
			}
			else if (slider.y < slideRect.y)
			{
				slider.y = slideRect.y;
			}
		}

		private function onArrowTimer(event:TimerEvent):void
		{
			if (arrowUpperDown)
			{
				slider.y -= 10;
			}
			else if (arrowLowerDown)
			{
				slider.y += 10;
			}
			checkLimits();
		}

		private function onEnterFrame(event:Event):void
		{
			content.y = ((slider.y - slideRect.y) / slideRect.height) * (masker.height - content.height) + masker.y;
		}
	}
}
