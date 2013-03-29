/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 3:50 PM
 */
package ashframework.game.components
{
	import away3d.containers.ObjectContainer3D;


	public class Display
	{
		public var displayObject:ObjectContainer3D;
		

		public function Display (displayObject:ObjectContainer3D)
		{
			this.displayObject = displayObject;
		}
	}
}
