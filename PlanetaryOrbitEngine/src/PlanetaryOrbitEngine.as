package
{

	import flash.display.Sprite;


	[SWF(width="1920",height="1080",frameRate="60",backgroundColor="000000")]
	public class PlanetaryOrbitEngine extends Sprite
	{
		public function PlanetaryOrbitEngine ()
		{
			var orbit:Orbit = addChild (new Orbit ()) as Orbit;
			orbit.init ();
		}
	}
}
