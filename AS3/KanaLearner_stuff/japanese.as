/*
Katakana / Hiragana learning tool

Jukka Paasonen
*/

// #######################################################################
// Settings
var colors:Object = {fill:0xFBFBFB, outline:0x000000, text:0x2B2B2B, hover:0xCBCBCB};
var locations:Object = {bTop:50, bLeft:20, bMargin:2};
var volume:Number = 60;


// #######################################################################
// Import packages.

import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Transform;


// #######################################################################
// Important variables.

var gridCont:MovieClip;
var gSound:Sound = new Sound();
var playSound:Boolean = false;
var points:Number = 0;
var started:Date;
var usedItems:Array = new Array();

var hiragana:Object = {
	a0:"あ",		i0:"い",		u0:"う",		e0:"え",		o0:"お",
	ka0:"か",	ki0:"き",	ku0:"く",	ke0:"け",	ko0:"こ",
	sa0:"さ",	shi0:"し",	su0:"す",	se0:"せ",	so0:"そ",
	ta0:"た",	chi0:"ち",	tsu0:"つ",	te0:"て",	to0:"と",
	ha0:"は",	hi0:"ひ",	fu0:"ふ",	he0:"へ",	ho0:"ほ",
	na0:"な",	ni0:"に",	nu0:"ぬ",	ne0:"ね",	no0:"の",
	ra0:"ら",	ri0:"り",	ru0:"る",	re0:"れ",	ro0:"ろ",
	ma0:"ま",	mi0:"み",	mu0:"む",	me0:"め",	mo0:"も",
	ya0:"や",				yu0:"ゆ",				yo0:"よ",
	wa0:"わ",										wo0:"を",
	n0:"ん",
	pa0:"ぱ",	pi0:"ぴ",	pu0:"ぷ",	pe0:"ぺ",	po0:"ぽ",
	ba0:"ば",	bi0:"び",	bu0:"ぶ",	be0:"べ",	bo0:"ぼ",
	da0:"だ",	di0:"ぢ",	du0:"づ",	de0:"で",	do0:"ど",
	ga0:"が",	gi0:"ぎ",	gu0:"ぐ",	ge0:"げ",	go0:"ご",
	za0:"ざ",	ji0:"じ",	zu0:"ず",	ze0:"ぜ",	zo0:"ぞ"
};
var katakana:Object = {
	a0:"ア",		i0:"イ",		u0:"ウ",		e0:"エ",		o0:"オ",
	ka0:"カ",	ki0:"キ",	ku0:"ク",	ke0:"ケ",	ko0:"コ",
	sa0:"サ",	shi0:"シ",	su0:"ス",	se0:"セ",	so0:"ソ",
	ta0:"タ",	chi0:"チ",	tsu0:"ツ",	te0:"テ",	to0:"ト",
	ha0:"ハ",	hi0:"ヒ",	fu0:"フ",	he0:"ヘ",	ho0:"ホ",
	na0:"ナ",	ni0:"ニ",	nu0:"ヌ",	ne0:"ネ",	no0:"ノ",
	ra0:"ラ",	ri0:"リ",	ru0:"ル",	re0:"レ",	ro0:"ロ",
	ma0:"マ",	mi0:"ミ",	mu0:"ム",	me0:"メ",	mo0:"モ",
	ya0:"ヤ",				yu0:"ユ",				yo0:"ヨ",
	wa0:"ワ",										wo0:"ヲ",
	n0:"ン",
	pa0:"パ",	pi0:"ピ",	pu0:"プ",	pe0:"ペ",	po0:"ポ",
	ba0:"バ",	bi0:"ビ",	bu0:"ブ",	be0:"ベ",	bo0:"ボ",
	da0:"ダ",	di0:"ヂ",	du0:"ヅ",	de0:"デ",	do0:"ド",
	ga0:"ガ",	gi0:"ギ",	gu0:"グ",	ge0:"ゲ",	go0:"ゴ",
	za0:"ザ",	ji0:"ジ",	zu0:"ズ",	ze0:"ゼ",	zo0:"ゾ"
};

var romaji:Object = {
	a0:"a",		i0:"i",		u0:"u",		e0:"e",		o0:"o",
	ka0:"ka",	ki0:"ki",	ku0:"ku",	ke0:"ke",	ko0:"ko",
	sa0:"sa",	shi0:"shi",	su0:"su",	se0:"se",	so0:"so",
	ta0:"ta",	chi0:"chi",	tsu0:"tsu",	te0:"te",	to0:"to",
	ha0:"ha",	hi0:"hi",	fu0:"fu",	he0:"he",	ho0:"ho",
	na0:"na",	ni0:"ni",	nu0:"nu",	ne0:"ne",	no0:"no",
	ra0:"ra",	ri0:"ri",	ru0:"ru",	re0:"re",	ro0:"ro",
	ma0:"ma",	mi0:"mi",	mu0:"mu",	me0:"me",	mo0:"mo",
	ya0:"ya",				yu0:"yu",				yo0:"yo",
	wa0:"wa",										wo0:"wo",
	n0:"n",
	pa0:"pa",	pi0:"pi",	pu0:"pu",	pe0:"pe",	po0:"po",
	ba0:"ba",	bi0:"bi",	bu0:"bu",	be0:"be",	bo0:"bo",
	da0:"da",	di0:"di",	du0:"du",	de0:"de",	do0:"do",
	ga0:"ga",	gi0:"gi",	gu0:"gu",	ge0:"ge",	go0:"go",
	za0:"za",	ji0:"ji",	zu0:"zu",	ze0:"ze",	zo0:"zo"
};


// 	a0:"",	i0:"",	u0:"",	e0:"",	o0:"",
// 	a0:"",	i0:"",	u0:"",	e0:"",	o0:"",

// #######################################################################
// Initization

// Draw background fill.
var gradient:MovieClip = this.createEmptyMovieClip("gradient", this.getNextHighestDepth());
with (gradient) {
    fillType = "radial"
    colores = [0xDCB51B, 0xC6B9B0];
    alphas = [100, 100];
    ratios = [0, 0xFF];
    spreadMethod = "reflect";
    interpolationMethod = "linearRGB";
    focalPointRatio = 0.9;
    matrix = new Matrix();
    matrix.createGradientBox(100, 100, Math.PI, 0, 0);
    beginGradientFill(fillType, colores, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
    moveTo(0, 0);
    lineTo(0, Stage.height);
    lineTo(Stage.width, Stage.height);
    lineTo(Stage.width, 0);
    lineTo(0, 0);
    endFill();
}


// Create buttons for selecting kana type.
var hiragana_bt:MovieClip = createButton(this.createEmptyMovieClip("hiragana_bt", this.getNextHighestDepth()), 90, 20, colors, "Hiragana");
var katakana_bt:MovieClip = createButton(this.createEmptyMovieClip("katakana_bt", this.getNextHighestDepth()), 90, 20, colors, "Katakana");
var romaji_bt:MovieClip = createButton(this.createEmptyMovieClip("romaji_bt", this.getNextHighestDepth()), 90, 20, colors, "Romaji");

hiragana_bt._y = locations.bTop;
katakana_bt._y = hiragana_bt._y + hiragana_bt._height + locations.bMargin;
romaji_bt._y = katakana_bt._y + katakana_bt._height + locations.bMargin;

hiragana_bt._x = locations.bLeft;
katakana_bt._x = locations.bLeft;
romaji_bt._x = locations.bLeft;


// Create "preview" field for the character we are asking
var preview:MovieClip = this.createEmptyMovieClip("preview", this.getNextHighestDepth());
preview._y = locations.bTop;
preview._x = locations.bLeft + hiragana_bt._width + locations.bMargin * 10;
preview = createButton(preview, 80, 80, colors, "...");



// Text field for points and time
var points:TextField = this.createTextField("points", this.getNextHighestDepth(), romaji_bt._y + locations.bMargin, locations.bLeft, 400, 60);
//points.text = "Halloota talloon";

// Create start button
var start_bt:MovieClip = this.createEmptyMovieClip("start_bt", this.getNextHighestDepth());
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
	this._visible = false;

};


// #######################################################################
// Functions


function chooseKanaSet():void
		{
	var kana:String = this._name.split("_")[0];
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

	for (var i in kana) {
		var clip:MovieClip = createKanaButton(cont, i, kana, bWidth, bHeight, colors);

		clip._x = k * (clip._width + margin);
		//trace("clip._width : " + clip._width);
		clip._y = s * (clip._height + margin);
		//trace("clip._height : " + clip._height);

		// Count the x location multiplier for next round
		if (s < 4) {
			if (i.substr(0, 1) == "y") {
				s += 2;
			}
			else if (i == "wa0") {
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
		if (i.substr(1, 1) == "o") {
			k++;
		}
	}

	return cont;
}

function createKanaButton(parent:MovieClip, txtIndex:String, txtObj:Object, bWidth:Number, bHeight:Number, colors:Object):MovieClip {
	//trace(txtIndex + " Backgound depth should be " + parent.getNextHighestDepth());
	var backg:MovieClip = parent.createEmptyMovieClip("tbg_" + getTimer(), parent.getNextHighestDepth());
	//backg = createButton(backg, bWidth, bHeight, colors);

	backg = drawShape4(backg, bWidth, bHeight, bWidth / 2, bHeight / 2, colors, 5, 4);

	//trace(txtIndex + " Txtfiled depth should be " + backg.getNextHighestDepth());
	var field:TextField = backg.createTextField("txt_" + getTimer(), backg.getNextHighestDepth(), 0, 0, bWidth, bHeight);
	field.background = false;
	field.border = false;
	field.condenseWhite = true;
	field.embedFonts = true
	field.html = true;
	field.maxChars = 3;
	field.mouseWheelEnabled = false;
	field.multiline = false;
	field.password = false;
	field.selectable = true;
	field.text = txtObj[txtIndex];
	field.type = "dynamic";
	field.wordWrap = true;

	var txtfmt:TextFormat = new TextFormat();
	txtfmt.align = "left";
	txtfmt.blockIndent = 0;
	txtfmt.bold = false;
	txtfmt.bullet = false;
	txtfmt.color = colors.text;
	txtfmt.font = "marui14";
	txtfmt.indent = 0;
	txtfmt.italic = false;
	txtfmt.leading = 0;
	txtfmt.leftMargin = 0;
	txtfmt.rightMargin = 0;
	txtfmt.size = 14;
	txtfmt.underline = false;
	//txtFmt.letterSpacing = 5;
	//txtfmt.url = "";
	//txtfmt.target = "";
	//txtfmt.tabStops = [] // (empty array)


	// public getTextExtent(text:String, [width:Number]) : Object
	// Deprecated since Flash Player 8. There is no replacement.
	// This is a mistake in the documentation. TextFormat.getTextExtent is NOT deprecated.
	var extent:Object = txtfmt.getTextExtent(txtObj[txtIndex]);

	//for (var key in extent) {
	//	trace("-- " + txtIndex + " : extent[" + key + "] = " + extent[key]);
	//}

	field._width = extent.textFieldWidth;
	field._height = extent.textFieldHeight;
	field.setTextFormat(txtfmt);

	// Centerize textfield to the background
	field._y = Math.round(backg._height / 2 - field._height / 2);
	field._x = Math.round(backg._width / 2 - field._width / 2);

	backg.charkey = txtIndex;
	backg.onRelease = function()
		{
		trace(this.charkey);
		//playKanaSound(this.charkey);
	};

	return backg;
}

function createButton(clip:MovieClip, bWidth:Number, bHeight:Number, colors:Object, createText:String):MovieClip {
	// Create containers for the fill and for the outlines.
	//trace("Default value of createText is undefined, but now it is " + createText);

	var bgCont:MovieClip = clip.createEmptyMovieClip("bgfill", clip.getNextHighestDepth());
	var ouCont:MovieClip = clip.createEmptyMovieClip("outline", clip.getNextHighestDepth());

	if (createText != undefined) {
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
		var clTr:ColorTransform = this.bgfill.transform.colorTransform;
		clTr.rgb = colors.hover;
		this.bgfill.transform.colorTransform = clTr;
		//trace("RollOver of " + this + ", clTr.rgb : " + clTr.rgb);
	};
	clip.onRollOut = function()
		{
		var clTr:ColorTransform = this.bgfill.transform.colorTransform;
		clTr.rgb = colors.fill;
		this.bgfill.transform.colorTransform = clTr;
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
	for (var i in kanaset) {
		for (var s in usedItems) {
			if (usedItems[s] == kanaset[i]) {
				continue;
			}
		}
		objKeys.push(i);
	}
	// Select random index
	var inx:String = kanaset[randRange(0, objKeys.length)];
	// Set the text
	preview.text = kanaset[inx];
	// Add the current to the used list
	usedItems.push(inx);
}

function randRange(min:Number, max:Number):Number
		{
	// Get random int within limits.
    var rn:Number = Math.floor(Math.random() * (max - min + 1)) + min;
    return rn;
}

// xPos, yPos give the center of the shape
function drawShape4(mc:MovieClip, xPos:Number, yPos:Number, width:Number, height:Number, colors:Object, four:Number, eight:Number):MovieClip {
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
	return mc;
}

// xPos, yPos give the upper left corner
function drawBox4(mc:MovieClip, xPos:Number, yPos:Number, height:Number, width:Number, colors:Object, doOutline:Boolean):void
		{
	if (doOutline) {
		mc.lineStyle(1, colors.outline, 100);
	}
	else {
		mc.beginFill(colors.fill, 100);
	}
    mc.moveTo(xPos, yPos);
	mc.lineTo(xPos + width, yPos);
	mc.lineTo(xPos + width, yPos + height);
	mc.lineTo(xPos, yPos + height);
    mc.lineTo(xPos, yPos);
	if (!doOutline) {
		mc.endFill();
	}
}


