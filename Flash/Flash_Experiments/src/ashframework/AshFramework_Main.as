/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 12:36 PM
 */
package ashframework
{
	import ashframework.game.*;
	import flash.display.Sprite;
	import flash.events.Event;


	[SWF(width='600', height='450', frameRate='60', backgroundColor='#000000')]
	public class AshFramework_Main extends Sprite
	{
		private var game:Game;


		public function AshFramework_Main ()
		{
			addEventListener( Event.ENTER_FRAME, init );
		}


		private function init (e:Event):void
		{
			removeEventListener( Event.ENTER_FRAME, init);

			game = new Game (this, stage.stageWidth, stage.stageHeight);
			game.start();
		}
	}
}
