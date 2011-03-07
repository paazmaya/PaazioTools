/**
 * @mxmlc -target-player=10.0.0 -debug
 */
package sandbox
{
    import flash.display.*;
    import flash.events.Event;
	import flash.geom.Point;
	import org.paazio.display.Ball;
	
	[SWF(backgroundColor = '0x042836', frameRate = '33', width = '800', height = '600')]

    public class BallTest extends Sprite
    {
        public var stageWidth : int;
        public var stageHeight : int;

        private var _balls : Vector.<Ball>;
        private var _count : uint = 100;
		private var _radius:Number = 8;

        public function BallTest()
        {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
            addEventListener( Event.ADDED_TO_STAGE, onInit );
        }

        private function onInit( event:Event ) : void
        {
			
			stageWidth = Math.round(stage.stageWidth - _radius);
			stageHeight = Math.round(stage.stageHeight - _radius);
			
			_balls = new Vector.<Ball>();
			
            removeEventListener( Event.ADDED_TO_STAGE, onInit );

            for (var i : int = 0; i < _count; ++i)
            {
				var pa:Ball = new Ball(Math.random() * 0xFFFFFF, _radius);
				pa.x = Math.random() * stageWidth;
				pa.y = Math.random() * stageHeight;
				pa.vx = Math.random() * 20 - 10;
				pa.vy = Math.random() * 20 - 10;
				_balls[i] = pa;
                addChild(pa);
            }

            addEventListener(Event.ENTER_FRAME, loop);
        }

        private function loop( event:Event ) : void
        {
			var distance:Point = new Point(0, 0);
			var impact:Point = new Point(0, 0);
			var impulse:Point = new Point(0, 0);
			var impulseHalf:Point = new Point(0, 0);

            var gravity : Object = {x: (mouseX - (stageWidth >> 1)) / stageWidth, y: (mouseY - (stageHeight >> 1)) / stageHeight };

            for ( var i : int = 0; i < _count; ++i)
            {
                var ball : Ball = _balls[i];
			
                for( var j : int = 0; j < _count; j++)
                {
                    var ball2 : Ball = _balls[j];

                    if (ball2 == ball)
					{
						continue;
					}
				
                    distance.x = ball.x - ball2.x;
                    distance.y = ball.y - ball2.y;
								
                    var length : Number = Math.sqrt(distance.x * distance.x + distance.y * distance.y);
				
                    if (length < 16)
                    {
                        impact.x = ball2.vx - ball.vx; //) * ball.restitution;
                        impact.y = ball2.vy - ball.vy; //) * ball.restitution;
					
						impulse.x = ball2.x - ball.x;
						impulse.y = ball2.y - ball.y;
								
						var mag : Number = Math.sqrt(impulse.x * impulse.x + impulse.y * impulse.y);
								
						if (mag > 0)
						{
							mag = 1 / mag;
							impulse.x *= mag;
							impulse.y *= mag;
						}
								
						impulseHalf.x = impulse.x * .5;
						impulseHalf.y = impulse.y * .5;
								
						ball.x -= impulseHalf.x;
						ball.y -= impulseHalf.y;
								
						ball2.x += impulseHalf.x;
						ball2.y += impulseHalf.y;
							
						var dot : Number = impact.x * impulse.x + impact.y * impulse.y;
								
						impulse.x *= dot;
						impulse.y *= dot;
								
						ball.vx += impulse.x * .9; // * ball.restitution;
						ball.vy += impulse.y * .9; // * ball.restitution;
						ball2.vx -= impulse.x * .9; //ball.restitution;
						ball2.vy -= impulse.y * .9; //ball.restitution;
                    }
                }
				
				ball.x += ball.vx += gravity.x;
				ball.y += ball.vy += gravity.y;
				
				if (ball.y < _radius || ball.y > stageHeight)
				{
					ball.vy *= -.8;
					ball.vx *= .98;
				}
				
				ball.y = (ball.y < _radius) ? _radius : (ball.y > stageHeight) ? stageHeight : ball.y;
					
				if (ball.x < _radius || ball.x > stageWidth)
				{
					ball.vx *= -.8;
				}
				
				ball.x = (ball.x < _radius) ? _radius : (ball.x > stageWidth) ? stageWidth : ball.x;
			}
        }
    }
}
