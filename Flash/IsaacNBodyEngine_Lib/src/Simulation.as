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
		public var bodies:Vector.<OrbitalBody>;

		// Frame rate should always be less than or equal to update rate.
		public var updateStep:Number = 1;

		// Units
		// Distance: gigameters
		// Mass: gigagrams
		//public static const timeStep:Number = 1440; // in seconds
		public static const timeStep:Number = 14400; // in seconds
		public static const G:Number = 6.67e-32; // in Newton square gigameters per gigagram squared
		private var _vector3d:Vector3D;

		
		// Planet positions and velocities taken from JPL's HORIZONS system,
		// for April 09, 2012, 00:00:00.0000CT.
		final public function initSimulation ():void
		{
			init (
					new <Object>[
						{
							name: "Sun",
							position: new Vector3D (0, 0, 0),
							mass: 1.988435e24,
							velocity: new Vector3D (0, 0, 0),
							radius: 695500
						},
						{
							name: "Mercury",
							position: new Vector3D (-34.34126304594736, -59.83881592398617, -1.738227286314569),
							mass: 3.3022e17,
							velocity: new Vector3D (3.242607697980190e-5, -2.190935367320673e-5, -4.765349365538239e-6),
							radius: 2439.7
						},
						{
							name: "Venus",
							position: new Vector3D (-102.3178380016565, 32.62303974857563, 6.352081275507866),
							mass: 4.869e18,
							velocity: new Vector3D (-1.080589728829473e-5, -3.352572735644723e-5, 1.643058486842552e-7),
							radius: 6051.9
						},
						{
							name: "Earth",
							position: new Vector3D (-141.3464397912099, -49.70175623515072, 1.845629910630098e-3),
							mass: 5.9721986e18,
							velocity: new Vector3D (9.387467194099132e-6, -2.820546804750964e-5, -3.335489234220996e-10),
							radius: 6367.5
						},
						/*{
							name: "Earth_Moon",
							position: new Vector3D (-142.0464397912099, -51.60175623515072, 1.845629910630098e-3),
							mass: 3.344,
							velocity: new Vector3D (14.387467194099132e-6, -2.820546804750964e-5, -3.335489234220996e-10),
							radius: 1737.5
						},*/
						{
							name: "Mars",
							position: new Vector3D (-247.0577964253138, 2.607918972403293, 6.120960274943644),
							mass: 6.5185e17,
							velocity: new Vector3D (6.507888620275963e-7, -2.216028295316947e-5, -4.802973165012580e-7),
							radius: 3386
						},
						{
							name: "Jupiter",
							position: new Vector3D (480.9176848793924, 571.0765569421500, -13.13349118484296),
							mass: 1.8988e21,
							velocity: new Vector3D (-1.016103900367553e-5, 9.045517267735690e-6, 1.897925792649849e-7),
							radius: 69173
						},
						{
							name: "Saturn",
							position: new Vector3D (-1308.125257452327, -631.8980859148376, 63.06897677571023),
							mass: 5.685e20,
							velocity: new Vector3D (3.671844960056266e-6, -8.711916465865464e-6, 4.785296340228841e-9),
							radius: 57316
						},
						{
							name: "Uranus",
							position: new Vector3D (2993.163750777438, 235.9479785280531, -37.89556426125482),
							mass: 8.6625e19,
							velocity: new Vector3D (-5.930129454709614e-7, 6.477979332815045e-6, 3.178365529507968e-8),
							radius: 25266
						},
						{
							name: "Neptune",
							position: new Vector3D (3914.732947116928, -2193.945531342488, -45.02107870865629),
							mass: 1.0278e20,
							velocity: new Vector3D (2.613881670696835e-6, 4.780319271610741e-6, -1.586835000701678e-7),
							radius: 24553
						},
						{
							name: "Pluto",
							position: new Vector3D (638.1080671989861, -4764.888577948751, 325.4419510356392),
							mass: 1.314e16,
							velocity: new Vector3D (5.476987352349563e-6, -3.403729996552767e-7, -1.528481974366561e-6),
							radius: 1173
						}
					]);
		}


		final private function init (orbitalBodyData:Vector.<Object>):void
		{
			orbitalBodyData.fixed = true;
			bodies = new Vector.<OrbitalBody> ();
			for each (var object:Object in orbitalBodyData)
			{
				bodies.push (new OrbitalBody (object.name, object.mass, object.radius, object.position, object.velocity));
			}

			orbitalBodyData = null;
			bodies.fixed = true;
		}


		final public function update ():void
		{
			// Update the position of the planets. Use the updateStep specified by the user
			// (default: 1 second is 1 day).
/*
			for (var i:int = 0; i < updateStep; i++)
			{
			}
*/
			var j:int;
			var k:int;
			var bodyNum:int = bodies.length;
			for (j = 0; j < bodyNum-1; j++)
			{
				for (k = j + 1; k < bodyNum; k++)
				{
					updateGravitationalForce (bodies[j], bodies[k]);
				}
				updatePosition (bodies[j]);
			}
		}


		[Inline]
		final public function updatePosition (orbitalBody:OrbitalBody):void
		{
		// Force, calculates the acceleration of an object based on the resultant forces on it
			_vector3d.setTo (0, 0, 0);

			// Iterate through the forces acting on the object and add them to the resultant force
			for (var force:Object in orbitalBody.forceStore)
			{
				_vector3d.incrementBy (Vector3D (orbitalBody.forceStore[force]));
			}
			orbitalBody.resultantForce = _vector3d.clone();

			// Adjust the object's acceleration based on the resultant force
			orbitalBody.acceleration.setTo (orbitalBody.resultantForce.x / orbitalBody.mass, orbitalBody.resultantForce.y / orbitalBody.mass, orbitalBody.resultantForce.z / orbitalBody.mass);
			orbitalBody.forceChanged = false;


		// Acceleration, adjusts the velocity of the object, based on the acceleration vector
			_vector3d = orbitalBody.acceleration.clone ();
			_vector3d.scaleBy (timeStep);
			orbitalBody.velocity = orbitalBody.velocity.add (_vector3d);


		// Velocity, adjusts the position of the object, based on the velocity vector
			_vector3d = orbitalBody.velocity.clone ();
			_vector3d.scaleBy (timeStep);
			orbitalBody.position = orbitalBody.position.add (_vector3d);
		}


		[Inline]
		final public function updateGravitationalForce (orbitalBodyA:OrbitalBody, orbitalBodyB:OrbitalBody):void
		{
			// Update orbitalBodyA force

			// Get the direction vector from the first object to the second
			_vector3d = orbitalBodyB.position.subtract (orbitalBodyA.position);

			// Get the distance between the two objects
			var distance:Number = _vector3d.length;

			// Get the force between the two objects.
			var force:Number = (G * orbitalBodyA.mass * orbitalBodyA.massMult * orbitalBodyB.mass * orbitalBodyB.massMult) / (distance * distance);

			// Scale the direction vector to be the same magnitude as the force
			_vector3d.normalize ();
			_vector3d.scaleBy (force);

			orbitalBodyA.forceStore[orbitalBodyB] = _vector3d.clone();


			// Update orbitalBodyB force, inverse of orbitalBodyB
			_vector3d.negate ();
			orbitalBodyB.forceStore[orbitalBodyA] = _vector3d.clone();
		}
	}
}
