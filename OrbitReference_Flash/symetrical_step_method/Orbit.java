/**
 * Orbit.java - an orbit simulator applet
 * By Bob Jenkins, July & August of 1998
 *
 * Recognized applet parameters:
 * "increment": how big a step to take between scenes
 * "background": the background color, eg "000000"
 * "work": the number of steps to do per increment, default is 5
 * "sleep": the number of milliseconds to sleep per display, default 50
 * "trail": leave trails; don't erase old positions of moons
 * "energy": report (current-initial)/initial total energy.  Any value.
 * "eye": how the camera is set up to view this,
 *    position, left(radians), up(radians), clockwise(radians), zoom
 *    "100.0 0.0 0.0 0.0 100.0"
 * "stop": any parameter causes applet to start off not moving
 * "length": length of simulation, stop after this point.
 * "scalemass": amount to scale all masses, default 1.0.  Easier than
 *    adjusting all velocities by sqrt(1/scalemass) when tuning things.
 * "moons": an integer, the number of moons, eg "3"
 * "moon1", "moon2", however many "moons" specified:
 *    position, velocity, mass, color, size.  For example:
 *   "p(0.0, 0.0, 0.0) v(0.0, 0.0, 0.0) 100.0 ffffff 10.0"
 * "follow": A moon number, eg 17.  Keep the eye positioned on moon 17.
 * "noperspective": No perspective -- treat distance as constant
 */
import java.applet.*;
import java.awt.*;
import java.lang.Math;

// An applet that controls an eye which views a set of moons
public final class Orbit extends Applet implements Runnable {
    double increment;       // how much to increment time each step
    double         t;       // time
    double         maxt;    // end of time;
    private Thread runner;  // background thread timing motions
    Eye            camera;  // camera for viewing the moons
    Simulate       sim;     // all the moons in the system
    Color          bgcolor; // background color
    boolean   should_move;  // should the objects be moving
    Image     buffered;     // double buffering buffer
    Graphics  bg;           // buffered.getGraphics()
    double    oldmousex;    // last handled mouse x
    double    oldmousey;    // last handled mouse y
    double    mousex;       // last recorded mouse x
    double    mousey;       // last recorded mouse y
    double    rotatescale;  // originally assume a screensized sphere
    boolean   drag;         // is the mouse draging the image?
    boolean   xymode;       // true is left/up, false is zoom/clockwise
    boolean   trail;        // leave trails?
    boolean   energy;       // occasionally report energy?
    int       work;         // how many substeps to do per iteration
    int       sleep;        // how long to sleep, in milliseconds
    Moon      follow;       // id of moon to follow,
    boolean   noperspective;// no perspective; like viewed from infinity
  
    public void init() {
	// set up infrastructure
	String param;
	this.t = -1.0;

	// get parameters
	this.bgcolor = Point.s2c(getParameter("background"), Color.black);

	this.increment = Point.s2d(getParameter("increment"), 0.1);

	this.maxt = Point.s2d(getParameter("length"), 1.0e30)/this.increment;

	this.should_move = (getParameter("stop") == null);

	this.trail = (getParameter("trail") != null);

	this.noperspective = (getParameter("noperspective") != null);

	this.work = (int)Point.s2d(getParameter("work"), 5);

	this.sleep = (int)Point.s2d(getParameter("sleep"), 50);

	// all the objects in the system
	param = getParameter("moons");
	Moon luna[];
	if (param==null) {
	    luna = new Moon[1];
	    luna[0] = 
		new Moon("p(0.0,0.0,0.0) v(0.0,0.0,0.0) 1000.0 00ff00 15.0",
			 1);
	} else {
	    int i=0;
	    luna = new Moon[Integer.parseInt(param)];
	    for (int j=0; i<luna.length; ++j) {
		param = getParameter("moon"+j);
		if (j > 2*luna.length) break;
		if (param==null) continue;
		luna[i] = new Moon(param, j);
		++i;
	    }
	    Moon luna2[] = new Moon[i];
	    for (int j=0; j<i; ++j) luna2[j] = luna[j];
	    luna = luna2;
	}

	if (Point.s2d(getParameter("follow"), -1) != -1) {
	    int tempint = (int)Point.s2d(getParameter("follow"), -1);
	    for (int i=0; i<luna.length; ++i) {
		if (luna[i].id == tempint) {
		    this.follow = luna[i];
		}
	    }
	}

	param = getParameter("energy");
	energy = (param!=null);

	double scalemass = Point.s2d(getParameter("scalemass"), 1.0);
	for (int i=0; i<luna.length; ++i) {
	    luna[i].m *= scalemass;
	}

	// the eye watching this world
	param = getParameter("eye");
	if (param==null) 
	    param = "10.0  0.0  0.0  0.0  20.0";
	this.camera = new Eye(param, size().width/2, size().height/2);
	this.drag = false;
	this.oldmousex = 0.0;
	this.oldmousey = 0.0;
	this.mousex = 0.0;
	this.mousey = 0.0;
	this.rotatescale = 
	    this.camera.magnification /
	    Math.min(size().width, size().height);
	this.sim = new Simulate(luna, this.increment, this.work, 
				energy, noperspective);
    }

    void startstop() {
	if (should_move && runner==null) {
	    if (t > maxt) { init(); }
	    runner = new Thread(this);
	    runner.start();
	} else if (!should_move && runner != null && runner.isAlive()) {
	    runner.stop();
	    runner = null;
	}
    }

    void clear() {
	bg.setColor(bgcolor);
	bg.fillRect(0, 0, size().width, size().height);
	bg.setColor(bgcolor.gray);
	bg.drawLine(0, 0, size().width, 0);
	bg.drawLine(0, 0, 0, size().height);
	bg.drawLine(size().width-1, 0, size().width-1, size().height-1);
	bg.drawLine(0, size().height-1, size().width-1, size().height-1);
    }

    public void start() {
	// if objects should be moving, start them moving again
	startstop();

	if (buffered == null) {
	    buffered = createImage(size().width, size().height);
	    bg = buffered.getGraphics();
	}

	// register that the screen needs painting
	repaint();
    }

    public void stop() {
	runner = null;

	if (bg != null) {
	    bg.dispose();
	    bg = null;
	}
	if (buffered != null) {
	    buffered = null;
	}
    }

    // mouse clicks turn the action on/off
    public boolean mouseUp(Event e, int x, int y) {
	if (!drag) {
	    should_move = (!should_move);
	    startstop();
	}
	drag = true;
	return true;
    }

    // mouse clicks turn the action on/off
    public boolean mouseDown(Event e, int x, int y) {
	mousex = (double)(x-this.camera.centerx);
	mousey = (double)(y-this.camera.centery);
	oldmousex = mousex;
	oldmousey = mousey;
	xymode = (4.0*(mousex*mousex + mousey*mousey) <
		  (double)Math.min(this.camera.centerx*this.camera.centerx, 
				   this.camera.centery*this.camera.centery));
	drag = false;
	return true;
    }

    // mouse clicks turn the action on/off
    public boolean mouseDrag(Event e, int x, int y) {
	mousex = (double)(x-this.camera.centerx);
	mousey = (double)(y-this.camera.centery);
	return true;
    }

    public void run() {
	while (runner != null) {
	    repaint();    // notify paint() that it needs to run
	    try {Thread.sleep(this.sleep);} catch (InterruptedException e) {}
	    if (t > maxt) {
		should_move = false;
		runner = null;
	    }
	}
    }

    // called by system in a separate thread when repaint() has been called.
    // Beware, several repaint()s may cause only one update() to happen.
    public void update(Graphics g) {
	paint(g);
    }

    public void paint(Graphics g) {
	if (bg == null) return;     // there seem to be some race conditions

	// find time increment
	if (t < 0.0) {
	    clear();
	}

	// erase old image
	if (!trail) {
	    bg.setColor(bgcolor);
	    clear();
	}

	// update camera
	double myx = mousex;
	double myy = mousey;
	double deltamousex = myx - oldmousex;
	double deltamousey = myy - oldmousey;
	if (deltamousex != 0 || deltamousey != 0) {
	    drag = true;
	    if (xymode) {          // xymode, roll simulation around the center
		double myrot = Math.atan2(deltamousex, deltamousey);
		double mynorm = (deltamousex*deltamousex + 
				 deltamousey*deltamousey);
		camera.clockwise(-myrot);
		if (mynorm <= 10) { // slow mouse can drag distant objects
		    camera.up(Math.sqrt(mynorm)*
			      (this.rotatescale/camera.magnification));
		} else {           // fast mouse spins quadratically fast
		    camera.up(mynorm*this.rotatescale/
			      (10*camera.magnification));
		}
		camera.clockwise(myrot);
	    } else {            // !xymode, zoom camera and spin it clockwise
		double mynorm = oldmousex*oldmousex + oldmousey*oldmousey;
		if (mynorm > 0.5) {
		    double myzoom = Math.sqrt((myx*myx + myy*myy) / mynorm);
		    camera.zoom(myzoom);
		    myx /= myzoom;
		    myy /= myzoom;
		    double myrot = Math.asin((oldmousey*myx - oldmousex*myy) /
					     mynorm);
		    camera.clockwise(myrot);
		}
	    }
	    oldmousex += (int)deltamousex;
	    oldmousey += (int)deltamousey;
	    if (trail) {
		clear();
	    }
	}
	if (follow != null) {
	    camera.center(follow.p);
	}

	// draw the moons in their new positions
	sim.draw(bg, camera);

	// actually display the new image
	this.getGraphics().drawImage(buffered, 0, 0, null);

	// compute new positions
	sim.move();
	t += 1.0;
    }
}
