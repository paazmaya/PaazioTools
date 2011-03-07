/**
 * @mxmlc -target-player=10.0.0 -debug
 */

/**
 * Puzzle
 * Load image, convert to a bitmapdata, split into a number of pieces, scrumble.
 * Jukka Paasonen
 *
 * www.flashkod.com
 * apina555:saatana
 * paazio@wippies.com
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Mouse;

	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '900', height = '700')]

	public class ItPuzzlesMe extends Sprite
	{

		// Settings
		private var image:String = "ItPuzzlesMe1.jpg";
		private var pieces:uint = 24;
		private var marginal:uint = 6; // Pixels to snap

		// Colors to use
		private var white:uint = 0xFFFFFF;
		private var red:uint = 0xFF4400;
		private var green:uint = 0x00FF22;

		// -------------
		private var pieceList:Array = []; // Has bitmaps where each has x, y, bitmapdata.
		private var lineListV:Array = []; // The collection of bezier curve settings in vertical direction
		private var lineListH:Array = []; // The collection of bezier curve settings in horizontal direction
		private var imageData:BitmapData; // The image which was downloaded from somewhere
		private var piecesW:uint; // Pieces in width direction
		private var piecesH:uint; // Pieces in height direction
		private var puzzle:Sprite; // Container of all the pieces.
		private var positionedCount:uint = 0; // How many of the pieces have been placed correctly
		private var loader:Loader; // Loader to get the image from somewhere

		public function ItPuzzlesMe()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			//TweenPlugin.activate([AutoAlphaPlugin]);
			
			loaderInfo.addEventListener(Event.INIT, onInit);
		}

		private function onInit(event:Event):void
		{
			if (stage.loaderInfo.parameters.image != undefined && stage.loaderInfo.parameters.image != "")
			{
				image = String(stage.loaderInfo.parameters.image);
			}
			if (stage.loaderInfo.parameters.pieces != undefined && stage.loaderInfo.parameters.pieces != "")
			{
				pieces = parseInt(stage.loaderInfo.parameters.pieces);
			}
			if (stage.loaderInfo.parameters.marginal != undefined && stage.loaderInfo.parameters.marginal != "")
			{
				marginal = parseInt(stage.loaderInfo.parameters.marginal);
			}
			
			var suf:String = image.substr(image.lastIndexOf(".") + 1).toLowerCase();
			if (suf == "jpg" || suf == "png" || suf == "gif")
			{
				loadImage(image);
			}

			puzzle = new Sprite();
			puzzle.x = 6;
			puzzle.y = 6;
			addChild(puzzle);
		}

		private function drawPuzzleBorders():void
		{
			// Add borders for the puzzle to make of putting it together easier.
			var gra:Graphics = puzzle.graphics;
			gra.lineStyle(1, red);
			gra.lineTo(imageData.width, 0);
			gra.lineTo(imageData.width, imageData.height);
			gra.lineTo(0, imageData.height);
			gra.lineTo(0, 0);
		}

		// 1. load image
		private function loadImage(url:String):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
			loader.load(new URLRequest(url));
			//addChild(loader); // This will show the photo when it has been loaded.
		}
		private function onImageLoaded(event:Event):void
		{
			tracer("Image loaded.");
			var bitmap:Bitmap = event.target.loader.content as Bitmap;
			bitmap.smoothing = true;
			imageData = bitmap.bitmapData;

			calculateSizing();
		}
		private function onImageError(event:IOErrorEvent):void
		{
			tracer("Unable to load image: " + image);
		}

		// 2. get dimensions of the image
		private function calculateSizing():void
		{
			var ratio:Number = imageData.height / imageData.width;
			var boxRatio:Number = 10000; // Just some huge number to initiate.
			var m:int = Math.floor(Math.sqrt(pieces));

			for (var i:int = 1; i <= m; ++i)
			{
				if (pieces % i == 0)
				{
					var x:Number = pieces / i;
					var y:Number = pieces / x;
					tracer("x: " + x + ", y: " + y);
					var r1:Number = x / y;
					trace(i + " r1: " + r1 + ", ratio: " + ratio + ", boxRatio: " + boxRatio);
					if (Math.abs(r1 - ratio) < boxRatio)
					{
						boxRatio = Math.abs(r1 - ratio);
						piecesW = x;
						piecesH = y;
						tracer("r1 piecesW: " + piecesW + ", piecesH: " + piecesH);
					}
					var r2:Number = y / x;
					trace(i + " r2: " + r2 + ", ratio: " + ratio + ", boxRatio: " + boxRatio);
					if (Math.abs(r2 - ratio) < boxRatio)
					{
						boxRatio = Math.abs(r2 - ratio);
						piecesW = y;
						piecesH = x;
						tracer("r2 piecesW: " + piecesW + ", piecesH: " + piecesH);
					}
				}
			}
			drawPuzzleBorders();
			splitPieces();
			shuffleAndShow();
		}

		// 3. create pieces based on amount and diamentions
		private function splitPieces():void
		{
			// Each box should have four sides, each side few poins (TODO), which
			// create the puzzle shape. Outer sides are straight of course.
			tracer("imageData - height: " + imageData.height + ", width: " + imageData.width);
			tracer("final piecesW: " + piecesW + ", piecesH: " + piecesH);

			// Sizes of the square.
			var width:Number = imageData.width / piecesW;
			var height:Number = imageData.height / piecesH;
			
			for (var iw:uint = 0; iw < piecesW; iw++)
			{
				for (var ih:uint = 0; ih < piecesH; ih++)
				{
					var x:Number = iw * (imageData.width / piecesW);
					var y:Number = ih * (imageData.height / piecesH);
					
					var sha:Shape = new Shape();
					var gra:Graphics = sha.graphics;
					gra.beginFill(0x006633);
					gra.lineStyle(1, Math.random() * 0xFFFFFF);
					for (var s:uint = 0; s < width; ++s)
					{
						gra.lineTo(s, (Math.sin( s/3 ) * 10 ));
					}

					var box:BitmapData = new BitmapData(Math.ceil(width), Math.ceil(height), true, 0x00FFFFFF);
					var rect:Rectangle = new Rectangle(x, y, width, height);
					var point:Point = new Point(0, 0);
					tracer("rect " + iw + "x" + ih + " : " + rect.toString());
					tracer("box " + iw + "x" + ih + " - height: " + box.height + ", width: " + box.width + ", rect: " + box.rect.toString());
					box.copyPixels(imageData, rect, point);
				

					var p:Bitmap = new Bitmap(box);
					// Place bitmap to a position where it will be in correct position when sprite goes to origo.
					p.x = x;
					p.y = y;
					p.name = "bitmap";
					p.cacheAsBitmap = true;
					pieceList.push(p);
				}
			}
		}

		// 4. shuffle and show pieces
		private function shuffleAndShow():void
		{
			if (pieceList.length > 0)
			{
				for (var i:uint = 0; i < pieces; ++i)
				{
					var p:Bitmap = pieceList[i] as Bitmap;
					tracer("piece " + i + " name: " + p.name + ", x: " + p.x + ", y: " + p.y);
					var s:Sprite = new Sprite();
					s.name = "piece_" + i;
					s.x = Math.random() * imageData.width / 2 - imageData.width / 4;
					s.y = Math.random() * imageData.height / 2 - imageData.height / 4;
					s.addEventListener(MouseEvent.MOUSE_DOWN, onPieceDown);
					s.addEventListener(MouseEvent.MOUSE_UP, onPieceUp);
					s.addChild(p);
					puzzle.addChild(s);
				}
			}
		}

		// 5. drag and place
		private function onPieceDown(event:MouseEvent):void
		{
			var cur:Sprite = event.currentTarget as Sprite;
			puzzle.setChildIndex(puzzle.getChildByName(cur.name), puzzle.numChildren - 1);
			cur.startDrag();
			cur.addEventListener(MouseEvent.MOUSE_MOVE, onPieceMove);
		}
		private function onPieceUp(event:MouseEvent):void
		{
			var cur:Sprite = event.currentTarget as Sprite;
			cur.stopDrag();
			cur.removeEventListener(MouseEvent.MOUSE_MOVE, onPieceMove);

			// If the piece is dropped within the marginal of its correct position,
			// listeners are removed and filter applied. Also should go on the bottom of visible items.
			if (Math.abs(cur.x) < marginal && Math.abs(cur.y) < marginal)
			{
				correctPlacement(cur);
			}
		}
		private function onPieceMove(event:MouseEvent):void
		{
			var cur:Sprite = event.currentTarget as Sprite;
			var bit:Bitmap = cur.getChildByName("bitmap") as Bitmap;
			var gra:Graphics = cur.graphics;

			var left:Number = bit.x;
			var top:Number = bit.y;
			var right:Number = bit.x + bit.width - 1;
			var bottom:Number = bit.y + bit.height - 1;

			if (Math.abs(cur.x) < marginal && Math.abs(cur.y) < marginal)
			{
				// Correct spot
				gra.clear();
				gra.lineStyle(2, green);
				gra.moveTo(left, top);
				gra.lineTo(right, top);
				gra.lineTo(right, bottom);
				gra.lineTo(left, bottom);
				gra.lineTo(left, top);
			}
			else
			{
				gra.clear();
			}
		}

		// 6. if piece is dragged within the marginal of the correct position and dropped,
		// it will be autoplaced, remove listeners and flashed.
		private function correctPlacement(cur:Sprite):void
		{
			cur.graphics.clear();
			cur.removeEventListener(MouseEvent.MOUSE_DOWN, onPieceDown);
			cur.removeEventListener(MouseEvent.MOUSE_UP, onPieceUp);
			var blur:BlurFilter = new BlurFilter();
			var filt:Array = [];
			filt.push(blur);
			cur.filters = filt;
			cur.x = 0;
			cur.y = 0;
			puzzle.setChildIndex(puzzle.getChildByName(cur.name), 0);
			positionedCount++;
			tracer("Piece positioned correctly, positionedCount is now " + positionedCount);
			if (positionedCount == pieces)
			{
				// all done.
				puzzleFinish();
			}
		}
		private function puzzleFinish():void
		{
			tracer("Puzzle is finished.");
			/*
			// Remove filters
			var filt:Array = [];
			for (var i:uint = 0; i < pieces; ++i)
			{
				var s:Sprite = puzzle.getChildByName("piece_" + i) as Sprite;
				s.filters = filt;
				tracer("Cleared filters for " + s.name);
			}
			 */

			// Show the original
			loader.x = puzzle.x;
			loader.y = puzzle.y;
			stage.addChild(loader);
		}

		// Keep trace data in one place in order to keep things secret.
		private function tracer(msg:Object):void
		{
			trace(msg);
		}
	}
}
