/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 4:28 PM
 */
package ashframework.game.components
{
	import ash.fsm.EntityStateMachine;


	public class Spaceship
	{
		public var fsm:EntityStateMachine;


		public function Spaceship (fsm:EntityStateMachine)
		{
			this.fsm = fsm;
		}
	}
}
