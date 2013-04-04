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
		//public static const timeStep:Number = 1440; // in seconds
		public static const timeStep:Number = 14400; // in seconds
		public static const G:Number = 6.67e-32; // in Newton square gigameters per gigagram squared
		
		private var _vector3d:Vector3D;
		

		// Movement Module, calls all other modules to modify an object's properties with regard to motion
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

		
		// Velocity Module, adjusts the position of the object, based on the velocity vector
		public function velocityModule (obj:OrbitalBody):Boolean
		{
			if (obj.motionEnabled)
			{
				var temp:Vector3D = obj.velocity.clone ();
				temp.scaleBy (timeStep);

				obj.position = obj.position.add (temp);
				return true;
			}
			return false;
		}


		// Acceleration Module, adjusts the velocity of the object, based on the acceleration vector
		public function accelerationModule (obj:OrbitalBody):Boolean
		{
			if (obj.accelerationEnabled)
			{
				var temp:Vector3D = obj.acceleration.clone ();
				temp.scaleBy (timeStep);
				obj.velocity = obj.velocity.add (temp);
				return true;
			}
			return false;
		}


		// Force Module, calculates the acceleration of an object based on the resultant forces on it
		public function forceModule (obj:OrbitalBody):Boolean
		{
			if (obj.motionEnabled && obj.forceChanged)
			{
				// Create a blank array for the resultant force
				var newResultant:Vector3D = new Vector3D ();

				// Iterate through the forces acting on the object and add them to the resultant force
				for (var force:String in obj.forceStore)
				{
					newResultant = newResultant.add (obj.forceStore[force] as Vector3D);
				}

				// Set the resultant force
				obj.resultantForce = newResultant;

				// Adjust the object's acceleration based on the resultant force
				obj.acceleration.setTo (obj.resultantForce.x / obj.mass, obj.resultantForce.y / obj.mass, obj.resultantForce.z / obj.mass);

				// Reset forceChanged
				obj.forceChanged = false;
				
				return true;
			}
			return false;
		}


		// Gravitational Force Function, given two objects, returns the vector of gravitational force between them, from the first object to the second
		public function gravitationalForce (obj1:OrbitalBody, obj2:OrbitalBody, gravConstMult:Number = 1):Vector3D
		{
			// Get the direction vector from the first object to the second
			_vector3d = obj2.position.subtract (obj1.position);
			
			
			// Get the distance between the two objects
			var distance:Number = _vector3d.length;
			
			// Get Gm1m2 and modify it according to the relevant multipliers
			var numerator:Number = G * gravConstMult * obj1.mass * obj1.massMult * obj2.mass * obj2.massMult;
			
			// Get the force between the two objects.
			var force:Number = numerator / (distance * distance);
			
			// Scale the direction vector to be the same magnitude as the force
			_vector3d.normalize ();
			_vector3d.scaleBy (force);
			
			obj1.forceChanged = true;
			
			return _vector3d.clone();
		}
	}
}
