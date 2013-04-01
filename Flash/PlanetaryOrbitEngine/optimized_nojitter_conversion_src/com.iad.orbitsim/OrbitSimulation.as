package com.iad.orbitsim
{
	public class OrbitSimulation
	{

		public var timestepIncrement:Number;    // how big a step to take
		public var substepsPerIteration:int;    // how much work to do per step
		public var iterationCounter:int; 		// how many iterations have we done?
		public var firstMass:int; 				// first planetarybody with mass
		public var displayNum:Number;			// number being displayed
		public var initialTotalEnergy:Number;  	// initial total energy of the system

		public var planetaryBodies:Vector.<PlanetaryBody>;

		// instance placeholders
		private var _point3d:Point3D;
		private var _planetaryBody:PlanetaryBody;



		public function OrbitSimulation (planetaryBodies:Vector.<PlanetaryBody>, timestepIncrement:Number = 1, substepsPerIteration:int = 5)
		{
			this._point3d = new Point3D ();
			this.planetaryBodies = planetaryBodies;
			this.iterationCounter = 0;
			this.substepsPerIteration = substepsPerIteration;
			this.timestepIncrement = timestepIncrement;



			var i:int;

			// put the moons in order, smallest first
			for (i = 0; i < planetaryBodies.length; ++i)
			{
				for (var j:int = i + 1; j < planetaryBodies.length; ++j)
				{
					if (planetaryBodies[i].mass > planetaryBodies[j].mass)
					{
						var luna2:PlanetaryBody = planetaryBodies[i];
						planetaryBodies[i] = planetaryBodies[j];
						planetaryBodies[j] = luna2;
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

			for (i = 0; i < planetaryBodies.length; ++i)
			{
				planetaryBodies[i].velocity.scaleBy (-timestepIncrement);
			}

			// calculate accelerations, increment, fill oa[head] and ov[head]
			moveToNewPoint ();

			// given oa[0], correct ov[0] to really be op[0]-op[1]
			for (i = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];
				_planetaryBody.oldVelocity[_planetaryBody.head].plusMultiplied (_planetaryBody.oldVelocity[_planetaryBody.head], 0.5 * timestepIncrement * timestepIncrement, _planetaryBody.oldAcceleration[_planetaryBody.head]);
			}

			// initialize the history with the inaccurate formula
			for (i = 0; i < PlanetaryBody.POINTS; ++i)
				leapfrog ();

			// bootstrap up to full speed, 2**32 times faster
			for (i = 0; i < 32; ++i)
			{
				stepTwice ();
			}

			// reverse directions so history covers the time just before starting
			for (i = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				// counter is how much history we actually have.
				if (iterationCounter > PlanetaryBody.history)
					iterationCounter = PlanetaryBody.history;

				// fill nblah array with the reverse of the blah array
				// we would have to negate velocity if we tracked it
				for (var j:int = 0; j < iterationCounter; ++j)
				{
					if (j < iterationCounter - 1)
					{
						_planetaryBody.position = _planetaryBody.position.subtract (_planetaryBody.oldVelocity[_planetaryBody.head + j]);
						//_planetaryBody.position.minus (_planetaryBody.position, _planetaryBody.oldVelocity[_planetaryBody.head + j]);

						_planetaryBody.newOldVelocity[_planetaryBody.head + j].copyFrom (_planetaryBody.oldVelocity[_planetaryBody.head + iterationCounter - j - 2]);
					}
					_planetaryBody.newOldVelocity[_planetaryBody.head + j].scaleBy (-1.0);
					_planetaryBody.newOldAcceleration[_planetaryBody.head + j].copyFrom (_planetaryBody.oldAcceleration[_planetaryBody.head + iterationCounter - j - 1]);
				}

				// swap blah and nblah arrays
				var tv:Vector.<Point3D> = _planetaryBody.newOldVelocity;
				_planetaryBody.newOldVelocity = _planetaryBody.oldVelocity;
				_planetaryBody.oldVelocity = tv;
				var ta:Vector.<Point3D> = _planetaryBody.newOldAcceleration;
				_planetaryBody.newOldAcceleration = _planetaryBody.oldAcceleration;
				_planetaryBody.oldAcceleration = ta;
			}

			this.displayNum = 0;
			this.initialTotalEnergy = calculateEnergy ();
		}


		private function initCenterOfGravityAndMomentum ():void
		{
			var m:Number = 0.0;  // total mass
			var p:Point3D = new Point3D ();  // center of gravity so far
			var v:Point3D = new Point3D ();  // mv is total momentum so far

			var i:int;


			for (i = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				m += _planetaryBody.mass;
				v.plusMultiplied (v, _planetaryBody.mass, _planetaryBody.velocity);
				p.plusMultiplied (p, _planetaryBody.mass, _planetaryBody.position);
			}

			for (i = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				_planetaryBody.velocity.plusMultiplied (_planetaryBody.velocity, -1.0 / m, v);
				_planetaryBody.position.plusMultiplied (_planetaryBody.position, -1.0 / m, p);
			}
		}

		// In: _planetaryBody.p and _planetaryBody.v for all _planetaryBody
		// Out: _planetaryBody.oldAcceleration[head] _planetaryBody.oldVelocity[head] for all _planetaryBody
		private function moveToNewPoint ():void
		{
			calculateAcceleration ();

			// record that we have one more iteration
			++iterationCounter;
			for (var i:int = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				// record the new position and velocity
				if (--_planetaryBody.head < 0)
					_planetaryBody.head += PlanetaryBody.history;

				_planetaryBody.oldVelocity[_planetaryBody.head].copyFrom (_planetaryBody.velocity);
				_planetaryBody.oldAcceleration[_planetaryBody.head].copyFrom (_planetaryBody.acceleration);
				//trace (tempMoon.position.x, tempMoon.position.y, tempMoon.position.z);
			}
		}


		/** leapfrog - find the new position for each moon, fast and inaccurate.
		 *  p = p0 + (p0-p1) + inc*inc*a0
		 *  p0, a0 is the most recent position, acceleration.  p1 is the previous.
		 */
		private function leapfrog ():void
		{
			// find the new point
			for (var i:int = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				_planetaryBody.velocity.plusMultiplied (_planetaryBody.oldVelocity[_planetaryBody.head], timestepIncrement * timestepIncrement, _planetaryBody.oldAcceleration[_planetaryBody.head]);
				//_planetaryBody.position.plus (_planetaryBody.position, _planetaryBody.velocity);
				_planetaryBody.position = _planetaryBody.position.add (_planetaryBody.velocity);
			}

			// do bookkeeping for having taken a step
			moveToNewPoint ();
		}

		private function stepTwice ():void
		{
			var i:int;


			// make sure enough history has actually been kept
			while (iterationCounter < PlanetaryBody.history)
			{
				// find the new Point
				for (i = 0; i < planetaryBodies.length; ++i)
				{
					planetaryBodies[i].step (timestepIncrement, _point3d);
				}
				moveToNewPoint ();
			}

			// adjust the counter to the actual amount of history kept
			if (iterationCounter > PlanetaryBody.history)
				iterationCounter = PlanetaryBody.history;

			// make up the new history
			for (i = 0; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				for (var j:int = 0; j < iterationCounter; j += 2)
				{
					//_planetaryBody.newOldVelocity[_planetaryBody.head + j / 2].plus (_planetaryBody.oldVelocity[_planetaryBody.head + j], _planetaryBody.oldVelocity[_planetaryBody.head + j + 1]);


					_planetaryBody.newOldVelocity[_planetaryBody.head + j / 2] = _planetaryBody.oldVelocity[_planetaryBody.head + j].add(_planetaryBody.oldVelocity[_planetaryBody.head + j + 1]);
					trace ("_planetaryBody.newOldVelocity[_planetaryBody.head + j / 2]:", _planetaryBody.newOldVelocity[_planetaryBody.head + j / 2]);


					_planetaryBody.newOldAcceleration[_planetaryBody.head + j / 2].copyFrom (_planetaryBody.oldAcceleration[_planetaryBody.head + j]);
				}

				var tv:Vector.<Point3D> = _planetaryBody.newOldVelocity;
				_planetaryBody.newOldVelocity = _planetaryBody.oldVelocity;
				_planetaryBody.oldVelocity = tv;

				var ta:Vector.<Point3D> = _planetaryBody.newOldAcceleration;
				_planetaryBody.newOldAcceleration = _planetaryBody.oldAcceleration;
				_planetaryBody.oldAcceleration = ta;
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
				for (var j:int = 0; j < planetaryBodies.length; ++j)
				{
					planetaryBodies[j].step (timestepIncrement, _point3d);
				}

				moveToNewPoint ();
			}
		}

		private function calculateEnergy ():Number
		{
			var new_energy:Number = 0;

			for (var i:int = firstMass; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				// include the effects of acceleration from all other moons
				var energy2:Number = 0;
				for (var j:int = i + 1; j < planetaryBodies.length; ++j)
				{
					var q2:PlanetaryBody = planetaryBodies[j];
					_point3d = q2.position.subtract (_planetaryBody.position);
					//_point3d.minus (q2.position, _planetaryBody.position);

					for (var k:int = 0; k < PlanetaryBody.POINTS / 2; ++k)
					{
						_point3d = _point3d.subtract (q2.oldVelocity[q2.head + k]);
						//_point3d.minus (_point3d, q2.oldVelocity[q2.head + k]);
						//_point3d.plus (_point3d, _planetaryBody.oldVelocity[_planetaryBody.head + k]);
						_point3d = _point3d.add (_planetaryBody.oldVelocity[_planetaryBody.head + k]);
					}
					energy2 += q2.mass / Math.sqrt (_point3d.dotProduct (_point3d));
				}
				// estimate the velocity
				_planetaryBody.estimateVelocityAtTime (timestepIncrement, _point3d);

				// total energy is kinetic minus potential
				new_energy += _planetaryBody.mass * (0.5 * _planetaryBody.velocity.dotProduct (_planetaryBody.velocity) - energy2 );
			}
			return new_energy;
		}

		private function calculateAcceleration ():void
		{
			var i:int;
			var j:int;
			var q2:PlanetaryBody;
			var scale:Number;
			var dist:Number;


			for (i = 0; i < planetaryBodies.length; ++i)
			{
				//planetaryBodies[i].acceleration.setToZero ();
				planetaryBodies[i].acceleration.setTo (0, 0, 0);
			}

			// massless moons are moved by moons with mass
			for (i = 0; i < firstMass; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				for (j = firstMass; j < planetaryBodies.length; ++j)
				{
					q2 = planetaryBodies[j];

					_point3d = q2.position.subtract (_planetaryBody.position);
					//_point3d.minus (q2.position, _planetaryBody.position);

					scale = _point3d.dotProduct (_point3d);
					dist = Math.sqrt (scale);
					scale = 1 / (scale * dist);
					_planetaryBody.acceleration.plusMultiplied (_planetaryBody.acceleration, q2.mass * scale, _point3d);
				}
			}

			// all moons with mass affect each other
			for (i = firstMass; i < planetaryBodies.length; ++i)
			{
				_planetaryBody = planetaryBodies[i];

				for (j = i + 1; j < planetaryBodies.length; ++j)
				{
					q2 = planetaryBodies[j];

					_point3d = q2.position.subtract (_planetaryBody.position);
					//_point3d.minus (q2.position, _planetaryBody.position);

					scale = _point3d.dotProduct (_point3d);
					dist = Math.sqrt (scale);
					scale = 1.0 / (scale * dist);
					_planetaryBody.acceleration.plusMultiplied (_planetaryBody.acceleration, q2.mass * scale, _point3d);
					q2.acceleration.plusMultiplied (q2.acceleration, -_planetaryBody.mass * scale, _point3d);
				}
			}
		}
	}
}
