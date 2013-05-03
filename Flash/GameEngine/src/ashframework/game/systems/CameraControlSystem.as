/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 2:51 PM
 */
package ashframework.game.systems
{
	import ash.tools.ListIteratingSystem;

	import ashframework.game.nodes.CameraControlNode;
	import ashframework.input.KeyPoll;
	import ashframework.input.MousePoll;

	import away3d.cameras.Camera3D;

	import flash.geom.Vector3D;
	import flash.ui.Keyboard;


	public class CameraControlSystem extends ListIteratingSystem
	{
		private var keyPoll:KeyPoll;
		private var mousePoll:MousePoll;
		private var camera:Camera3D;


		public function CameraControlSystem (keyPoll:KeyPoll, mousePoll:MousePoll, camera:Camera3D)
		{
			super (CameraControlNode, updateNode);
			this.camera = camera;
			this.keyPoll = keyPoll;
			this.mousePoll = mousePoll;

			camera.moveBackward (200);
			camera.moveUp (300);
			camera.lookAt (new Vector3D ());

		}


		private function updateNode (node:CameraControlNode, time:Number):void
		{
			//if (keyPoll.isDown(Keyboard.UP))
			if (keyPoll.isDown (Keyboard.CONTROL))
			{


				// Orbit camera
				if (mousePoll.leftMouseDown)
				{

				}

				// Pan camera
				if (mousePoll.middleMouseDown)
				{

				}

				// Move camera forward/backward
				if (mousePoll.rightMouseDown)
				{

				}

			}

		}
	}
}
