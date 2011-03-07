/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import flash.system.System;
	
	[SWF(backgroundColor = '0x121212', frameRate = '60', width = '800', height = '600')]
	
	/**
	 * http://sprott.physics.wisc.edu/java/attract/attract.htm
	 * http://sprott.physics.wisc.edu/java/attract/attract.java
	 * @author nicoptere
	 * @see http://en.nicoptere.net/?p=284#more-284
	 */
	public class StrangeAttractor extends Sprite
	{
		private var txt:TextField;
		private var w:int;
		private var h:int;
		private var nc:int;
		private var bc:int;
		private var dt:int;
		private var iterations:int;
		
		private var a:Vector.<Number> = new Vector.<Number>( 6 );
		private var colors:Vector.<uint> = new Vector.<uint>( 256 );
		
		private var bd:BitmapData;
		
		private var existingPoints:Vector.<Vector3D>;
		
		private var attractor:int = 0;
		private var settings:Vector.<Array> = new Vector.<Array>(
		[
			[ -1.508615294471383,-1.2419325867667794,-0.4816344156861305,-0.9251388106495142,0.9605911932885647,1.4612610843032598 ],
			[ -0.0896300682798028,-0.09138607420027256,0.24109896272420883,0.8608848229050636,-1.377242493443191,2.830356993712485],
			[ 0.4526906982064247,0.1551796244457364,-0.6429857723414898,-1.8773328177630901,0.21230726782232523,-2.754035633057356 ],
			[ 0.2320262650027871,2.8680934282019734,-1.530471500940621,-1.571444540284574,-0.24962520506232977,0.14915068913251162 ],
			[ -0.39363164361566305,-2.067637262865901,-0.8757140832021832,-1.3471128176897764,-1.8029691511765122,-1.1637711692601442 ],
			[ 0.6499763717874885,-2.002905442379415,1.9213466020300984,-1.2838844619691372,-0.2302103005349636,1.103024904616177  ],
			[ 1.3539914404973388,0.982342841103673,-0.3550120946019888,0.45590283907949924,0.055688646622002125,-0.7343180403113365 ],
			[ 0.3220657780766487,0.7966507561504841,-0.19625244475901127,1.9117689225822687,-0.7966365795582533,-1.637622649781406 ],
			[ 0.7007651003077626,0.11224428936839104,-1.4247641069814563,0.36751877423375845,-0.0013294592499732971,-2.8493297891691327 ],
			[ -0.36745373345911503,-0.6964408736675978,2.702967924065888,1.2905555460602045,-0.6514955079182982,1.1674273498356342 ],
			[ 0.3529515629634261,-0.038198310881853104,-1.9135284572839737,0.6659935880452394,-1.1284982096403837,-1.7819844614714384 ],
			[ 0.25354979932308197,0.34962162002921104,0.47558699268847704,0.5594627056270838,-0.6905784336850047,-2.1140809804201126 ],
			[ -0.11528539471328259,-0.5602130116894841,1.585916480049491,1.7774559119716287,-1.3861011425033212,2.7742475168779492 ],
			[ 0.314070082269609,1.3498716931790113,-2.6876113833859563,2.4140010438859463,-1.6411917423829436,1.6677697207778692 ],
			[ -0.031364427879452705,-0.8018507715314627,-2.8623738158494234,0.42667070869356394,-1.4297216171398759,-2.644897961989045 ],
			[ 0.5811144132167101,-0.7408061670139432,-0.9531628433614969,-0.08994662202894688,-0.3371124118566513,-2.2023877752944827 ],
			[ -0.25621075462549925,-1.4719083840027452,1.378912984393537,2.326819399371743,-0.9970525586977601,1.0653631472960114  ],
			[ -0.5594811290502548,-1.6196881653741002,-0.47412542905658484,0.26850555930286646,-1.0987156201153994,-0.44125312753021717 ],
			[ 0.33099494129419327,0.07977790106087923,-0.37910763546824455,-2.9349720161408186,-0.41534134838730097,-1.8627644972875714 ],
			[ 0.6988238487392664, -0.25390119664371014, 0.2938360869884491, -0.12586869020015, 1.7653993349522352, -2.2957704244181514 ],
			[ 0.012318254448473454, 1.2377529423683882, -0.6119919838383794, -0.27228193916380405, 1.9775042356923223, -2.6802720241248608]
			
		]);
		
		public function StrangeAttractor( _width:int = 800, _height:int = 600, colors:int = 256, iterations:int = 30000 )
		{
			
			w = _width;
			h = _height;
			nc = colors;
			if (nc > 256) nc = 256;
			this.iterations = iterations;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}
		
		private function onInit(event:Event):void
		{
			if (nc > 0)
			{
				var i:int;
				for ( i = 0; i < nc; ++i)
				{
					var c:Number = i/nc;
					colors[ i ] = 0x777777 + i * ( 0x777777 / nc );
				}
			}
			
			bd = new BitmapData( w, h, true, 0x00FFFFFF );
			var bmp:Bitmap = new Bitmap( bd );
			addChild( bmp );
			
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			addChild( txt );
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, run );
			
		}
		
		public function run( event:Event ):void
		{
			if ( event.target is TextField ) return;
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, run );
			
			bd.fillRect( bd.rect, 0xffffff );
			existingPoints = new Vector.<Vector3D>();
			
			var x:Number = 0, y:Number = 0, z:Number = 0, xmin:Number = 0, xmax:Number = 0, xe:Number = 0, ye:Number = 0, xnew:Number, ynew:Number, xenew:Number;
			var dx:Number = 0, dh:Number = 0, dw:Number = 0, dz:Number = 0;
			var n:int = 0, xp:int, yp:int, zp:int;
			
			var le:Boolean = false;
			
			var limit:int = 200;
			
			var counter:int = 0;
			var i :int;
			while ( counter++ < iterations * 2 )
			{
				//reset
				if (n == 0)
				{
					//utilise les preset avant de lancer le random
					if ( attractor < settings.length )
					{
						a = Vector.<Number>(settings[ attractor ]);
					}
					else
					{
						a = Vector.<Number>([ 0,0,0,0,0,0 ]);
						for ( i = 0; i < 6; ++i)
						{
							a[i] = 6.0 *  Math.random() - 3.0;
						}
					}
					attractor++;
					
					
					x = 0;
					y = 0;
					xe = x + 10000;
					ye = y;
					xmin = Number.POSITIVE_INFINITY;
					xmax = Number.NEGATIVE_INFINITY;
					le = false;
					
				}
				else if (n >= 1 && n <= limit-1)
				{
					
					if (x < xmin) xmin = x;
					if (x > xmax) xmax = x;
					
					xenew = a[0] + xe * (a[1] + a[2] * xe + a[3] * ye) + ye * (a[4] + a[5] * ye);
					ye = xe;
					xe = xenew;
					
					if ( Math.abs( xe-x ) > .01 ) le = true;
					
				}
				else if (n == limit)
				{
					if ( !le )
					{
						n = -1;
						counter = -1;
						existingPoints = new Vector.<Vector3D>();
					}
				}
				else if (n == limit+1)
				{
					
					dx = .1 * (xmax - xmin);
					if (dx == 0) dx = 1;
					
					xmax = xmax + dx;
					xmin = xmin - dx;
					
					dw = w / (xmax - xmin);
					dh = h / (xmax - xmin);
					dz = nc / (xmax - xmin);
					
					
				}else if( n > limit+1 )
				{
					xp = int(dw * (x - xmin));
					yp = int(dh * (xmax - y));
					
					if ( !checkUnicity( xp , yp ) )
					{
						n = -1;
						counter = -1;
						existingPoints = new Vector.<Vector3D>();
					}
					else
					{
						zp = int(dz * (z - xmin)) % nc;
						existingPoints.push( new Vector3D( xp, yp, zp ) );
					}
				}
				
				n++;
				if ( n >= iterations )
				{
					n = 0;
					paint();
					return;
				}
				
				xnew = a[0] + x * (a[1] + a[2] * x + a[3] * y) + y * ( a[4] + a[5] * y);
				ynew = x;
				
				z = y;
				y = ynew;
				x = xnew;
				
				if ( Math.abs(x) > 10000 ) n = 0;
				
				
			}
		}
		
		
		private function checkUnicity( xp:Number, yp:Number ):Boolean
		{
			
			if( xp < 0 || xp > w || yp < 0 || yp> h  )
			{
				return false;
			}
			var i:int = existingPoints.length;
			if ( i == 30 )
			{
				var p:Vector3D;
				while ( i-- )
				{
					p = existingPoints[ i ];
					if ( p.x == xp && p.y == yp )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		
		private function paint():void
		{
			
			bd.fillRect( bd.rect, 0x00000000 );
			//existingPoints.sortOn( 'z', Array.DESCENDING | Array.NUMERIC );
			existingPoints.reverse();
			
			var i:int;
			var p:Vector3D;
			var tot:int = existingPoints.length;
			if ( attractor <= settings.length  )
			{
				for ( i = 0 ; i < tot; ++i )
				{
					p = existingPoints[ i ];
					bd.setPixel32( p.x, p.y, 0xFFFFFFFF );
				}
				
			}else
			{
				for ( i = 0 ; i < tot; ++i )
				{
					p = existingPoints[ i ];
					bd.setPixel32( p.x, p.y, ( 0xFF << 24 | p.z << 16 | ( 64 + ( 256 - p.z ) / 2  ) << 8 | 0x33 ) );
				}
				
			}
			
			System.setClipboard( String( a ) );
			
			stage.addEventListener( MouseEvent.MOUSE_DOWN, run );
		}
	}
}
/*
class Vector
{
	public var x:Number;
	public var y:Number;
	public var z:Number;
	public function Vector( x:Number = 0, y:Number = 0, z:Number = 0 )
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

}
*/
