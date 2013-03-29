/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 2:51 PM
 */
package ashframework.game.systems
{
	import ash.tools.ListIteratingSystem;

	import ashframework.game.components.MotionControls;
	import ashframework.game.components.Position;
	import ashframework.game.nodes.MotionControlNode;
	import ashframework.input.KeyPoll;


	public class MotionControlSystem extends ListIteratingSystem
	{
		private var keyPoll:KeyPoll;


		public function MotionControlSystem (keyPoll:KeyPoll)
		{
			super (MotionControlNode, updateNode);
			this.keyPoll = keyPoll;
		}


		private function updateNode (node:MotionControlNode, time:Number):void
		{
			var control:MotionControls = node.control;
			var position:Position = node.position;

			if (keyPoll.isDown(control.up))
			{
				position.position.y -= control.accelerationRate * time;
			}

			if (keyPoll.isDown(control.down))
			{
				position.position.y += control.accelerationRate * time;
			}

			if (keyPoll.isDown(control.left))
			{
				position.position.x -= control.accelerationRate * time;
			}

			if (keyPoll.isDown(control.right))
			{
				position.position.x += control.accelerationRate * time;
			}

		}
	}
}
