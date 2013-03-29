/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 3:04 PM
 */
package ashframework.game.components
{
	public class MotionControls
	{
		public var up:uint = 0;
		public var down:uint = 0;
		public var left:uint = 0;
		public var right:uint = 0;
		
		public var rotationRate:Number = 0;
		public var accelerationRate:Number = 0;
		
		
		public function MotionControls (up:uint, down:uint, left:uint, right:uint, rotationRate:Number, accelerationRate:Number)
		{
			this.up = up;
			this.down = down;
			this.left = left;
			this.right = right;
			this.rotationRate = rotationRate;
			this.accelerationRate = accelerationRate;
		}
	}
}