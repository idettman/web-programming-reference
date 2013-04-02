/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 3/28/13
 * Time: 2:51 PM
 */
package ashframework.game.systems
{
	import ash.tools.ListIteratingSystem;

	import ashframework.game.components.NBody;
	import ashframework.game.components.Position;
	import ashframework.game.nodes.PhysicsNode;

	import com.iad.orbitsim.GravitySimulator;
	import com.iad.orbitsim.NBody;

	import flash.geom.Vector3D;


	public class PhysicsSystem extends ListIteratingSystem
	{
		private var orbitSimulation:GravitySimulator;


		public function PhysicsSystem ()
		{
			super (PhysicsNode, updateNode);
		}


		private function initOrbitSimulation ():void
		{
			var substepsPerIteration:int = 8;
			var timestepIncrement:Number = 100;
			var scaleMass:Number = 0.0000000012944;

			var planetaryBodyList:Vector.<com.iad.orbitsim.NBody> = new Vector.<com.iad.orbitsim.NBody> (10);
			planetaryBodyList[0] = new com.iad.orbitsim.NBody (
					new Vector3D (-0.008349066, 0.000189290, 0.000323565),
					new Vector3D (0.000000048, -0.000000348, -0.000000150),
					396.89, 0xffff00,
					0.0093289, 0);

			planetaryBodyList[1] = new com.iad.orbitsim.NBody (
					new Vector3D (-0.366950735, -0.233017122, -0.087053104),
					new Vector3D (0.000427802, -0.000791151, -0.000466931),
					0.0000658, 0xffdddd,
					0.0000329, 1);

			planetaryBodyList[2] = new com.iad.orbitsim.NBody (
					new Vector3D (0.517925495, -0.445522365, -0.233499924),
					new Vector3D (0.000576233, 0.000566230, 0.000218276),
					0.00097029, 0xddffdd,
					0.0000817, 2);

			planetaryBodyList[3] = new com.iad.orbitsim.NBody (
					new Vector3D (-0.18197903, 0.88819973, 0.38532644),
					new Vector3D (-0.000717186, -0.000118962, -0.000051576),
					0.0012067, 0x00ffff,
					0.0000847, 3);

			planetaryBodyList[4] = new com.iad.orbitsim.NBody (
					new Vector3D (-1.596538576, 0.436171769, 0.243237864),
					new Vector3D (-0.000152089, -0.000462584, -0.000208050),
					0.0001275, 0xff0000,
					0.0000451, 4);

			planetaryBodyList[5] = new com.iad.orbitsim.NBody (
					new Vector3D (4.940498284, 0.269444615, -0.004844226),
					new Vector3D (-0.000019658, 0.000301945, 0.000129905),
					0.379, 0xffdd88,
					0.0009641, 5);

			planetaryBodyList[6] = new com.iad.orbitsim.NBody (
					new Vector3D (7.791088486, 4.739656899, 1.622403811),
					new Vector3D (-0.000137611, 0.000178350, 0.000079578),
					0.11348, 0xffffff,
					0.0008109, 6);

			planetaryBodyList[7] = new com.iad.orbitsim.NBody (
					new Vector3D (13.408727053, -13.374109577, -6.047169310),
					new Vector3D (0.000119777, 0.000094894, 0.000039867),
					0.01728, 0x00ff00,
					0.0003452, 7);

			planetaryBodyList[8] = new com.iad.orbitsim.NBody (
					new Vector3D (15.848452622, -23.573132782, -10.043179759),
					new Vector3D (0.000110388, 0.000065394, 0.000024018),
					0.02038, 0x0077ff,
					0.000334, 8);

			planetaryBodyList[9] = new com.iad.orbitsim.NBody (
					new Vector3D (-10.984596612, -27.547235462, -5.287115643),
					new Vector3D (0.000124706, -0.000051827, -0.000053747),
					0.000002575, 0xccccff,
					0.0000155, 9);

			var i:int;
			var planet:com.iad.orbitsim.NBody;

			// scale masses
			for (i = 0; i < planetaryBodyList.length; ++i)
			{
				planet = planetaryBodyList[i];
				planet.mass *= scaleMass;
			}

			orbitSimulation = new GravitySimulator (planetaryBodyList, timestepIncrement, substepsPerIteration);

			// Create position debug lines
			/*for (i = 0; i < planetaryBodyList.length; ++i)
			 {
			 planet = planetaryBodyList[i];
			 sphereMesh = planet.sphereMesh;

			 sphereMesh.x = planet.position.x * SCALE_MULTIPLIER;
			 sphereMesh.y = planet.position.y * SCALE_MULTIPLIER;
			 sphereMesh.z = planet.position.z * SCALE_MULTIPLIER;
			 }*/
		}


		private function updateNode (node:PhysicsNode, time:Number):void
		{
			orbitSimulation.step ();

			var nbody:NBody = node.nbody;
			var position:Position = node.position;

		}
	}
}
