package ashframework.game.nodes
{
	import ash.core.*;

	import ashframework.game.components.DataModel;
	import ashframework.game.components.Fragments;
	import ashframework.game.components.Motion3D;
	import ashframework.game.components.Transform3D;


	public class FragmentsNode extends Node
	{
		public var dataModel:DataModel;
		public var fragments:Fragments;
		public var transform:Transform3D;
		public var motion:Motion3D;
	}
}
