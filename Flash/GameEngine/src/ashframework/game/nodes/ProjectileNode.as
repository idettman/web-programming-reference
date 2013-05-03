package ashframework.game.nodes
{
	import ash.core.*;

	import ashframework.game.components.DataModel;
	import ashframework.game.components.Motion3D;
	import ashframework.game.components.Projectile;
	import ashframework.game.components.Transform3D;


	public class ProjectileNode extends Node
	{
		public var dataModel:DataModel;
		public var projectile:Projectile;
		public var transform:Transform3D;
		public var motion:Motion3D;
	}
}
