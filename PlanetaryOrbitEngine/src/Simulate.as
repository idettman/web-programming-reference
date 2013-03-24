package
{
	import flash.display.Shape;


	public class Simulate
	{
		public var luna:Vector.<Moon>// the set of moons being simulated
		public var showluna:Vector.<Moon>// same moons, but in display order

		public var tempValue:Point;    // working memory;
		public var counter:int; // how many iterations have we done?
		public var display_count:int; // how many displays have we done?
		public var work:int;    // how much work to do per step
		public var firstmass:int; // first moon with mass
		public var inc:Number;     // how big a step to take
		public var init_energy:Number;    // initial total energy of the system
		public var display_num:Number;    // number being displayed
		public var display_energy:Boolean; // should energy error be displayed?
		public var no_perspective:Boolean; // should we not display perspective?
		public var energy:Number;  // total energy of the system, should be constant

		// some big local variables used by every moon
		public var polyIn:BVector;
		public var poly:BVector;
		public var polyAccel:Vector.<Point>;
		public var polyPosition:Vector.<Point>;


		// initialize the simulation
		public function Simulate (luna:Vector.<Moon>, inc:Number, work:int, energy:Boolean, noperspective:Boolean)
		{
			this.tempValue = new Point (0.0, 0.0, 0.0);
			this.luna = luna;
			this.counter = 0;
			this.work = work;
			this.inc = inc;
			this.display_energy = energy;
			this.no_perspective = noperspective;

			this.poly = new BVector (Moon.dejit.length);
			this.polyIn = new BVector (Moon.dejit.length);
			this.polyAccel = new Vector.<Point>(Moon.dejit.length);
			this.polyPosition = new Vector.<Point>(Moon.dejit.length + 2);

			for (var i:int = 0; i < Moon.dejit.length; ++i)
			{
				this.polyAccel[i] = new Point (0.0, 0.0, 0.0);
				this.polyPosition[i + 2] = new Point (0.0, 0.0, 0.0);
			}
			polyPosition[0] = new Point (0.0, 0.0, 0.0);
			polyPosition[1] = new Point (0.0, 0.0, 0.0);

			// put the moons in order, smallest first
			for (var i:int = 0; i < luna.length; ++i)
			{
				for (var j:int = i + 1; j < luna.length; ++j)
				{
					if (luna[i].m > luna[j].m)
					{
						var luna2:Moon = luna[i];
						luna[i] = luna[j];
						luna[j] = luna2;
					}
				}
			}
			// find the first moon with mass
			for (firstmass = 0; firstmass < luna.length && luna[firstmass].m == 0; ++firstmass)
				;

			// initialize the moons for display
			this.showluna = new Vector.<Moon>(luna.length);
			for (var i:int = 0; i < luna.length; ++i)
			{
				this.showluna[i] = luna[i];
			}

			// initialize the integrator
			getGoing ();
		}

		/**
		 *  getGoing -- given initial (position, velocity) for all moons,
		 *  1) scale up to the timestep you want to deal with
		 *  2) fill a queue of ov.size consecutive positions and accelerations
		 *  3) position yourself a step BEFORE the given starting point,
		 *     since the display always increments before displaying.
		 */
		private function getGoing ():void
		{
			// put center of gravity, net velocity at (0,0,0)
			center ();

			// Reverse the direction
			// also shrink the step to 2**-32 of its original size
			this.inc /= (work * 65536.0 * 65536.0);
			for (var i:int = 0; i < luna.length; ++i)
			{
				luna[i].v.scale (-inc);
			}

			// calculate accelerations, increment, fill oa[head] and ov[head]
			moveToNewPoint ();

			// given oa[0], correct ov[0] to really be op[0]-op[1]
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				q.ov[q.head].plusa (q.ov[q.head], 0.5 * inc * inc, q.oa[q.head]);
			}

			// initialize the history with the inaccurate formula
			for (var i:int = 0; i < Moon.POINTS; ++i)
				leapfrog ();

			// bootstrap up to full speed, 2**32 times faster
			for (var i:int = 0; i < 32; ++i)
			{
				DoubleStep ();
			}

			// reverse directions so history covers the time just before starting
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];

				// counter is how much history we actually have.
				if (counter > Moon.history)
					counter = Moon.history;

				// fill nblah array with the reverse of the blah array
				// we would have to negate velocity if we tracked it
				for (var j:int = 0; j < counter; ++j)
				{
					if (j < counter - 1)
					{
						q.p.minus (q.p, q.ov[q.head + j]);
						q.nov[q.head + j].copy (q.ov[q.head + counter - j - 2]);
					}
					q.nov[q.head + j].scale (-1.0);
					q.noa[q.head + j].copy (q.oa[q.head + counter - j - 1]);
				}

				// swap blah and nblah arrays
				var tv:Vector.<Point> = q.nov;
				q.nov = q.ov;
				q.ov = tv;
				var ta:Vector.<Point> = q.noa;
				q.noa = q.oa;
				q.oa = ta;
			}

			this.display_num = 0.0;
			this.init_energy = FindEnergy ();
		}


		// make the center of gravity and net momentum (0,0,0)
		private function center ():void
		{
			var m:Number = 0.0;  // total mass
			var p:Point = new Point (0.0, 0.0, 0.0);  // center of gravity so far
			var v:Point = new Point (0.0, 0.0, 0.0);  // mv is total momentum so far
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				m += q.m;
				v.plusa (v, q.m, q.v);
				p.plusa (p, q.m, q.p);
			}
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				q.v.plusa (q.v, -1.0 / m, v);
				q.p.plusa (q.p, -1.0 / m, p);
			}
		}

		// Input: a correct new q.p and q.v for all moons q
		// Output: a correct new q.oa[head] q.ov[head] for all moons q
		private function moveToNewPoint ():void
		{
			accel ();

			// record that we have one more item
			++counter;
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];

				// record the new position and velocity
				if (--q.head < 0) q.head += Moon.history;
				q.ov[q.head].copy (q.v);
				q.oa[q.head].copy (q.a);
			}
		}

		/**
		 * step - the step function, used to find the next position of each moon
		 */
		private function step ():void
		{
			// stabilize the path if we need to
			if ((counter & 0x7) == 0)
			{
				dejitter (1.0);
			}

			// find the new Point
			for (var i:int = 0; i < luna.length; ++i)
			{
				luna[i].step (inc, tempValue);
			}
		}

		/** leapfrog - find the new position for each moon, fast and inaccurate.
		 *  p = p0 + (p0-p1) + inc*inc*a0
		 *  p0, a0 is the most recent position, acceleration.  p1 is the previous.
		 */
		private function leapfrog ():void
		{
			// find the new point
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];

				q.v.plusa (q.ov[q.head], inc * inc, q.oa[q.head]);
				q.p.plus (q.p, q.v);
			}

			// do bookkeeping for having taken a step
			moveToNewPoint ();
		}

		// Double the step size
		private function DoubleStep ():void
		{

			// make sure enough history has actually been kept
			while (counter < Moon.history)
			{
				// find the new Point
				for (var i:int = 0; i < luna.length; ++i)
				{
					luna[i].step (inc, tempValue);
				}
				moveToNewPoint ();
			}

			// adjust the counter to the actual amount of history kept
			if (counter > Moon.history)
				counter = Moon.history;

			// make up the new history
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				for (var j:int = 0; j < counter; j += 2)
				{
					q.nov[q.head + j / 2].plus (q.ov[q.head + j], q.ov[q.head + j + 1]);
					q.noa[q.head + j / 2].copy (q.oa[q.head + j]);
				}
				var tv:Vector.<Point> = q.nov;
				q.nov = q.ov;
				q.ov = tv;
				var ta:Vector.<Point> = q.noa;
				q.noa = q.oa;
				q.oa = ta;
			}

			// and reset the counter
			counter = counter / 2;
			inc *= 2;
		}

		// Remove jitter from all the paths of all moons
		private function dejitter (rescale:Number):void
		{
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				tempValue.minus (q.ov[q.head], q.ov[q.head + 1]);
				tempValue.plusa (tempValue, -inc * inc, q.oa[q.head + 1]);
				var dp:Number = tempValue.dot (tempValue);
				var da:Number = q.oa[q.head + 1].dot (q.oa[q.head + 1]);
				if (dp > da * inc * inc / 256.0 && da != 0.0)
				{
					// System.out.println("dejitter "+q.id+" "+dp/(da*inc*inc)+" "+
					//                    q.ov[q.head]+" "+q.ov[q.head+1]);

					q.dejitter (rescale, inc, polyIn, poly, polyAccel, polyPosition);
				}
			}
		}

		// move all moons forward by one time increment
		public function move ():void
		{
			for (var i:int = 0; i < work; ++i)
			{
				step ();
				moveToNewPoint ();
			}
		}

		// Why not combine FindEnergy() and accel(), seeing how they use almost
		// the same logic?  Because accel() is the inner loop and FindEnergy()
		// is called 1000 times less often, that's why.
		private function FindEnergy ():Number
		{
			var new_energy:Number = 0.0;
			for (var i:int = firstmass; i < luna.length; ++i)
			{
				var q:Moon = luna[i];

				// include the effects of acceleration from all other moons
				var energy2:Number = 0.0;
				for (var j:int = i + 1; j < luna.length; ++j)
				{
					var q2:Moon = luna[j];
					tempValue.minus (q2.p, q.p);
					for (var k:int = 0; k < Moon.POINTS / 2; ++k)
					{
						tempValue.minus (tempValue, q2.ov[q2.head + k]);
						tempValue.plus (tempValue, q.ov[q.head + k]);
					}
					energy2 += q2.m / Math.sqrt (tempValue.dot (tempValue));
				}
				// estimate the velocity
				q.velocity (inc, tempValue);

				// total energy is kinetic minus potential
				new_energy += q.m * (0.5 * q.v.dot (q.v) - energy2 );
			}
			return new_energy;
		}

		// determine the acceleration
		private function accel ():void
		{
			for (var i:int = 0; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				q.a.zero ();
			}
			// massless moons are moved by moons with mass
			for (var i:int = 0; i < firstmass; ++i)
			{
				var q:Moon = luna[i];
				for (var j:int = firstmass; j < luna.length; ++j)
				{
					var q2:Moon = luna[j];
					tempValue.minus (q2.p, q.p);
					var scale:Number = tempValue.dot (tempValue);
					var dist:Number = Math.sqrt (scale);
					scale = 1.0 / (scale * dist);
					q.a.plusa (q.a, q2.m * scale, tempValue);
				}
			}
			// all moons with mass affect each other
			for (var i:int = firstmass; i < luna.length; ++i)
			{
				var q:Moon = luna[i];
				for (var j:int = i + 1; j < luna.length; ++j)
				{
					var q2:Moon = luna[j];
					tempValue.minus (q2.p, q.p);
					var scale:Number = tempValue.dot (tempValue);
					var dist:Number = Math.sqrt (scale);
					scale = 1.0 / (scale * dist);
					q.a.plusa (q.a, q2.m * scale, tempValue);
					q2.a.plusa (q2.a, -q.m * scale, tempValue);
				}
			}
		}

		// erase all the current moons
		/*public function clear (bg:Graphics):void
		{
			*//*
			 for (var i:int = 0; i < luna.length; ++i)
			 {
			 var q:int = luna[i].screenr;
			 if (q > 2)
			 {
			 bg.fillOval (luna[i].screenx, luna[i].screeny, q, q);
			 }
			 else
			 {
			 bg.fillRect (luna[i].screenx, luna[i].screeny, luna[i].screenx + q, luna[i].screeny + q);
			 }
			 }*//*
		}*/

		// draw new moons
		private var _count:uint = 0;
		public function draw (bg:Shape, camera:Eye):void
		{
			//camera.magnification+=1;
			
			
			//++display_count;

			// Find new positions in screen coordinates
			for (var i:int = 0; i < showluna.length; ++i)
			{
				var moon:Moon = showluna[i];
				var e:Point = moon.peye;
				camera.map (e, moon.p);
				if (this.no_perspective) e.z = -camera.m[3].z;
				if (e.z > moon.r)
				{
					var r:Number = (camera.magnification * moon.r / e.z);
					if (r < 1) r = 1;
					moon.screenr = r;
					moon.screenx = camera.mapx (e) - r / 2;
					moon.screeny = camera.mapy (e) - r / 2;
					if (moon.screenx + r < 0 ||
							moon.screeny + r < 0 ||
							moon.screenx > camera.centerx + camera.centerx ||
							moon.screeny > camera.centery + camera.centery)
					{
						moon.screenx = moon.screeny = moon.screenr = 0;
					}
				}
				else
				{
					moon.screenx = moon.screeny = moon.screenr = 0;
				}
			}

			// sort so closest moons are drawn last
			// this is about linear, not quadratic, because already about ordered
			for (var i:int = showluna.length; --i > 0;)
			{
				for (var j:int = i + 1; --j > 0 && showluna[j].peye.z > showluna[j - 1].peye.z;)
				{
					var moon2:Moon = showluna[j];
					showluna[j] = showluna[j - 1];
					showluna[j - 1] = moon2;
				}
			}
			
			// draw the moons
			if (display_energy)
			{
				/*bg.setColor (Color.black);
				bg.drawString (display_count - 1 + " " + display_num, 2, 12);
				if ((display_count & 0x3f) == 0)
				{
					display_num = (FindEnergy () - init_energy) / init_energy;
				}
				bg.setColor (Color.white);
				bg.drawString (display_count + " " + display_num, 2, 12);*/
			}
			for (var i:int = 0; i < showluna.length; ++i)
			{
				var q:Number = showluna[i].screenr;
				if (q > 2)
				{
					//bg.graphics.beginFill (0xFFFFFF);
					bg.graphics.beginFill (showluna[i].c.value);
					bg.graphics.drawCircle (showluna[i].screenx, showluna[i].screeny, q);
					//trace ("draw moon:", showluna[i].screenx, showluna[i].screeny, q);
				}
				else if (q > 0)
				{
//					bg.graphics.beginFill (0xFFFFFF);
					bg.graphics.beginFill (showluna[i].c.value);
					bg.graphics.drawRect (showluna[i].screenx, showluna[i].screeny, q, q);
				}
			}
		}

	}
}
