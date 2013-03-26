package
{

	import com.iad.orbitsim.TestOrbitSimulation;

	import flash.display.Sprite;


	[SWF(width="1024",height="720",frameRate="60",backgroundColor="000000")]
	public class PlanetaryOrbitEngine extends Sprite
	{
		public function PlanetaryOrbitEngine ()
		{
			var orbit:TestOrbitSimulation = addChild (new TestOrbitSimulation ()) as TestOrbitSimulation;
			orbit.init ();
		}
	}
}
