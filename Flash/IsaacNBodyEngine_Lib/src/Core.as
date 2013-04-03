/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 4/1/13
 * Time: 3:46 PM
 */
package
{
	import flash.geom.Vector3D;


	public class Core
	{
		// Units
		// Distance: gigameters
		// Mass: gigagrams
		public static const timeStep:Number = 1440; // in seconds
		public static const G:Number = 6.67e-32; // in Newton square gigameters per gigagram squared

		// Movement Module.
		// Calls all other modules to modify an object's properties with regard to motion.
		public function movementModule (obj:OrbitalBody):Boolean
		{
			if (obj.motionEnabled)
			{
				var forceChanged:Boolean = forceModule (obj);
				var accelerationChanged:Boolean = accelerationModule (obj);
				var velocityChanged:Boolean = velocityModule (obj);

				if (velocityChanged || accelerationChanged || forceChanged)
				{
					return true;
				}
			}
			return false;
		}


		// Velocity Module.
		// Adjusts the position of the object, based on the velocity vector.
		public function velocityModule (obj:OrbitalBody):Boolean
		{
			if (obj.motionEnabled)
			{
				var temp:Vector3D = obj.velocity.clone ();
				temp.scaleBy (timeStep);

				obj.position = obj.position.add (temp);
				//obj.position = ISAAC.Math.addVector(obj.motion.position, ISAAC.Math.scaleVector(obj.motion.velocity, ISAAC.Constants.timeStep));
				return true;
			}
			return false;
		}


		// Acceleration Module.
		// Adjusts the velocity of the object, based on the acceleration vector.
		public function accelerationModule (obj:OrbitalBody):Boolean
		{
			if (obj.accelerationEnabled)
			{
				var temp:Vector3D = obj.acceleration.clone ();
				temp.scaleBy (timeStep);

				obj.velocity = obj.velocity.add (temp);
				//obj.motion.velocity = ISAAC.Math.addVector(obj.motion.velocity, ISAAC.Math.scaleVector(obj.motion.acceleration, ISAAC.Constants.timeStep));
				return true;
			}
			return false;
		}


		// Force Module.
		// Calculates the acceleration of an object based on the resultant forces on it.
		public function forceModule (obj:OrbitalBody):Boolean
		{
			if (obj.motionEnabled && obj.forceChanged)
			{
				// Create a blank array for the resultant force.
				var newResultant:Vector3D = new Vector3D ();

				// Iterate through the forces acting on the object and add them
				// to the resultant force.
				for (var force:String in obj.forceStore)
				{
					//trace ("force:", force, obj);

					//newResultant.incrementBy (obj.forceStore[force] as Vector3D)
					newResultant = newResultant.add (obj.forceStore[force] as Vector3D);
					/*for(var i = 0; i < 3; i++) {
					 newResultant[i] += obj.forceStore[force][i];
					 }*/
				}

				// Set the resultant force.
				obj.resultantForce = newResultant;

				// Adjust the object's acceleration based on the resultant force.
				obj.acceleration.setTo (obj.resultantForce.x / obj.mass, obj.resultantForce.y / obj.mass, obj.resultantForce.z / obj.mass);
				/*for(var i:int = 0; i < 3; i++) {
				 obj.acceleration[i] = obj.resultantForce[i] / obj.mass;
				 }*/

				// Reset the forceChanged switch.
				obj.forceChanged = false;
				return true;
			}
			return false;
		}


		// Gravitational Force Function.
		// Given two objects, returns the vector of gravitational force between them, from the first object
		// to the second.
		public function gravitationalForce (obj1:OrbitalBody, obj2:OrbitalBody, gravConstMult:Number = 1):Vector3D
		{
			// Get the direction vector from the first object to the second.
			var directionVector:Vector3D = obj2.position.subtract (obj1.position);

			// Get the distance between the two objects.
			var distance:Number = directionVector.length;

			// Get Gm1m2 and modify it according to the relevant multipliers.
			var numerator:Number = G * gravConstMult * obj1.mass * obj1.massMult * obj2.mass * obj2.massMult;

			// Get the force between the two objects.
			var force:Number = numerator / (distance * distance);

			// Scale the direction vector to be the same magnitude as the force.

			directionVector.normalize ();
			directionVector.scaleBy (force);
			//directionVector = ISAAC.Math.vectorFitToLength(directionVector, force);

			obj1.forceChanged = true;

			return directionVector;
		}
	}
}
