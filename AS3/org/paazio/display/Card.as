package org.paazio.display
{
	import flash.display.*;

	/**
	 * A card for a card game
	 * @see http://paazio.nanbudo.fi/tutorials/flash/
	 * @author Jukka Paasonen
	 * @version 0.1
	 */
	public class Card extends Sprite
	{
		
		public static const SPADES:String = "spades";
		public static const HEARTS:String = "hearts";
		public static const DIAMONDS:String = "diamonds";
		public static const CLUBS:String = "clubs";

		/**
		 * The suit of this card.
		 * @see http://en.wikipedia.org/wiki/Suit_(cards)
		 */
		public var suit:String = "";
		
		/**
		 *
		 */
		public function Card()
		{
			
		}
		
		/**
		 * Compare the given card with this card for their color (red or black).
		 * @param	card
		 * @return
		 */
		public function sameColor(card:Card):Boolean
		{
			var value:Boolean = false;
			if (card.suit == suit)
			{
				
			}
			return value;
		}
		
		/**
		 * Compare the given card with this card for their suit.
		 * @param	card
		 * @return
		 */
		public function sameSuit(card:Card):Boolean
		{
			var value:Boolean = false;
			if (card.suit == suit)
			{
				
			}
			return value;
		}
		
	}
}
