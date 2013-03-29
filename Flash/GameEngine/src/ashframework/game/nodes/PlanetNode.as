/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 4:35 PM
 */
package ashframework.game.nodes
{
	import ash.core.Node;

	import ashframework.game.components.Planet;
	import ashframework.game.components.Position;


	public class PlanetNode extends Node
	{
		public var spaceship:Planet;
		public var position:Position;
	}
}
