/**
 * Created with IntelliJ IDEA.
 * User: Isaac Dettman
 * Date: 4/1/13
 * Time: 3:47 PM
 */
package
{
	import flash.geom.Vector3D;


	public class OrbitalBody
	{
		public var name:String;
		public var isStar:Boolean;
		public var mass:Number;
		public var radius:Number;
		public var forceStore:Object;
		public var resultantForce:Vector3D;
		public var lastPosition:Vector3D;
		public var position:Vector3D;
		public var velocity:Vector3D;
		public var acceleration:Vector3D;
		public var motionEnabled:Boolean;
		public var accelerationEnabled:Boolean;
		public var forceChanged:Boolean;
		public var massMult:Number;

		// OrbitalBody Parameters
		// - mass : Default 1. The mass of this body in gigagrams.
		// - radius : Default 1000. The radius of this body, in kilometres.
		// - position : Default [0, 0, 0]. The X, Y, and Z (right-handed, i.e. Z is up, Y is "left") starting coordinates of the body.
		// - velocity : Default [0, 0, 0]. The X, Y, and Z (right-handed as above) starting velocities of the body.
		// - motionEnabled : Default true. Whether or not this object should move.
		// - accelerationEnabled : Default true. Whether or not this object will have acceleration calculated for it.
		public function OrbitalBody (name:String, mass:Number = 1, radius:Number = 1000, position:Vector3D = null, velocity:Vector3D = null, isStar:Boolean = false, motionEnabled:Boolean = true, accelerationEnabled:Boolean = true)
		{
			// Name of the object.
			this.name = name;

			// Is this object a Star?
			this.isStar = isStar;

			// Mass of the object, in gigagrams.
			this.mass = mass;

			// Radius of the object, in kilometres.
			this.radius = radius;

			this.forceStore = {
				// External forces on the object will be kept here.
			};

			// The resultant force on the object. Calculated at runtime.
			this.resultantForce = new Vector3D ();

			this.position = position;
			this.velocity = velocity;

			// The acceleration vector of the object, including gravity (if enabled). Calculated at runtime.
			this.acceleration = new Vector3D ();

			this.motionEnabled = motionEnabled;
			this.accelerationEnabled = accelerationEnabled;
			this.forceChanged = false;
			this.massMult = 1;
		}

	}
}
