/**
 * User: Isaac
 * Date: 3/29/13
 * Time: 12:28 AM
 */
package ashframework.game.nodes
{
	import ash.core.Node;

	import ashframework.game.components.NBody;

	import ashframework.game.components.Position;


	public class PhysicsNode extends Node
	{
		public var nbody:NBody;
		public var position:Position;
	}
}
