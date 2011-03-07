/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	// http://www.riaone.com/products/deval/index.html
	import r1.deval.D;

	[SWF( backgroundColor='0x042836',frameRate='60',width='600',height='400' )]

	public class MathematicsTest extends Sprite
	{
		private var _input:TextField;

		private var _output:TextField;

		private var _button:Sprite;

		private var _format:TextFormat;

		private var _margin:uint = 10;

		public function MathematicsTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			loaderInfo.addEventListener( Event.INIT, onInit );
		}

		private function onInit( event:Event ):void
		{
			_format = new TextFormat();
			_format.size = 12;

			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.height = 100;
			_input.width = stage.stageWidth - _margin * 2;
			_input.x = _margin;
			_input.y = _margin;
			_input.border = true;
			_input.borderColor = 0x121212;
			_input.background = true;
			_input.defaultTextFormat = _format;
			_input.multiline = true;
			addChild( _input );

			_button = new Sprite();
			_button.x = _margin;
			_button.y = _input.y + _input.height + _margin;
			_button.addEventListener( MouseEvent.MOUSE_DOWN, onButton );
			_button.addEventListener( MouseEvent.MOUSE_UP, onButton );
			addChild( _button );
			drawButton();

			_output = new TextField();
			_output.type = TextFieldType.DYNAMIC;
			_output.height = stage.stageHeight - ( _button.y + _button.height + _margin *
				2 );
			_output.width = stage.stageWidth - _margin * 2;
			_output.x = _margin;
			_output.y = _button.y + _button.height + _margin;
			_output.border = true;
			_output.borderColor = 0x121212;
			_output.background = true;
			_output.defaultTextFormat = _format;
			addChild( _output );

			_output.text = "To have the formula to loop from 0 to 100, use ' n '. Notice the white space on both sides. Replaced only once.";
			_input.text = "Math.sin( n )";
		}

		private function drawButton( pressed:Boolean = false ):void
		{
			var color:uint = 0xF2F2F2;
			if ( pressed )
			{
				color = 0xCCCCCC;
			}
			var gra:Graphics = _button.graphics;
			gra.clear();
			gra.lineStyle( 1, 0x121212 );
			gra.beginFill( color );
			gra.drawRect( 0, 0, stage.stageWidth - _margin * 2, 30 );
			gra.endFill();
		}

		private function onButton( event:MouseEvent ):void
		{
			if ( event.type == MouseEvent.MOUSE_DOWN )
			{
				drawButton( true );
				parseInput();
			}
			else if ( event.type == MouseEvent.MOUSE_UP )
			{
				drawButton();
			}
		}

		private function parseInput():void
		{
			var input:String = _input.text;
			var output:String = "";
			if ( input.indexOf( " n " ) != -1 )
			{
				for ( var i:uint = 0; i < 101; ++i )
				{
					var rep:String = input.replace( / n /g, " " + i + " " );
					output += rep + " = " + D.eval( rep ) + "\n";
				}
			}
			else
			{
				output = input + " = " + D.eval( input );
			}
			_output.text = output;
		}
	}
}
