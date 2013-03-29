/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 3:47 PM
 */
package ashframework.game.nodes
{
	import ash.core.Node;
	import ashframework.game.components.Display;
	import ashframework.game.components.Position;


	public class RenderNode extends Node
	{
		public var position:Position;
		public var display:Display;
	}
}
