/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 1:37 PM
 */
package ashframework.game
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.fsm.EntityStateMachine;

	import ashframework.game.components.Display;

	import ashframework.game.components.GameState;
	import ashframework.game.components.MotionControls;
	import ashframework.game.components.NBody;
	import ashframework.game.components.Planet;
	import ashframework.game.components.Position;
	import ashframework.game.components.Spaceship;
	import ashframework.game.graphics.PlanetView;
	import ashframework.game.graphics.SpaceshipView;

	import flash.geom.Vector3D;

	import flash.ui.Keyboard;


	public class EntityCreator
	{
		private var engine:Engine;


		public function EntityCreator (engine:Engine)
		{
			this.engine = engine;
		}


		public function createGame ():Entity
		{
			var gameEntity:Entity = new Entity()
					.add (new GameState ());
			engine.addEntity (gameEntity);
			return gameEntity;
		}


		public function createPlanet (position:Vector3D, velocity:Vector3D, radius:Number, mass:Number):Entity
		{
			var planet:Entity = new Entity ()
					.add(new Planet())
					.add(new Position(position))
					.add(new NBody(mass,radius, velocity,0))
					.add(new PlanetView())

			engine.addEntity (planet);

			return planet;
		}


		public function createSpaceship (position:Vector3D):Entity
		{
			var spaceship:Entity = new Entity ();
			var fsm:EntityStateMachine = new EntityStateMachine (spaceship);

			fsm.createState ("playing")
					.add (MotionControls).withInstance (new MotionControls (Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, 60, 60))
					.add (Display).withInstance (new Display (new SpaceshipView ()));

			spaceship.add (new Spaceship (fsm)).add (new Position (position));
			fsm.changeState ("playing");

			engine.addEntity (spaceship);

			return spaceship;
		}
	}
}
