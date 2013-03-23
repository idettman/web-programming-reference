/**
 * Moon.java -- Describes a moon
 *
 * By Bob Jenkins, July 1998
 * Permission granted to use, reuse, rewrite this without notifying me.
 *
 * This class (Moon) describes a moon and has single-moon routines.
 * The class Simulate controls all the moons.
 *
 * A lot of these class variables really ought to be local variables.
 * But my experience with Java is that local variables not only aren't
 * local, they aren't even garbage collected properly.  Bleah.
 */

import java.awt.*;
import java.lang.Math;
import java.util.*;

// An object.  It has mass, position, velocity, and other things
public final class Moon {
    Point    p;  // position
    Point    v;  // velocity
    Point    a;  // acceleration
    double   m;  // mass
    Color    c;  // color
    /*
      ov,oa,nop,noa are circular queues of length HISTORY.  
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
    Point    ov[];   // old velocities (really ov[0] would be op[0]-op[1])
    Point    oa[];   // old accelerations
    Point    nov[];  // new old velocities (for changing gears)
    Point    noa[];  // new old accelerations (for changing gears)
    int      head;    // array offset of head of queues ov, oa, nov, noa

    // number of points used by step()
    static final int POINTS  = 9;       // number of points in step method
    static final int PERIOD  = POINTS-1;// same error at ov[i] and ov[i+PERIOD]

    // size of queues
    static final int history = 2*POINTS + 2;

    // method to build polynomials to dejitter and rescale
    static final BInterpolate dejit = new BInterpolate(POINTS);

    double r;     // radius
    int    id;    // identifier
    int screenx;  // x coordinate on screen
    int screeny;  // y coordinate on screen
    int screenr;  // radius on screen
    Point peye;   // point as translated by the eye

    // p(x,y,z) v(x,y,z) mass color size
    // example, "p(0.0,0.0,0.0) v(0.0,0.0,0.0) 1.0 ff00ff 1.0"
    public Moon(String str, int id) {
	StringTokenizer st = new StringTokenizer(str, " pv(,)");
	Point  p = new Point(0.0, 0.0, 0.0);
	Point  v = new Point(0.0, 0.0, 0.0);  

	p.x = Point.s2d(st.nextToken(), 0.0);
	p.y = Point.s2d(st.nextToken(), 0.0);
	p.z = Point.s2d(st.nextToken(), 0.0);
	v.x = Point.s2d(st.nextToken(), 0.0);
	v.y = Point.s2d(st.nextToken(), 0.0);
	v.z = Point.s2d(st.nextToken(), 0.0);
	double mass = Point.s2d(st.nextToken(), 0.0);
	Color  c = Point.s2c(st.nextToken(), Color.white);
	double planetsize = Point.s2d(st.nextToken(), 0.0);
	setMoon(p,v,mass,c,planetsize,id);
    }

    public Moon(Point      p,    // position
		Point      v,    // velocity
		double     m,    // mass
		Color      c,    // color
		double     r,    // radius
		int        id)   // identifier
    { setMoon(p,v,m,c,r,id); }

    void setMoon(Point p, 
		 Point v, 
		 double m, 
		 Color c, 
		 double r, 
		 int id) {
	this.ov  = new Point[2*history];
	this.oa  = new Point[2*history];
	this.nov = new Point[2*history];
	this.noa = new Point[2*history];
	for (int i=0; i<Moon.history; ++i) {
	    this.ov[i]  = this.ov[i+history] = new Point(0.0, 0.0, 0.0);
	    this.oa[i]  = this.oa[i+history] = new Point(0.0, 0.0, 0.0);
	    this.nov[i] = this.nov[i+history] = new Point(0.0, 0.0, 0.0);
	    this.noa[i] = this.noa[i+history] = new Point(0.0, 0.0, 0.0);
	}
	this.id = id;
	this.p  = new Point(p.x, p.y, p.z);
	this.v  = new Point(v.x, v.y, v.z);
	this.a  = new Point(0.0, 0.0, 0.0);
	this.m = m;
	this.r = r;
	this.c = c;

	this.peye = new Point(0.0, 0.0, 0.0);
	this.head = Moon.history;
    }

    /**
     * step - the step function, used to find the moon's next position
     * This routine just sets p.
     */
    final void step(double inc, Point temp) {
	// An explicit symmetric multistep method for estimating the 
        // next position.
	// See http://burtleburtle.net/bob/math/multistep.html
	// ov and oa are queues, where ov[head] is the most recent position.
	// v is just a temp variable here, not really velocity
	v.zero();
	temp.plus(oa[head  ], oa[head+7]);
	v.plusa(v,   22081.0/15120.0, temp);
	temp.plus(oa[head+1], oa[head+6]);
	v.plusa(v,   -7337.0/15120.0, temp);
	temp.plus(oa[head+2], oa[head+5]);
	v.plusa(v,   45765.0/15120.0, temp);
	temp.plus(oa[head+3], oa[head+4]);
	v.plusa(v,     -29.0/15120.0, temp);
	v.scale(inc*inc);
	v.plus(v, ov[head+7]);
	p.plus(p, v);
    }

    /**
     * velocity - estimate the velocity at time [head+POINTS/2] in v
     */
    final void velocity(double inc, Point temp) {
	// Here are some increasingly accurate velocity estimates:
	//  1/2
	// -1/12,    2/3
	//  1/60,   -3/20,   3/4
	// -1/280,   4/105, -1/5,   4/5
	//  1/1260, -5/504,  5/84, -5/21,   5/6
	// -1/5544,  1/385, -1/56,  3/38, -15/56, 6/7
	v.zero();
	temp.plus(ov[head+3], ov[head+4]);   // temp = op[3]-op[5]
	v.plusa(v, (4.0/5.0)/inc, temp);
	temp.plus(temp, ov[head+2]);
	temp.plus(temp, ov[head+5]);         // temp = op[2]-op[6]
	v.plusa(v, (-1.0/5.0)/inc, temp);
	temp.plus(temp, ov[head+1]);
	temp.plus(temp, ov[head+6]);         // temp = op[1]-op[7]
	v.plusa(v, (4.0/105.0)/inc, temp);
	temp.plus(temp, ov[head+0]);
	temp.plus(temp, ov[head+7]);         // temp = op[0]-op[8]
	v.plusa(v, (-1.0/280.0)/inc, temp);
    }

    /*
     * Remove jitter from this moon's path.
     * Use "rescale" to shrink the stepsize.
     */
    final void dejitter(double rescale, double increment,
			BVector polyIn, BVector poly, 
			Point polyAccel[], Point polyPosition[]) {
	// Put the acceleration polynomial in polyAccel
	for (int i=0; i<dejit.length; ++i) {polyIn.set(i, oa[head+i].x);}
	dejit.makeInterpolator(poly, polyIn);
	for (int i=0; i<dejit.length; ++i) {polyAccel[i].x = poly.get(i);}

	for (int i=0; i<dejit.length; ++i) {polyIn.set(i, oa[head+i].y);}
	dejit.makeInterpolator(poly, polyIn);
	for (int i=0; i<dejit.length; ++i) {polyAccel[i].y = poly.get(i);}

	for (int i=0; i<dejit.length; ++i) {polyIn.set(i, oa[head+i].z);}
	dejit.makeInterpolator(poly, polyIn);
	for (int i=0; i<dejit.length; ++i) {polyAccel[i].z = poly.get(i);}

	// Integrate polyAccel twice to get the polyPosition
	polyPosition[0].zero();
	polyPosition[1].zero();
	for (int i=0; i<dejit.length; ++i) {
	    polyPosition[i+2].copy(polyAccel[i]);
	    polyPosition[i+2].scale(increment*increment/((i+1)*(i+2)));
	}

	// determine velocity, put it in polyPosition[1]
	nov[head].eval(polyPosition, dejit.offset);
	nov[head+PERIOD].eval(polyPosition, PERIOD+dejit.offset);
	polyPosition[1].plus(polyPosition[1], nov[head]);
	polyPosition[1].minus(polyPosition[1], nov[head+PERIOD]);
	v.zero();
	for (int i=0; i<PERIOD; ++i) {
	    v.plus(v, ov[head+i]);
	}
	polyPosition[1].minus(polyPosition[1], v);
	polyPosition[1].scale(1.0/PERIOD);

	// fill nov[0..POINTS-1], accounting for velocity
	nov[head].eval(polyPosition, dejit.offset);
	for (int i=1; i<POINTS; ++i) {
	    nov[head+i].eval(polyPosition, i+dejit.offset);
	    nov[head+i-1].minus(nov[head+i-1], nov[head+i]);
	}

	// adjust the position
	polyPosition[0].zero();   // this will be the sum of positions
	v.zero();                 // v will be the current position
	for (int i=0; i<PERIOD-1; ++i) {
	    v.plus(v, nov[head+i]);
	    polyPosition[0].plus(polyPosition[0], v);
	}
	v.zero();
	for (int i=0; i<PERIOD-1; ++i) {
	    v.plus(v, ov[head+i]);
	    polyPosition[0].minus(polyPosition[0], v);
	}
	polyPosition[0].scale(1.0/PERIOD);

	// Evaluate and rescale positions
	if (rescale != 1.0) {
	    System.out.println("Dejitter rescale: Not implemented!!!");
	} else {
	    // adjust positions
	    p.plus(p, polyPosition[0]);
	    Point tv[] = ov; ov = nov; nov = tv;
	}
    }
}
