package com.iad.orbitsim
{
	import away3d.entities.Mesh;


	public class PlanetaryBody
	{
		public var id:int;
		public var mass:Number;
		public var color:uint;
		public var position:Point3D;
		public var velocity:Point3D;
		public var acceleration:Point3D;
		public var radius:Number;
		public var sphereMesh:Mesh;

		/*
		 oldVelocity,oldAcceleration,newOldVelocity,newOldAcceleration are circular queues of length HISTORY.
		 The array positions [i] and [i+history] must be pointers to the
		 same thing for this to work.

		 If you need this as a queue, the elements are in [head] to
		 [head+history-1].  If you just need to do something to all
		 entries, it's fine to do it on [0] to [history-1].

		 We store old velocities (really differences between consecutive
		 positions) rather than actual old positions so that we can represent
		 the velocity with full precision even when it is very small compared
		 to the position.
		 */
		public var oldVelocity:Vector.<Point3D>;// old velocities (really oldVelocity[0] would be oldPosition[0]-oldPosition[1])
		public var oldAcceleration:Vector.<Point3D>;// old accelerations
		public var newOldVelocity:Vector.<Point3D>;// new old velocities (for changing gears)
		public var newOldAcceleration:Vector.<Point3D>;// new old accelerations (for changing gears)

		public var head:int;    // array offset of head of queues oldVelocity, oldAcceleration, newOldVelocity, newOldAcceleration

		// number of points used by step()
		public static var POINTS:int = 9;       // number of points in step method
		public static var PERIOD:int = POINTS - 1;// same error at oldVelocity[i] and oldVelocity[i+PERIOD]
		
		// size of queues
		public static var history:int = 2 * POINTS + 2;
		


		public function PlanetaryBody (position:Point3D, velocity:Point3D, mass:Number, color:uint, radius:Number, id:int)
		{
			this.oldVelocity = new Vector.<Point3D>(2 * history);
			this.oldAcceleration = new Vector.<Point3D>(2 * history);
			this.newOldVelocity = new Vector.<Point3D>(2 * history);
			this.newOldAcceleration = new Vector.<Point3D>(2 * history);

			for (var i:int = 0; i < PlanetaryBody.history; ++i)
			{
				this.oldVelocity[i] = this.oldVelocity[i + history] = new Point3D ();
				this.oldAcceleration[i] = this.oldAcceleration[i + history] = new Point3D ();
				this.newOldVelocity[i] = this.newOldVelocity[i + history] = new Point3D ();
				this.newOldAcceleration[i] = this.newOldAcceleration[i + history] = new Point3D ();
			}

			this.id = id;
			this.position = position;
			this.velocity = velocity;
			this.acceleration = new Point3D ();
			this.mass = mass;
			this.radius = radius;
			this.color = color;
			this.head = PlanetaryBody.history;
		}


		/**
		 * step - the step function, used to find the moon's next position
		 * This routine just sets p.
		 */
		public function step (inc:Number, tempValue:Point3D):void
		{
			// An explicit symmetric multistep method for estimating the
			// next position.
			// See http://burtleburtle.net/bob/math/multistep.html
			// ov and oa are queues, where ov[head] is the most recent position.
			// v is just a temp variable here, not really velocity
			//velocity.setToZero ();
			velocity.setTo (0, 0, 0);

			tempValue = oldAcceleration[head].add (oldAcceleration[head + 7]);
			//tempValue.plus (oldAcceleration[head], oldAcceleration[head + 7]);

			velocity.plusMultiplied (velocity, 22081.0 / 15120.0, tempValue);

			tempValue = oldAcceleration[head+1].add (oldAcceleration[head + 6]);
			//tempValue.plus (oldAcceleration[head + 1], oldAcceleration[head + 6]);

			velocity.plusMultiplied (velocity, -7337.0 / 15120.0, tempValue);

			tempValue = oldAcceleration[head+2].add (oldAcceleration[head + 5]);
			//tempValue.plus (oldAcceleration[head + 2], oldAcceleration[head + 5]);

			velocity.plusMultiplied (velocity, 45765.0 / 15120.0, tempValue);

			tempValue = oldAcceleration[head+3].add (oldAcceleration[head + 4]);
			//tempValue.plus (oldAcceleration[head + 3], oldAcceleration[head + 4]);
			velocity.plusMultiplied (velocity, -29.0 / 15120.0, tempValue);
			velocity.scaleBy (inc * inc);

			velocity = velocity.add (oldVelocity[head + 7]);
			//velocity.plus (velocity, oldVelocity[head + 7]);

			position = position.add (velocity);
			//position.plus (position, velocity);
		}

		/**
		 * estimateVelocityAtTime - estimate the velocity at time [head+POINTS/2] in v
		 */
		public function estimateVelocityAtTime (inc:Number, tempValue:Point3D):void
		{
			// Here are some increasingly accurate velocity estimates:
			//  1/2
			// -1/12,    2/3
			//  1/60,   -3/20,   3/4
			// -1/280,   4/105, -1/5,   4/5
			//  1/1260, -5/504,  5/84, -5/21,   5/6
			// -1/5544,  1/385, -1/56,  3/38, -15/56, 6/7
			//velocity.setToZero ();
			velocity.setTo (0, 0, 0);

			tempValue = oldVelocity[head + 3].add (oldVelocity[head + 4]);
			//tempValue.plus (oldVelocity[head + 3], oldVelocity[head + 4]);   // temp = op[3]-op[5]

			velocity.plusMultiplied (velocity, (4.0 / 5.0) / inc, tempValue);

			tempValue = tempValue.add (oldVelocity[head + 2]);
			//tempValue.plus (tempValue, oldVelocity[head + 2]);

			tempValue = tempValue.add (oldVelocity[head + 5]);
			//tempValue.plus (tempValue, oldVelocity[head + 5]);         // temp = op[2]-op[6]

			velocity.plusMultiplied (velocity, (-1.0 / 5.0) / inc, tempValue);

			tempValue = tempValue.add (oldVelocity[head + 1]);
			//tempValue.plus (tempValue, oldVelocity[head + 1]);

			tempValue = tempValue.add (oldVelocity[head + 6]);
			//tempValue.plus (tempValue, oldVelocity[head + 6]);         // temp = op[1]-op[7]
			velocity.plusMultiplied (velocity, (4.0 / 105.0) / inc, tempValue);

			tempValue = tempValue.add (oldVelocity[head]);
			//tempValue.plus (tempValue, oldVelocity[head + 0]);

			tempValue = tempValue.add (oldVelocity[head + 7]);
			//tempValue.plus (tempValue, oldVelocity[head + 7]);         // temp = op[0]-op[8]

			velocity.plusMultiplied (velocity, (-1.0 / 280.0) / inc, tempValue);
		}
	}
}
