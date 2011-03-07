package org.paazio.display
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.utils.*;

	public class StarDust extends Sprite
	{
		private var life : Number;
		private var lifeMax : Number;
		private var lifeIni : Number;
		private var vY : Number;
		private var vX : Number;
		private var vIniX : Number;
		private var vIniY : Number;
		private var vMaxX : Number;
		private var vMaxY : Number;
		
		private var _colors:Array = [0x6633FF, 0x0099FF, 0x336699];
		private var _alphas:Array = [1.0, 0.2, 0.0];
		private var _ratios:Array = [0, 68, 255];
		private var _matrix:Matrix;
		private var _radius:Number = 12.5;
		
		/**
		 * 
		 * @param	_lifeIni
		 * @param	_vIniX
		 * @param	_vIniY
		 * @param	_vMaxX
		 * @param	_vMaxY
		 */
		public function StarDust (_lifeIni:int, _vIniX:Number, _vIniY:Number, _vMaxX:Number, _vMaxY:Number)
		{
			lifeIni = _lifeIni;
			vIniX = _vIniX;
			vIniY = _vIniY;
			vMaxX = _vMaxX;
			vMaxY = _vMaxY;
			
			_matrix = new Matrix();
			_matrix.createGradientBox(_radius / 2, _radius / 2);
			
			addEventListener(Event.ADDED, create);
		}


		private function create (event:Event) : void
		{
			graphics.beginGradientFill(GradientType.RADIAL, _colors, _alphas, _ratios, _matrix);
			graphics.drawCircle(0, 0, _radius);
			graphics.endFill();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			vX = vIniX - Math.random() * vIniX * 2;
			vY = vIniY - Math.random() * vIniY * 2;

			life = lifeMax = lifeIni;
		}
		
		private function onEnterFrame (event:Event) : void
		{
			var ap : Number = 100 * life / lifeMax;
			alpha = ap / 100;
			scaleX = ap / 50;
			scaleY = ap / 50;
			
			x += vX;
			y += vY;
			
			vX += (vMaxX - Math.random() * (vMaxX * 2)) / ap;
			vY += (vMaxY - Math.random() * (vMaxY * 2)) / ap;

			life = life - 1;
			if (life <= 0)
			{
				kill();
			}
		}
		
		private function kill () : void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			parent.removeChild(this);
		}
	}
}
