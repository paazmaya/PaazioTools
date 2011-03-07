/**
 * @mxmlc -target-player=10.0.0 -debug
 */
/**
 * Katakana / Hiragana learning tool
 * Jukka Paasonen
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.text.*;
	
	import org.paazio.utils.Numbers;
	import org.paazio.lang.Japanese;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '900', height = '700')]

	public class KanaLearner extends Sprite
	{

		[Embed(source = "../assets/maru_hira-kata-roma_only.ttf", fontFamily = "maru")]
		public var Maru:String;

		// Settings
		private var colors:Object =
		{
			fill: 0xFBFBFB,
			outline: 0x000000,
			text: 0x2B2B2B,
			hover: 0xCBCBCB
		};
		private var locations:Object =
		{
			bTop: 50,
			bLeft: 20,
			bMargin: 2
		};
		private var volume:Number = 60;

		private var gridCont:Sprite;
		private var gSound:Sound = new Sound();
		private var playSound:Boolean = false;
		private var points:Number = 0;
		private var started:Date;
		private var usedItems:Array = [];

		public function KanaLearner()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			drawGradientBack();
		}

		private function drawGradientBack():void
		{
			var gra:Graphics = graphics;
			gra.clear();

			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xDCB51B, 0xC6B9B0];
			var alphas:Array = [100, 100];
			var ratios:Array = [0, 0xFF];
			var spreadMethod:String = SpreadMethod.REFLECT;
			var interpolationMethod:String = InterpolationMethod.LINEAR_RGB;
			var focalPointRatio:Number = 0.9;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth / 2, stage.stageHeight / 2, Math.PI);
			
			gra.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			gra.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			gra.endFill();
		}

		private function createKanaButton(parent:Sprite, txtIndex:String, txtObj:Object, bWidth:Number, bHeight:Number, colors:Object):Sprite
		{

			var backg:Sprite = new Sprite();
			drawShape4(backg.graphics, bWidth, bHeight, bWidth / 2, bHeight / 2, colors, 5, 4);

			var txtfmt:TextFormat = new TextFormat();
			txtfmt.align = TextFormatAlign.LEFT;
			txtfmt.bold = false;
			txtfmt.color = colors.text;
			txtfmt.font = "maru";
			txtfmt.leftMargin = 0;
			txtfmt.rightMargin = 0;
			txtfmt.size = 14;

			//trace(txtIndex + " Txtfiled depth should be " + backg.getNextHighestDepth());
			var field:TextField = new TextField();
			field.autoSize = TextFieldAutoSize.LEFT;
			field.background = false;
			field.border = false;
			field.condenseWhite = true;
			field.embedFonts = true;
			field.maxChars = 3;
			field.mouseWheelEnabled = false;
			field.multiline = false;
			field.selectable = true;
			field.text = txtObj[txtIndex];
			field.wordWrap = true;
			field.defaultTextFormat = txtfmt;
			backg.addChild(field);

			/*
			backg.onRelease = function()
			{
				trace(charkey);
				//playKanaSound(charkey);
			};
			 */

			return backg;
		}

		// xPos, yPos give the center of the shape
		private function drawShape4(mc:Graphics, xPos:Number, yPos:Number, width:Number, height:Number, colors:Object, four:Number, eight:Number):void
		{
			// lineStyle(thickness:Number, rgb:Number, alpha:Number, pixelHinting:Boolean, noScale:String, capsStyle:String, jointStyle:String, miterLimit:Number)
			mc.lineStyle(1, colors.outline, 100);
			// beginFill(rgb:Number, [alpha:Number])
			// beginGradientFill(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object, [spreadMethod:String], [interpolationMethod:String], [focalPointRatio:Number])
			mc.beginFill(colors.fill, 100);
			mc.moveTo(xPos + width, yPos);
			// curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number)
			mc.curveTo(width + xPos, Math.tan(Math.PI / eight) * height + yPos, Math.sin(Math.PI / four) * width + xPos, Math.sin(Math.PI / four) * height + yPos);
			mc.curveTo(Math.tan(Math.PI / eight) * width + xPos, height + yPos, xPos, height + yPos);
			mc.curveTo(-Math.tan(Math.PI / eight) * width + xPos, height + yPos, -Math.sin(Math.PI / four) * width + xPos, Math.sin(Math.PI / four) * height + yPos);
			mc.curveTo(-width + xPos, Math.tan(Math.PI / eight) * height + yPos, -width + xPos, yPos);
			mc.curveTo(-width + xPos, -Math.tan(Math.PI / eight) * height + yPos, -Math.sin(Math.PI / four) * width + xPos, -Math.sin(Math.PI / four) * height + yPos);
			mc.curveTo(-Math.tan(Math.PI / eight) * width + xPos, -height + yPos, xPos, -height + yPos);
			mc.curveTo(Math.tan(Math.PI / eight) * width + xPos, -height + yPos, Math.sin(Math.PI / four) * width + xPos, -Math.sin(Math.PI / four) * height + yPos);
			mc.curveTo(width + xPos, -Math.tan(Math.PI / eight) * height + yPos, width + xPos, yPos);
			mc.endFill();
		}

		// xPos, yPos give the upper left corner
		private function drawBox4(mc:Graphics, xPos:Number, yPos:Number, height:Number, width:Number, colors:Object, doOutline:Boolean):void
		{
			if (doOutline)
			{
				mc.lineStyle(1, colors.outline, 100);
			}
			else
			{
				mc.beginFill(colors.fill, 100);
			}
			mc.moveTo(xPos, yPos);
			mc.lineTo(xPos + width, yPos);
			mc.lineTo(xPos + width, yPos + height);
			mc.lineTo(xPos, yPos + height);
			mc.lineTo(xPos, yPos);
			if (!doOutline)
			{
				mc.endFill();
			}
		}
	}
}

/*
// Create buttons for selecting kana type.
var hiragana_bt:MovieClip = createButton(createEmptyMovieClip("hiragana_bt", getNextHighestDepth()), 90, 20, colors, "Hiragana");
var katakana_bt:MovieClip = createButton(createEmptyMovieClip("katakana_bt", getNextHighestDepth()), 90, 20, colors, "Katakana");
var romaji_bt:MovieClip = createButton(createEmptyMovieClip("romaji_bt", getNextHighestDepth()), 90, 20, colors, "Romaji");

hiragana_bt._y = locations.bTop;
katakana_bt._y = hiragana_bt._y + hiragana_bt._height + locations.bMargin;
romaji_bt._y = katakana_bt._y + katakana_bt._height + locations.bMargin;

hiragana_bt._x = locations.bLeft;
katakana_bt._x = locations.bLeft;
romaji_bt._x = locations.bLeft;


// Create "preview" field for the character we are asking
var preview:MovieClip = createEmptyMovieClip("preview", getNextHighestDepth());
preview._y = locations.bTop;
preview._x = locations.bLeft + hiragana_bt._width + locations.bMargin * 10;
preview = createButton(preview, 80, 80, colors, "...");



// Text field for points and time
var points:TextField = createTextField("points", getNextHighestDepth(), romaji_bt._y + locations.bMargin, locations.bLeft, 400, 60);
//points.text = "Halloota talloon";

// Create start button
var start_bt:MovieClip = createEmptyMovieClip("start_bt", getNextHighestDepth());
start_bt._y = locations.bTop;
start_bt._x = preview._x + preview._width + locations.bMargin * 10;
start_bt = createButton(start_bt, 120, 20, colors, "Start testing");


// #######################################################################
// Button and other "on" based actions

hiragana_bt.onPress = chooseKanaSet;
katakana_bt.onPress = chooseKanaSet;
romaji_bt.onPress = chooseKanaSet;



gSound.onSoundComplete = function()
		{
	trace("Sound completed");
};

start_bt.onRelease = function()
		{
	started = new Date();
	_visible = false;
};


// #######################################################################
// Functions


function chooseKanaSet():void
		{
	var kana:String = _name.split("_")[0];
	trace(kana);
	gridCont.removeMovieClip();
	gridCont = createCharGrid(_root[kana], _root, 2, 25, 22, colors);
	gridCont._x = preview._x + preview._width + locations.bMargin * 10;
	gridCont._y = locations.bTop;
}

function createCharGrid(kana:Object, parent:MovieClip, margin:Number, bWidth:Number, bHeight:Number, colors:Object):MovieClip {
	var cont:MovieClip = parent.createEmptyMovieClip("cont", parent.getNextHighestDepth());

	var s:Number = 0;
	var k:Number = 0;

	for (var i in kana)
			{
		var clip:MovieClip = createKanaButton(cont, i, kana, bWidth, bHeight, colors);

		clip._x = k * (clip._width + margin);
		//trace("clip._width : " + clip._width);
		clip._y = s * (clip._height + margin);
		//trace("clip._height : " + clip._height);

		// Count the x location multiplier for next round
		if (s < 4)
			{
			if (i.substr(0, 1) == "y")
			{
				s += 2;
			}
			else if (i == "wa0")
			{
				s += 4;
			}
			else {
				s++;
			}
		}
		else {
			s = 0;
		}

		// Count the y location multiplier for nex round.
		if (i.substr(1, 1) == "o")
			{
			k++;
		}
	}

	return cont;
}


function createButton(clip:MovieClip, bWidth:Number, bHeight:Number, colors:Object, createText:String):MovieClip {
	// Create containers for the fill and for the outlines.
	//trace("Default value of createText is undefined, but now it is " + createText);

	var bgCont:MovieClip = clip.createEmptyMovieClip("bgfill", clip.getNextHighestDepth());
	var ouCont:MovieClip = clip.createEmptyMovieClip("outline", clip.getNextHighestDepth());

	if (createText != undefined)
			{
		var txtBt:TextField = clip.createTextField("txt", clip.getNextHighestDepth(), 0, 0, bWidth, bHeight);
		txtBt.text = createText;
		txtBt.size = Math.round(clip._height / 2);
	}

	// Draw background
	drawBox4(bgCont, 0, 0, bHeight, bWidth, colors, false);

	drawBox4(ouCont, 0, 0, bHeight, bWidth, colors, true);


	// When mouseover, change fill color. Change back when rollout.
	clip.onRollOver = function()
		{
		var clTr:ColorTransform = bgfill.transform.colorTransform;
		clTr.rgb = colors.hover;
		bgfill.transform.colorTransform = clTr;
		//trace("RollOver of " + this + ", clTr.rgb : " + clTr.rgb);
	};
	clip.onRollOut = function()
		{
		var clTr:ColorTransform = bgfill.transform.colorTransform;
		clTr.rgb = colors.fill;
		bgfill.transform.colorTransform = clTr;
		//trace("RollOut of " + this + ", clTr.rgb : " + clTr.rgb);
	};

	return clip;
}

function playKanaSound(sndId:String):void
		{
	// Play the sound which pronounces the character released.
	gSound.attachSound(sndId);
	gSound.start();
}

function showRandKana(preview:TextField, kanaset:Object, usedItems:Array):void
		{
	var objKeys:Array = new Array();
	// Push keys in array. Terrible way to go.
	for (var i in kanaset)
			{
		for (var s in usedItems)
			{
			if (usedItems[s] == kanaset[i])
			{
				continue;
			}
		}
		objKeys.push(i);
	}
	// Select random index
	var inx:String = kanaset[Numbers.random(0, objKeys.length)];
	// Set the text
	preview.text = kanaset[inx];
	// Add the current to the used list
	usedItems.push(inx);
}






 */
