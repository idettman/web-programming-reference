/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 3:43 PM
 */
package ashframework.game.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;

	import ashframework.game.components.Display;
	import ashframework.game.components.Position;
	import ashframework.game.nodes.RenderNode;

	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;

	import flash.display.DisplayObjectContainer;


	public class RenderSystem extends System
	{
		public var container:DisplayObjectContainer;
		public var view:View3D;
		private var nodes:NodeList;



		public function RenderSystem (container:DisplayObjectContainer)
		{
			this.container = container;
			view = new View3D ();
		}


		override public function addToEngine (engine:Engine):void
		{
			container.addChild (view);

			var sphere:Mesh = new Mesh (new SphereGeometry (), new ColorMaterial (0xFF0000));
			view.scene.addChild (sphere);

			view.camera.moveBackward (800);
			view.camera.moveUp (200);
			view.camera.lookAt (sphere.position);

			nodes = engine.getNodeList (RenderNode);

			for (var node:RenderNode = RenderNode(nodes.head); node; node = RenderNode(node.next))
			{
				addToDisplay(node);
			}

			nodes.nodeAdded.add (addToDisplay);
			nodes.nodeRemoved.add (removeFromDisplay);
		}


		override public function removeFromEngine (engine:Engine):void
		{
			nodes = null;
		}


		private function addToDisplay (node:RenderNode):void
		{
			view.scene.addChild (node.display.displayObject);
		}


		private function removeFromDisplay (node:RenderNode):void
		{
			view.scene.removeChild (node.display.displayObject);
		}


		override public function update (time:Number):void
		{
			view.render ();

			var node:RenderNode;
			var position:Position;
			var display:Display;
			var displayObject:ObjectContainer3D;
			
			for (node = RenderNode(nodes.head); node; node = RenderNode(node.next))
			{
				display = node.display;
				displayObject = display.displayObject;
				position = node.position;

				displayObject.x = position.position.x;
				displayObject.y = position.position.y;
				displayObject.z = position.position.z;
			}
		}
	}
}
