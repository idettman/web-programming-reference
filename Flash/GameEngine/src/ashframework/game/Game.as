/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 12:38 PM
 */
package ashframework.game
{
	import ash.core.Engine;
	import ash.tick.FrameTickProvider;

	import ashframework.game.systems.GameManager;
	import ashframework.game.systems.MotionControlSystem;
	import ashframework.game.systems.RenderSystem;
	import ashframework.game.systems.SystemPriorities;
	import ashframework.input.KeyPoll;

	import flash.display.DisplayObjectContainer;


	public class Game
	{
		private var container:DisplayObjectContainer;
		private var engine:Engine;
		private var keyPoll:KeyPoll;
		private var tickProvider:FrameTickProvider;
		private var creator:EntityCreator;
		private var config:GameConfig;


		public function Game (container:DisplayObjectContainer, width:Number, height:Number)
		{
			this.container = container;
			prepare (width, height);
		}


		private function prepare (width:Number, height:Number):void
		{
			engine = new Engine ();
			creator = new EntityCreator (engine);
			keyPoll = new KeyPoll (container.stage);
			config = new GameConfig ();
			config.width = width;
			config.height = height;

			engine.addSystem (new GameManager (creator, config), SystemPriorities.preUpdate);
			engine.addSystem (new MotionControlSystem (keyPoll), SystemPriorities.update);
			engine.addSystem (new RenderSystem (container), SystemPriorities.render);


			creator.createGame();
		}


		public function start ():void
		{
			tickProvider = new FrameTickProvider (container);
			tickProvider.add (engine.update);
			tickProvider.start ();
		}
	}
}
