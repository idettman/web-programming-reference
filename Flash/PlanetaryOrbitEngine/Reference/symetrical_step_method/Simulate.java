/**
 * Simulate.java -- Simulate a set of moons
 *
 * By Bob Jenkins, July 1998
 * Permission granted to use, reuse, rewrite this without notifying me.
 *
 * Enhancement requests:
 * -- There are two types of simulation problems: taking too big a step,
 *    and a jitter that repeats every 8 points.
 *    - If the step size is too big for an accurate simulation, cut the 
 *      step size in half.  Preserve position, velocity, energy.  I don't
 *      know how to do this.
 *    - If the jitter gets big, use a irreversible step function that
 *      smooths out the jitter.  Use a step function that is the average of
 *      two symmetric step functions.  I don't know how to detect that this
 *      needs to be done, as opposed to needing to reduce the step size.
 * -- Provide an interface that reports the positions of objects at a given
 *    time.  Feed the positions of the planets as parameters, and provide
 *    a service giving the position of the planets at such-and-such a time.
 * -- Add relativity.  C should be a parameter.
 * -- Add a solar wind (for specified objects).
 * -- Allow the camera position to be on some object.
 * -- Allow the screen to fill your monitor.
 * -- Add controls.  Right-mouse button?  Menus on mouse-down?  Control panel?
 * -- Add controls for powered objects, like spacecraft.  To accomplish an
 *    instantaneous acceleration of x at time i, add 1/8th of x when 
 *    calculating positions i through i+7.  That's exact.
 * -- Add everything you need to simulate spacecraft orbits accurately.
 * -- Speed up the simulation when there are many objects, but preserve the
 *    accuracy.
 *    - 3D multipole method?  Reportedly very slow, but accurate.
 *    - Barnes-Hut octtree?  Reportedly very inaccurate.
 *    - Different simulation speed for different objects?  For the solar
 *      system and spacecraft, this seems most promising to me.
 */

import java.awt.*;
import java.lang.Math;
import java.util.*;

public final class Simulate {
    Moon    luna[];  // the set of moons being simulated
    Moon    showluna[];  // same moons, but in display order
    Point   temp;    // working memory;
    int     counter; // how many iterations have we done?
    int     display_count; // how many displays have we done?
    int     work;    // how much work to do per step
    int     firstmass; // first moon with mass
    double  inc;     // how big a step to take
    double  init_energy;    // initial total energy of the system
    double  display_num;    // number being displayed
    boolean display_energy; // should energy error be displayed?
    boolean no_perspective; // should we not display perspective?
    double  energy;  // total energy of the system, should be constant

    // some big local variables used by every moon
    BVector polyIn;
    BVector poly;
    Point   polyAccel[];
    Point   polyPosition[];

    // initialize the simulation
    public Simulate(Moon luna[], double inc, int work, 
		    boolean energy, boolean noperspective) {
	this.temp = new Point(0.0, 0.0, 0.0);
	this.luna = luna;
	this.counter = 0;
	this.work = work;
	this.inc  = inc;
	this.display_energy = energy;
	this.no_perspective = noperspective;

	this.poly = new BVector(Moon.dejit.length);
	this.polyIn = new BVector(Moon.dejit.length);
	this.polyAccel = new Point[Moon.dejit.length];
	this.polyPosition = new Point[Moon.dejit.length+2];
	for (int i=0; i<Moon.dejit.length; ++i) {
	    this.polyAccel[i] = new Point(0.0, 0.0, 0.0);
	    this.polyPosition[i+2] = new Point(0.0, 0.0, 0.0);
	}
	polyPosition[0] = new Point(0.0, 0.0, 0.0);
	polyPosition[1] = new Point(0.0, 0.0, 0.0);

	// put the moons in order, smallest first
	for (int i=0;  i<luna.length;  ++i) {
	    for (int j=i+1;  j<luna.length;  ++j) {
		if (luna[i].m > luna[j].m) {
		    Moon luna2 = luna[i];
		    luna[i] = luna[j];
		    luna[j] = luna2;
		}
	    }
	}
	// find the first moon with mass
	for (firstmass = 0;
	     firstmass < luna.length && luna[firstmass].m == 0;
	     ++firstmass)
	    ;

	// initialize the moons for display
	this.showluna = new Moon[luna.length];
	for (int i=0;  i<luna.length;  ++i) {
	    this.showluna[i] = luna[i];
	}

	// initialize the integrator
	getGoing();
    }

    /** 
     *  getGoing -- given initial (position, velocity) for all moons,
     *  1) scale up to the timestep you want to deal with
     *  2) fill a queue of ov.size consecutive positions and accelerations
     *  3) position yourself a step BEFORE the given starting point,
     *     since the display always increments before displaying.
     */
    final private void getGoing() {
	// put center of gravity, net velocity at (0,0,0)
	center();

	// Reverse the direction
	// also shrink the step to 2**-32 of its original size
	this.inc /= (work*65536.0*65536.0);
	for (int i=0; i<luna.length; ++i) {
	    luna[i].v.scale(-inc);
	}

	// calculate accelerations, increment, fill oa[head] and ov[head]
	moveToNewPoint();

	// given oa[0], correct ov[0] to really be op[0]-op[1]
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i]; 
	    q.ov[q.head].plusa(q.ov[q.head], 0.5*inc*inc, q.oa[q.head]); 
	}

	// initialize the history with the inaccurate formula
	for (int i=0; i<Moon.POINTS; ++i)
	    leapfrog();

	// bootstrap up to full speed, 2**32 times faster
	for (int i=0; i<32; ++i) {
	    DoubleStep();
	}

	// reverse directions so history covers the time just before starting
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];

	    // counter is how much history we actually have.
	    if (counter > q.history) 
		counter = q.history;

	    // fill nblah array with the reverse of the blah array
	    // we would have to negate velocity if we tracked it
	    for (int j=0; j<counter; ++j) {
		if (j < counter-1) {
		    q.p.minus(q.p, q.ov[q.head+j]);
		    q.nov[q.head+j].copy(q.ov[q.head+counter-j-2]);
		}
		q.nov[q.head+j].scale(-1.0);
		q.noa[q.head+j].copy(q.oa[q.head+counter-j-1]);
	    }

	    // swap blah and nblah arrays
	    Point tv[] = q.nov; q.nov = q.ov; q.ov = tv;
	    Point ta[] = q.noa; q.noa = q.oa; q.oa = ta;
	}

	this.display_num = 0.0;
	this.init_energy = FindEnergy();
    }



    // make the center of gravity and net momentum (0,0,0)
    final private void center() {
	double m = 0.0;  // total mass
	Point  p = new Point(0.0, 0.0, 0.0);  // center of gravity so far
	Point  v = new Point(0.0, 0.0, 0.0);  // mv is total momentum so far
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];
	    m += q.m;
	    v.plusa(v, q.m, q.v);
	    p.plusa(p, q.m, q.p);
	}
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];
	    q.v.plusa(q.v, -1.0/m, v);
	    q.p.plusa(q.p, -1.0/m, p);
	}
    }

    // Input: a correct new q.p and q.v for all moons q
    // Output: a correct new q.oa[head] q.ov[head] for all moons q
    final private void moveToNewPoint() {
	accel();

	// record that we have one more item
	++counter;
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];

	    // record the new position and velocity
	    if (--q.head < 0) q.head += Moon.history;
	    q.ov[q.head].copy(q.v);
	    q.oa[q.head].copy(q.a);
	}
    }

    /** 
     * step - the step function, used to find the next position of each moon
     */
    final private void step() {
	// stabilize the path if we need to
	if ((counter & 0x7) == 0) {
	    dejitter(1.0);
	}

	// find the new Point
	for (int i=0; i<luna.length; ++i) {
	    luna[i].step(inc, temp);
	}
    }

    /** leapfrog - find the new position for each moon, fast and inaccurate.
     *  p = p0 + (p0-p1) + inc*inc*a0
     *  p0, a0 is the most recent position, acceleration.  p1 is the previous.
     */
    final private void leapfrog() {
	// find the new point
	for (int i=0; i<luna.length; ++i) {
	    Moon  q = luna[i];

	    q.v.plusa(q.ov[q.head], inc*inc, q.oa[q.head]);
	    q.p.plus(q.p, q.v);
	}

	// do bookkeeping for having taken a step
	moveToNewPoint();
    }

    // Double the step size
    final private void DoubleStep() {

	// make sure enough history has actually been kept
	while (counter < Moon.history) {
	    // find the new Point
	    for (int i=0; i<luna.length; ++i) {
		luna[i].step(inc, temp);
	    }
	    moveToNewPoint();
	}

	// adjust the counter to the actual amount of history kept
	if (counter > Moon.history) 
	    counter = Moon.history;

	// make up the new history
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];
	    for (int j=0; j<counter; j+=2) {
		q.nov[q.head+j/2].plus(q.ov[q.head+j], q.ov[q.head+j+1]);
		q.noa[q.head+j/2].copy(q.oa[q.head+j]);
	    }
	    Point tv[] = q.nov;  q.nov = q.ov; q.ov = tv;
	    Point ta[] = q.noa;  q.noa = q.oa; q.oa = ta;
	}
    
	// and reset the counter
	counter = counter/2;
	inc *= 2;
    }

    // Remove jitter from all the paths of all moons
    final private void dejitter(double rescale) {
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];
	    temp.minus(q.ov[q.head], q.ov[q.head+1]);
	    temp.plusa(temp, -inc*inc, q.oa[q.head+1]);
	    double dp = temp.dot(temp);
	    double da = q.oa[q.head+1].dot(q.oa[q.head+1]);
	    if (dp > da*inc*inc/256.0 && da != 0.0) {
		// System.out.println("dejitter "+q.id+" "+dp/(da*inc*inc)+" "+
		//                    q.ov[q.head]+" "+q.ov[q.head+1]);
		q.dejitter(rescale, inc, polyIn, poly, 
			   polyAccel, polyPosition);
	    }
	}
    }

    // move all moons forward by one time increment
    final public void move() {
	for (int i=0; i<work; ++i) {
	    step();
	    moveToNewPoint();
	}
    }

    // Why not combine FindEnergy() and accel(), seeing how they use almost
    // the same logic?  Because accel() is the inner loop and FindEnergy()
    // is called 1000 times less often, that's why.
    private double FindEnergy() {
	double new_energy = 0.0;
	for (int i=firstmass; i<luna.length; ++i) {
	    Moon   q = luna[i];

	    // include the effects of acceleration from all other moons
	    double energy2 = 0.0;
	    for (int j=i+1; j<luna.length; ++j) {
		Moon q2 = luna[j];
		temp.minus(q2.p, q.p);
		for (int k=0; k<Moon.POINTS/2; ++k) {
		    temp.minus(temp, q2.ov[q2.head+k]);
		    temp.plus(temp, q.ov[q.head+k]);
		}
		energy2 += q2.m/Math.sqrt(temp.dot(temp));
	    }
	    // estimate the velocity
	    q.velocity(inc, temp);

	    // total energy is kinetic minus potential
	    new_energy += q.m*(0.5*q.v.dot(q.v) - energy2 );
	}
	return new_energy;
    }

    // determine the acceleration
    private void accel() {
	for (int i=0; i<luna.length; ++i) {
	    Moon q = luna[i];
	    q.a.zero();
	}
	// massless moons are moved by moons with mass
	for (int i=0; i<firstmass; ++i) {
	    Moon   q = luna[i];
	    for (int j=firstmass; j<luna.length; ++j) {
		Moon q2 = luna[j];
		temp.minus(q2.p, q.p);
		double scale = temp.dot(temp);
		double dist = Math.sqrt(scale);
		scale = 1.0/(scale*dist);
		q.a.plusa(  q.a, q2.m*scale, temp);
	    }
	}
	// all moons with mass affect each other
	for (int i=firstmass; i<luna.length; ++i) {
	    Moon   q = luna[i];
	    for (int j=i+1; j<luna.length; ++j) {
		Moon q2 = luna[j];
		temp.minus(q2.p, q.p);
		double scale = temp.dot(temp);
		double dist = Math.sqrt(scale);
		scale = 1.0/(scale*dist);
		q.a.plusa(  q.a, q2.m*scale, temp);
		q2.a.plusa(q2.a, -q.m*scale, temp);
	    }
	}
    }

    // erase all the current moons
    public void clear(Graphics bg) {
	for (int i=0; i<luna.length; ++i) {
	    int q = luna[i].screenr;
	    if (q > 2) {
		bg.fillOval(luna[i].screenx, luna[i].screeny, q, q);
	    } else {
		bg.fillRect(luna[i].screenx, luna[i].screeny, 
			    luna[i].screenx+q, luna[i].screeny+q);
	    }
	}
    }

    // draw new moons
    public void draw(Graphics bg, Eye camera) {
	++display_count;

	// Find new positions in screen coordinates
	for (int i=0; i<showluna.length; ++i) {
	    Moon q = showluna[i];
	    Point e = q.peye;
	    camera.map(e, q.p);
	    if (this.no_perspective) e.z = -camera.m[3].z;
	    if (e.z > q.r) {
		int r = (int)(camera.magnification*q.r/e.z);
		if (r < 1) r = 1;
		q.screenr = r;
		q.screenx = camera.mapx(e)-r/2;
		q.screeny = camera.mapy(e)-r/2;
		if (q.screenx+r < 0 || 
		    q.screeny+r < 0 ||
		    q.screenx > camera.centerx+camera.centerx ||
		    q.screeny > camera.centery+camera.centery) {
		    q.screenx = q.screeny = q.screenr = 0;
		}
	    } else {
		q.screenx = q.screeny = q.screenr = 0;
	    }
	}

	// sort so closest moons are drawn last
	// this is about linear, not quadratic, because already about ordered
	for (int i=showluna.length; --i > 0;) {
	    for (int j=i+1; 
		 --j > 0 && showluna[j].peye.z > showluna[j-1].peye.z;
		 ) {
		Moon q = showluna[j];
		showluna[j] = showluna[j-1];
		showluna[j-1]=q;
	    }
	}

	// draw the moons
	if (display_energy) {
	    bg.setColor(Color.black);
	    bg.drawString(display_count-1+" "+display_num, 2, 12);
	    if ((display_count & 0x3f) == 0) {
		display_num = (FindEnergy() - init_energy)/init_energy;
	    }
	    bg.setColor(Color.white);
	    bg.drawString(display_count+" "+display_num, 2, 12);
	}
	for (int i=0; i<showluna.length; ++i) {
	    int q = showluna[i].screenr;
	    if (q > 2) {
		bg.setColor(showluna[i].c);
		bg.fillOval(showluna[i].screenx, showluna[i].screeny, q, q);
	    } else if (q > 0) {
		bg.setColor(showluna[i].c);
		bg.fillRect(showluna[i].screenx, showluna[i].screeny, q, q);
	    }
	}
    }
}
