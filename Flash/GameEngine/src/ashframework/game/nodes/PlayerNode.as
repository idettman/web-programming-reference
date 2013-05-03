package ashframework.game.nodes
{
	import ash.core.*;

	import ashframework.game.components.Motion3D;
	import ashframework.game.components.Player;
	import ashframework.game.components.Transform3D;


	public class PlayerNode extends Node
	{
		public var player:Player;
		public var transform:Transform3D;
		public var motion:Motion3D;
	}
}
