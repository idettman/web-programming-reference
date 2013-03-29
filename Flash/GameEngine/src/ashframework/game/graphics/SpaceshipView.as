/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 4:24 PM
 */
package ashframework.game.graphics
{
	import flash.display.Shape;


	public class SpaceshipView extends Shape
	{
		public function SpaceshipView ()
		{
			graphics.beginFill (0xFF0000);
			graphics.moveTo( 10, 0 );
			graphics.lineTo( -7, 7 );
			graphics.lineTo( -4, 0 );
			graphics.lineTo( -7, -7 );
			graphics.lineTo( 10, 0 );
			graphics.endFill();
		}
	}
}
