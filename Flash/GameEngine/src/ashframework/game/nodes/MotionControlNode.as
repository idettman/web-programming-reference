/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 2:53 PM
 */
package ashframework.game.nodes
{
	import ash.core.Node;
	import ashframework.game.components.MotionControls;
	import ashframework.game.components.Position;


	public class MotionControlNode extends Node
	{
		public var control:MotionControls;
		public var position:Position;
	}
}
