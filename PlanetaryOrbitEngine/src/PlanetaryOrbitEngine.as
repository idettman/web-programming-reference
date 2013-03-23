package
{

	import flash.display.Sprite;


	public class PlanetaryOrbitEngine extends Sprite
	{
		public function PlanetaryOrbitEngine ()
		{
			var orbit:Orbit = addChild (new Orbit ()) as Orbit;

			orbit.init ();
		}
	}
}
