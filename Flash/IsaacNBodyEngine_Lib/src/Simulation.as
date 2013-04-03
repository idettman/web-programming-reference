/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 4/1/13
 * Time: 3:46 PM
 */
package
{
	import flash.geom.Vector3D;


	public class Simulation
	{
		public var core:Core;
		public var bodies:Vector.<OrbitalBody>;

		// We don't store a buffer of frames - just the latest one.
		// This means that when the program frame rate lowers, we end up
		// dropping frames to keep the simulation rate the same.

		// Frame rate should always be less than or equal to update rate.
		//public var posQueue:Queue = new Queue(1);
		public var count:int = 0;
		public var time:Number = 50 / 3;
		public var gcm:Number = 1;
		public var updateStep:Number = 90;

		// Planet positions and velocities taken from JPL's HORIZONS system,
		// for April 09, 2012, 00:00:00.0000CT.
		public function initSimulation ():void
		{
			init (
					new <Object>[
						{
							name: "Sun",
							position: new Vector3D (0, 0, 0),
							mass: 1.988435e24,
							velocity: new Vector3D (0, 0, 0),
							isStar: true,
							radius: 695500,
							texture: "external/planets/sun.jpg"
						},
						{
							name: "Mercury",
							position: new Vector3D (-34.34126304594736, -59.83881592398617, -1.738227286314569),
							mass: 3.3022e17,
							velocity: new Vector3D (3.242607697980190e-5, -2.190935367320673e-5, -4.765349365538239e-6),
							radius: 2439.7,
							texture: "external/planets/mercury.jpg"
						},
						{
							name: "Venus",
							position: new Vector3D (-102.3178380016565, 32.62303974857563, 6.352081275507866),
							mass: 4.869e18,
							velocity: new Vector3D (-1.080589728829473e-5, -3.352572735644723e-5, 1.643058486842552e-7),
							radius: 6051.9,
							texture: "external/planets/venus.jpg"
						},
						{
							name: "Earth",
							position: new Vector3D (-141.3464397912099, -49.70175623515072, 1.845629910630098e-3),
							mass: 5.9721986e18,
							velocity: new Vector3D (9.387467194099132e-6, -2.820546804750964e-5, -3.335489234220996e-10),
							radius: 6367.5,
							texture: "external/planets/earth.jpg"
						},
						{
							name: "Mars",
							position: new Vector3D (-247.0577964253138, 2.607918972403293, 6.120960274943644),
							mass: 6.5185e17,
							velocity: new Vector3D (6.507888620275963e-7, -2.216028295316947e-5, -4.802973165012580e-7),
							radius: 3386,
							texture: "external/planets/mars.jpg"
						},
						{
							name: "Jupiter",
							position: new Vector3D (480.9176848793924, 571.0765569421500, -13.13349118484296),
							mass: 1.8988e21,
							velocity: new Vector3D (-1.016103900367553e-5, 9.045517267735690e-6, 1.897925792649849e-7),
							radius: 69173,
							texture: "external/planets/jupiter.jpg"
						},
						{
							name: "Saturn",
							position: new Vector3D (-1308.125257452327, -631.8980859148376, 63.06897677571023),
							mass: 5.685e20,
							velocity: new Vector3D (3.671844960056266e-6, -8.711916465865464e-6, 4.785296340228841e-9),
							radius: 57316,
							texture: "external/planets/saturn.jpg"
						},
						{
							name: "Uranus",
							position: new Vector3D (2993.163750777438, 235.9479785280531, -37.89556426125482),
							mass: 8.6625e19,
							velocity: new Vector3D (-5.930129454709614e-7, 6.477979332815045e-6, 3.178365529507968e-8),
							radius: 25266,
							texture: "external/planets/uranus.jpg"
						},
						{
							name: "Neptune",
							position: new Vector3D (3914.732947116928, -2193.945531342488, -45.02107870865629),
							mass: 1.0278e20,
							velocity: new Vector3D (2.613881670696835e-6, 4.780319271610741e-6, -1.586835000701678e-7),
							radius: 24553,
							texture: "external/planets/neptune.jpg"
						},
						{
							name: "Pluto",
							position: new Vector3D (638.1080671989861, -4764.888577948751, 325.4419510356392),
							mass: 1.314e16,
							velocity: new Vector3D (5.476987352349563e-6, -3.403729996552767e-7, -1.528481974366561e-6),
							radius: 1173,
							texture: "external/planets/pluto.jpg"
						}
					]);
		}


		private function init (orbitalBodyData:Vector.<Object>):void
		{
			core = new Core ();
			bodies = new Vector.<OrbitalBody> ();

			for each (var object:Object in orbitalBodyData)
			{
				bodies.push (new OrbitalBody (object.name, object.mass, object.radius, object.position, object.velocity, object.isStar));
				// Handle graphics, if applicable.
				//Graphics.createModel(curr, JSON.config.scaling);
			}
		}


		// This is where n-body calculation occurs.
		public function update ():void
		{
			// Update the position of the planets. Use the updateStep specified by the user
			// (default: 1 second is 1 day).
			for (var i:int = 0; i < updateStep; i++)
			{
				for (var j:int = 0; j < bodies.length - 1; j++)
				{
					for (var k:int = j + 1; k < bodies.length; k++)
					{
						updateGravity (bodies[j], bodies[k]);
					}
				}
				for (var l:int = 0; l < bodies.length; l++)
				{
					core.movementModule (bodies[l]);
				}
			}
		}


		private function updateGravity (planet1:OrbitalBody, planet2:OrbitalBody):void
		{
			planet1.forceStore["gravity" + planet2.name] = core.gravitationalForce (planet1, planet2, gcm);
			planet2.forceStore["gravity" + planet1.name] = core.gravitationalForce (planet2, planet1, gcm);
		}

	}
}
