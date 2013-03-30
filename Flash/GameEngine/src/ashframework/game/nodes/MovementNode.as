package ashframework.game.nodes
{
	import ash.core.Node;

	import ashframework.game.components.Motion3D;
	import ashframework.game.components.Transform3D;


	public class MovementNode extends Node
	{
		public var position : Transform3D;
		public var motion : Motion3D;
	}
}
