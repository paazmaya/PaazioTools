package org.paazio.lang
{
	/**
	 * Properties for the Japanese language
	 */
	public class Japanese
	{
		public static const HIRAGANA:String = "hiragana";
		public static const KATAKANA:String = "katakana";
		public static const ROMAJI:String = "romaji";
		
		public static const NAME:String = "Japanese";
		
		public static var hiragana:Object = {
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
		public static var katakana:Object = {
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
		public static var romaji:Object = {
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
		
		/**
		 *
		 */
		public function Japanese()
		{
			
		}

		/**
		 * Get the specific character from the list.
		 * @param	index
		 * @param	type
		 * @return
		 */
		public function getCharater(index:String, type:String):String
		{
			var char:String = "";
			switch (type)
			{
				case HIRAGANA :
					char = hiragana[index + "0"];
					break;
				case KATAKANA :
					char = katakana[index + "0"];
					break;
				case ROMAJI :
					char = romaji[index + "0"];
					break;
			}
			return char;
		}
	}
}
