package com.iad.orbitsim
{
	import away3d.entities.Mesh;

	import flash.geom.Vector3D;


	public class NBody
	{
		public var id:int;
		public var mass:Number;
		public var color:uint;
		public var position:Vector3D;
		public var velocity:Vector3D;
		public var acceleration:Vector3D;
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
		public var oldVelocity:Vector.<Vector3D>;// old velocities (really oldVelocity[0] would be oldPosition[0]-oldPosition[1])
		public var oldAcceleration:Vector.<Vector3D>;// old accelerations
		public var newOldVelocity:Vector.<Vector3D>;// new old velocities (for changing gears)
		public var newOldAcceleration:Vector.<Vector3D>;// new old accelerations (for changing gears)

		public var head:int;    // array offset of head of queues oldVelocity, oldAcceleration, newOldVelocity, newOldAcceleration

		// number of points used by step()
		public static var POINTS:int = 9;       // number of points in step method
		public static var PERIOD:int = POINTS - 1;// same error at oldVelocity[i] and oldVelocity[i+PERIOD]

		// size of queues
		public static var history:int = 2 * POINTS + 2;


		public function NBody (position:Vector3D, velocity:Vector3D, mass:Number, color:uint, radius:Number, id:int)
		{
			this.oldVelocity = new Vector.<Vector3D> (2 * history);
			this.oldAcceleration = new Vector.<Vector3D> (2 * history);
			this.newOldVelocity = new Vector.<Vector3D> (2 * history);
			this.newOldAcceleration = new Vector.<Vector3D> (2 * history);

			for (var i:int = 0; i < NBody.history; ++i)
			{
				this.oldVelocity[i] = this.oldVelocity[i + history] = new Vector3D ();
				this.oldAcceleration[i] = this.oldAcceleration[i + history] = new Vector3D ();
				this.newOldVelocity[i] = this.newOldVelocity[i + history] = new Vector3D ();
				this.newOldAcceleration[i] = this.newOldAcceleration[i + history] = new Vector3D ();
			}

			this.id = id;
			this.position = position;
			this.velocity = velocity;
			this.acceleration = new Vector3D ();
			this.mass = mass;
			this.radius = radius;
			this.color = color;
			this.head = NBody.history;
		}


		/**
		 * step - the step function, used to find the moon's next position
		 * This routine just sets p.
		 */
		public function step (inc:Number, tempValue:Vector3D):void
		{
			// An explicit symmetric multistep method for estimating the
			// next position.
			// See http://burtleburtle.net/bob/math/multistep.html
			// ov and oa are queues, where ov[head] is the most recent position.
			// v is just a temp variable here, not really velocity

			var point:Vector3D;

			velocity.setTo (0, 0, 0);

			tempValue = oldAcceleration[head].add (oldAcceleration[head + 7]);

			point = tempValue.clone ();
			point.scaleBy (22081.0 / 15120.0);
			velocity = velocity.add (point);

			tempValue = oldAcceleration[head + 1].add (oldAcceleration[head + 6]);

			point = tempValue.clone ();
			point.scaleBy (-7337.0 / 15120.0);
			velocity = velocity.add (point);

			tempValue = oldAcceleration[head + 2].add (oldAcceleration[head + 5]);

			point = tempValue.clone ();
			point.scaleBy (45765.0 / 15120.0);
			velocity = velocity.add (point);

			tempValue = oldAcceleration[head + 3].add (oldAcceleration[head + 4]);

			point = tempValue.clone ();
			point.scaleBy (-29.0 / 15120.0);
			velocity = velocity.add (point);

			velocity.scaleBy (inc * inc);
			velocity = velocity.add (oldVelocity[head + 7]);

			position = position.add (velocity);
		}


		/**
		 * estimateVelocityAtTime - estimate the velocity at time [head+POINTS/2] in v
		 */
		public function estimateVelocityAtTime (inc:Number, tempValue:Vector3D):void
		{
			var point:Vector3D;

			// Here are some increasingly accurate velocity estimates:
			//  1/2
			// -1/12,    2/3
			//  1/60,   -3/20,   3/4
			// -1/280,   4/105, -1/5,   4/5
			//  1/1260, -5/504,  5/84, -5/21,   5/6
			// -1/5544,  1/385, -1/56,  3/38, -15/56, 6/7
			velocity.setTo (0, 0, 0);

			tempValue = oldVelocity[head + 3].add (oldVelocity[head + 4]);

			point = tempValue.clone ();
			point.scaleBy ((4.0 / 5.0) / inc);
			velocity = velocity.add (point);

			tempValue = tempValue.add (oldVelocity[head + 2]);
			tempValue = tempValue.add (oldVelocity[head + 5]);

			point = tempValue.clone ();
			point.scaleBy ((-1.0 / 5.0) / inc);
			velocity = velocity.add (point);

			tempValue = tempValue.add (oldVelocity[head + 1]);
			tempValue = tempValue.add (oldVelocity[head + 6]);

			point = tempValue.clone ();
			point.scaleBy ((4.0 / 105.0) / inc);
			velocity = velocity.add (point);

			tempValue = tempValue.add (oldVelocity[head]);

			tempValue = tempValue.add (oldVelocity[head + 7]);

			point = tempValue.clone ();
			point.scaleBy ((-1.0 / 280.0) / inc);
			velocity = velocity.add (point);
		}
	}
}
