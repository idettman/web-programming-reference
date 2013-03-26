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
		
		// method to build polynomials to dejitter and rescale
		public static var dejitter:InterpolateBVector = new InterpolateBVector (POINTS);


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
			velocity.setToZero ();
			tempValue.plus (oldAcceleration[head], oldAcceleration[head + 7]);
			velocity.plusMultiplied (velocity, 22081.0 / 15120.0, tempValue);
			tempValue.plus (oldAcceleration[head + 1], oldAcceleration[head + 6]);
			velocity.plusMultiplied (velocity, -7337.0 / 15120.0, tempValue);
			tempValue.plus (oldAcceleration[head + 2], oldAcceleration[head + 5]);
			velocity.plusMultiplied (velocity, 45765.0 / 15120.0, tempValue);
			tempValue.plus (oldAcceleration[head + 3], oldAcceleration[head + 4]);
			velocity.plusMultiplied (velocity, -29.0 / 15120.0, tempValue);
			velocity.scaleBy (inc * inc);
			velocity.plus (velocity, oldVelocity[head + 7]);
			position.plus (position, velocity);
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
			velocity.setToZero ();
			tempValue.plus (oldVelocity[head + 3], oldVelocity[head + 4]);   // temp = op[3]-op[5]
			velocity.plusMultiplied (velocity, (4.0 / 5.0) / inc, tempValue);
			tempValue.plus (tempValue, oldVelocity[head + 2]);
			tempValue.plus (tempValue, oldVelocity[head + 5]);         // temp = op[2]-op[6]
			velocity.plusMultiplied (velocity, (-1.0 / 5.0) / inc, tempValue);
			tempValue.plus (tempValue, oldVelocity[head + 1]);
			tempValue.plus (tempValue, oldVelocity[head + 6]);         // temp = op[1]-op[7]
			velocity.plusMultiplied (velocity, (4.0 / 105.0) / inc, tempValue);
			tempValue.plus (tempValue, oldVelocity[head + 0]);
			tempValue.plus (tempValue, oldVelocity[head + 7]);         // temp = op[0]-op[8]
			velocity.plusMultiplied (velocity, (-1.0 / 280.0) / inc, tempValue);
		}

		/*
		 * Remove jitter from this moon's path.
		 * Use "rescale" to shrink the stepsize.
		 */
		public function dejitter (rescale:Number, increment:Number, polyIn:BVector, poly:BVector, polyAccel:Vector.<Point3D>, polyPosition:Vector.<Point3D>):void
		{
			var i:int;


			// Put the acceleration polynomial in polyAccel
			for (i = 0; i < dejitter.length; ++i)
			{polyIn.set (i, oldAcceleration[head + i].x);}
			dejitter.makeInterpolator (poly, polyIn);
			for (i = 0; i < dejitter.length; ++i)
			{polyAccel[i].x = poly.get (i);}

			for (i = 0; i < dejitter.length; ++i)
			{polyIn.set (i, oldAcceleration[head + i].y);}
			dejitter.makeInterpolator (poly, polyIn);
			for (i = 0; i < dejitter.length; ++i)
			{polyAccel[i].y = poly.get (i);}

			for (i = 0; i < dejitter.length; ++i)
			{polyIn.set (i, oldAcceleration[head + i].z);}
			dejitter.makeInterpolator (poly, polyIn);
			for (i = 0; i < dejitter.length; ++i)
			{polyAccel[i].z = poly.get (i);}

			// Integrate polyAccel twice to get the polyPosition
			polyPosition[0].setToZero ();
			polyPosition[1].setToZero ();

			for (i = 0; i < dejitter.length; ++i)
			{
				polyPosition[i + 2].copyFrom (polyAccel[i]);
				polyPosition[i + 2].scaleBy (increment * increment / ((i + 1) * (i + 2)));
			}


			// determine velocity, put it in polyPosition[1]
			newOldVelocity[head].evalPolynomialAtValue (polyPosition, dejitter.offset);
			newOldVelocity[head + PERIOD].evalPolynomialAtValue (polyPosition, PERIOD + dejitter.offset);
			polyPosition[1].plus (polyPosition[1], newOldVelocity[head]);
			polyPosition[1].minus (polyPosition[1], newOldVelocity[head + PERIOD]);

			velocity.setToZero ();

			for (i = 0; i < PERIOD; ++i)
			{
				velocity.plus (velocity, oldVelocity[head + i]);
			}

			polyPosition[1].minus (polyPosition[1], velocity);
			polyPosition[1].scaleBy (1 / PERIOD);

			// fill nov[0..POINTS-1], accounting for velocity
			newOldVelocity[head].evalPolynomialAtValue (polyPosition, dejitter.offset);

			for (i = 0; i < POINTS; ++i)
			{
				newOldVelocity[head + i].evalPolynomialAtValue (polyPosition, i + dejitter.offset);
				newOldVelocity[head + i - 1].minus (newOldVelocity[head + i - 1], newOldVelocity[head + i]);
			}


			// adjust the position
			polyPosition[0].setToZero ();   // this will be the sum of positions
			velocity.setToZero ();                 // v will be the current position

			for (i = 0; i < PERIOD - 1; ++i)
			{
				velocity.plus (velocity, newOldVelocity[head + i]);
				polyPosition[0].plus (polyPosition[0], velocity);
			}
			velocity.setToZero ();
			for (i = 0; i < PERIOD - 1; ++i)
			{
				velocity.plus (velocity, oldVelocity[head + i]);
				polyPosition[0].minus (polyPosition[0], velocity);
			}
			polyPosition[0].scaleBy (1.0 / PERIOD);

			// Evaluate and rescale positions
			if (rescale != 1)
			{
				//System.out.println("Dejitter rescale: Not implemented!!!");
			}
			else
			{
				// adjust positions
				position.plus (position, polyPosition[0]);
				var tv:Vector.<Point3D> = oldVelocity;
				oldVelocity = newOldVelocity;
				newOldVelocity = tv;
			}
		}
	}
}
