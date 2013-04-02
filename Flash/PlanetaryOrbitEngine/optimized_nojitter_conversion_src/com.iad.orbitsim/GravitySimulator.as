package com.iad.orbitsim
{
	import flash.geom.Vector3D;


	public class GravitySimulator
	{

		public var timestepIncrement:Number;    // how big a step to take
		public var substepsPerIteration:int;    // how much work to do per step
		public var iterationCounter:int; 		// how many iterations have we done?
		public var firstMass:int; 				// first planetarybody with mass
		public var displayNum:Number;			// number being displayed
		public var initialTotalEnergy:Number;  	// initial total energy of the system
		
		public var nBodyList:Vector.<NBody>;
		
		private var _nBody:NBody;
		private var _vector3d:Vector3D;
		

		public function GravitySimulator (nBodyList:Vector.<NBody>, timestepIncrement:Number = 1, substepsPerIteration:int = 5)
		{
			this._vector3d = new Vector3D ();
			this.nBodyList = nBodyList;
			this.iterationCounter = 0;
			this.substepsPerIteration = substepsPerIteration;
			this.timestepIncrement = timestepIncrement;
			
			var i:int;
			
			// put the moons in order, smallest first
			for (i = 0; i < nBodyList.length; ++i)
			{
				for (var j:int = i + 1; j < nBodyList.length; ++j)
				{
					if (nBodyList[i].mass > nBodyList[j].mass)
					{
						var nBody:NBody = nBodyList[i];
						nBodyList[i] = nBodyList[j];
						nBodyList[j] = nBody;
					}
				}
			}
			
			initIntegrator ();
		}
		

		/**
		 *  initIntegrator -- given initial (position, velocity) for all moons,
		 *  1) scale up to the timestep you want to deal with
		 *  2) fill a queue of ov.size consecutive positions and accelerations
		 *  3) position yourself a step BEFORE the given starting point,
		 *     since the display always increments before displaying.
		 */
		private function initIntegrator ():void
		{
			// put center of gravity, net velocity at (0,0,0)
			initCenterOfGravityAndMomentum ();

			// Reverse the direction
			// also shrink the step to 2**-32 of its original size
			this.timestepIncrement /= (substepsPerIteration * 65536 * 65536);
			
			var i:int;
			
			for (i = 0; i < nBodyList.length; ++i)
			{
				nBodyList[i].velocity.scaleBy (-timestepIncrement);
			}
			
			// calculate accelerations, increment, fill oa[head] and ov[head]
			moveToNewPoint ();
			
			var pointA:Vector3D;
			
			// given oa[0], correct ov[0] to really be op[0]-op[1]
			for (i = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				pointA = _nBody.oldAcceleration[_nBody.head].clone ();
				pointA.scaleBy (0.5 * timestepIncrement * timestepIncrement);
				_nBody.oldVelocity[_nBody.head] = _nBody.oldVelocity[_nBody.head].add (pointA);
			}

			// initialize the history with the inaccurate formula
			for (i = 0; i < NBody.POINTS; ++i)
				leapfrog ();

			// bootstrap up to full speed, 2**32 times faster
			for (i = 0; i < 32; ++i)
			{
				stepTwice ();
			}
			
			// reverse directions so history covers the time just before starting
			for (i = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				// counter is how much history we actually have.
				if (iterationCounter > NBody.history)
					iterationCounter = NBody.history;

				// fill nblah array with the reverse of the blah array
				// we would have to negate velocity if we tracked it
				for (var j:int = 0; j < iterationCounter; ++j)
				{
					if (j < iterationCounter - 1)
					{
						_nBody.position = _nBody.position.subtract (_nBody.oldVelocity[_nBody.head + j]);
						_nBody.newOldVelocity[_nBody.head + j].copyFrom (_nBody.oldVelocity[_nBody.head + iterationCounter - j - 2]);
					}
					_nBody.newOldVelocity[_nBody.head + j].scaleBy (-1.0);
					_nBody.newOldAcceleration[_nBody.head + j].copyFrom (_nBody.oldAcceleration[_nBody.head + iterationCounter - j - 1]);
				}

				// swap blah and nblah arrays
				var tv:Vector.<Vector3D> = _nBody.newOldVelocity;
				_nBody.newOldVelocity = _nBody.oldVelocity;
				_nBody.oldVelocity = tv;
				var ta:Vector.<Vector3D> = _nBody.newOldAcceleration;
				_nBody.newOldAcceleration = _nBody.oldAcceleration;
				_nBody.oldAcceleration = ta;
			}

			this.displayNum = 0;
			//this.initialTotalEnergy = calculateEnergy ();
		}


		private function initCenterOfGravityAndMomentum ():void
		{
			var m:Number = 0.0;  // total mass
			var p:Vector3D = new Vector3D ();  // center of gravity so far
			var v:Vector3D = new Vector3D ();  // mv is total momentum so far

			var i:int;

			var pointA:Vector3D;
			var pointB:Vector3D;

			for (i = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				m += _nBody.mass;

				pointA = _nBody.velocity.clone ();
				pointA.scaleBy (_nBody.mass);
				v = v.add (pointA);

				pointB = _nBody.position.clone ();
				pointB.scaleBy (_nBody.mass);
				p = p.add (pointB);
			}

			for (i = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				pointA = v.clone ();
				pointA.scaleBy (-1.0 / m);
				_nBody.velocity = _nBody.velocity.add (pointA);

				pointB = p.clone ();
				pointB.scaleBy (-1.0 / m);
				_nBody.position = _nBody.position.add (pointA);
			}
		}


		// In: _nBody.p and _nBody.v for all _nBody
		// Out: _nBody.oldAcceleration[head] _nBody.oldVelocity[head] for all _nBody
		private function moveToNewPoint ():void
		{
			calculateAcceleration ();

			// record that we have one more iteration
			++iterationCounter;
			for (var i:int = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				// record the new position and velocity
				if (--_nBody.head < 0)
					_nBody.head += NBody.history;

				_nBody.oldVelocity[_nBody.head].copyFrom (_nBody.velocity);
				_nBody.oldAcceleration[_nBody.head].copyFrom (_nBody.acceleration);
			}
		}


		/** leapfrog - find the new position for each moon, fast and inaccurate.
		 *  p = p0 + (p0-p1) + inc*inc*a0
		 *  p0, a0 is the most recent position, acceleration.  p1 is the previous.
		 */
		private function leapfrog ():void
		{
			var pointA:Vector3D;

			// find the new point
			for (var i:int = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				pointA = _nBody.oldAcceleration[_nBody.head].clone ();
				pointA.scaleBy (timestepIncrement * timestepIncrement);
				_nBody.velocity = _nBody.oldVelocity[_nBody.head].add (pointA);

				_nBody.position = _nBody.position.add (_nBody.velocity);
			}

			// do bookkeeping for having taken a step
			moveToNewPoint ();
		}


		private function stepTwice ():void
		{
			var i:int;
			
			// make sure enough history has actually been kept
			while (iterationCounter < NBody.history)
			{
				// find the new Point
				for (i = 0; i < nBodyList.length; ++i)
				{
					nBodyList[i].step (timestepIncrement, _vector3d);
				}
				moveToNewPoint ();
			}

			// adjust the counter to the actual amount of history kept
			if (iterationCounter > NBody.history)
				iterationCounter = NBody.history;

			var point:Vector3D;

			// make up the new history
			for (i = 0; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				for (var j:int = 0; j < iterationCounter; j += 2)
				{
					point = _nBody.oldVelocity[_nBody.head + j].add (_nBody.oldVelocity[_nBody.head + j + 1]);

					// The new old velocity must be comparing the object value since setting = new Vector3D breaks the physics
					_nBody.newOldVelocity[_nBody.head + j / 2].setTo (point.x, point.y, point.z);
					_nBody.newOldAcceleration[_nBody.head + j / 2].copyFrom (_nBody.oldAcceleration[_nBody.head + j]);
				}
				
				var tv:Vector.<Vector3D> = _nBody.newOldVelocity;
				_nBody.newOldVelocity = _nBody.oldVelocity;
				_nBody.oldVelocity = tv;

				var ta:Vector.<Vector3D> = _nBody.newOldAcceleration;
				_nBody.newOldAcceleration = _nBody.oldAcceleration;
				_nBody.oldAcceleration = ta;
			}

			// and reset the counter
			iterationCounter = iterationCounter / 2;
			timestepIncrement *= 2;
		}


		// move all moons forward by one time increment
		public function step ():void
		{
			for (var i:int = 0; i < substepsPerIteration; ++i)
			{
				// find the new Point
				for (var j:int = 0; j < nBodyList.length; ++j)
				{
					nBodyList[j].step (timestepIncrement, _vector3d);
				}

				moveToNewPoint ();
			}
		}


/*
		private function calculateEnergy ():Number
		{
			var new_energy:Number = 0;

			for (var i:int = firstMass; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				// include the effects of acceleration from all other moons
				var energy2:Number = 0;
				for (var j:int = i + 1; j < nBodyList.length; ++j)
				{
					var q2:NBody = nBodyList[j];
					_vector3d = q2.position.subtract (_nBody.position);

					for (var k:int = 0; k < NBody.POINTS / 2; ++k)
					{
						_vector3d = _vector3d.subtract (q2.oldVelocity[q2.head + k]);
						_vector3d = _vector3d.add (_nBody.oldVelocity[_nBody.head + k]);
					}
					energy2 += q2.mass / Math.sqrt (_vector3d.dotProduct (_vector3d));
				}
				// estimate the velocity
				_nBody.estimateVelocityAtTime (timestepIncrement, _vector3d);

				// total energy is kinetic minus potential
				new_energy += _nBody.mass * (0.5 * _nBody.velocity.dotProduct (_nBody.velocity) - energy2 );
			}
			return new_energy;
		}
*/


		private function calculateAcceleration ():void
		{
			var i:int;
			var j:int;
			var scale:Number;
			var dist:Number;
			var tempNBody:NBody;
			var tempVector3D:Vector3D;


			for (i = 0; i < nBodyList.length; ++i)
			{
				nBodyList[i].acceleration.setTo (0, 0, 0);
			}

			// massless moons are moved by moons with mass
			for (i = 0; i < firstMass; ++i)
			{
				_nBody = nBodyList[i];

				for (j = firstMass; j < nBodyList.length; ++j)
				{
					tempNBody = nBodyList[j];

					_vector3d = tempNBody.position.subtract (_nBody.position);

					scale = _vector3d.dotProduct (_vector3d);
					dist = Math.sqrt (scale);
					scale = 1 / (scale * dist);

					_vector3d.scaleBy (tempNBody.mass * scale);
					_nBody.acceleration = _nBody.acceleration.add (_vector3d);
				}
			}



			// all moons with mass affect each other
			for (i = firstMass; i < nBodyList.length; ++i)
			{
				_nBody = nBodyList[i];

				for (j = i + 1; j < nBodyList.length; ++j)
				{
					tempNBody = nBodyList[j];

					_vector3d = tempNBody.position.subtract (_nBody.position);

					scale = _vector3d.dotProduct (_vector3d);
					dist = Math.sqrt (scale);
					scale = 1.0 / (scale * dist);

					tempVector3D = _vector3d.clone ();
					tempVector3D.scaleBy (tempNBody.mass * scale);
					_nBody.acceleration = _nBody.acceleration.add (tempVector3D);

					_vector3d.scaleBy (-_nBody.mass * scale);
					tempNBody.acceleration = tempNBody.acceleration.add (_vector3d);
				}
			}
		}
	}
}
