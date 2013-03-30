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

	import ashframework.game.systems.CameraControlSystem;

	import ashframework.game.systems.GameManager;
	import ashframework.game.systems.MotionControlSystem;
	import ashframework.game.systems.PhysicsSystem;
	import ashframework.game.systems.RenderSystem;
	import ashframework.game.systems.SystemPriorities;
	import ashframework.input.KeyPoll;
	import ashframework.input.MousePoll;

	import away3d.cameras.Camera3D;

	import away3d.containers.View3D;

	import flash.display.DisplayObjectContainer;


	public class Game
	{
		private var container:DisplayObjectContainer;
		private var engine:Engine;
		private var keyPoll:KeyPoll;
		private var mousePoll:MousePoll;
		private var tickProvider:FrameTickProvider;
		private var creator:EntityCreator;
		private var config:GameConfig;

		private var view:View3D;



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
			mousePoll = new MousePoll (container.stage);
			view = new View3D ();
			config = new GameConfig ();
			config.width = width; config.height = height;


			engine.addSystem (new GameManager (creator, config), SystemPriorities.preUpdate);
			engine.addSystem (new MotionControlSystem (keyPoll), SystemPriorities.update);
			engine.addSystem (new CameraControlSystem (keyPoll, mousePoll, view.camera), SystemPriorities.update);
			engine.addSystem (new PhysicsSystem (), SystemPriorities.resolveCollisions);
			engine.addSystem (new RenderSystem (container, view), SystemPriorities.render);


			creator.createCamera();
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
