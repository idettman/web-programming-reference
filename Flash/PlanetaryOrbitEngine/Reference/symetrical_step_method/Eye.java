/**
 * eye.java -- manages a camera
 *
 * By Bob Jenkins, July 1998
 * Permission granted to use, reuse, rewrite this without notifying me.
 */

import java.lang.Math;
import java.util.*;

// the camera which translates 3D points to screen pixel coordinates
final public class Eye {
  public int  centerx;  // place 0.0,0.0 at (centerx, centery) on screen
  public int  centery;  // place 0.0,0.0 at (centerx, centery) on screen
  public double magnification;   // magnification of image
  public Point  m[];    // matrix describing angle & position
  Point  d[];           // matrix used to add rotations
  Point  rslm[];        // temporary result of matrix multiplication
  Point  p;             // temporary point

  // distance-from-center, left up clockwise magnification
  // example, "10.0 0.0 0.0 0.0 10.0"
  public Eye(String s, int centerx, int centery) {
    StringTokenizer st = new StringTokenizer(s," p(,)");
    this.p = new Point(0.0,0.0,0.0);

    this.p.x = 0.0;
    this.p.y = 0.0;
    this.p.z = -Point.s2d(st.nextToken(), 10.0);
    double left = Point.s2d(st.nextToken(), 0.0);
    double up = Point.s2d(st.nextToken(), 0.0);
    double clockwise = Point.s2d(st.nextToken(), 0.0);
    double magnification = Point.s2d(st.nextToken(), 1.0);

    setEye(this.p, left, up, clockwise, centerx, centery, magnification);
  }

  public Eye(Point p, double left, double up, double clockwise, 
	     int centerx, int centery, double magnification) {
    setEye(p, left, up, clockwise, centerx, centery, magnification);
  }

  void setEye(Point p,               // position of eye (done first)
	      double left,           // radians to rotate left (done second)
	      double up,             // radians to rotate up   (third)
	      double clockwise,      // radians to rotate clockwise (fourth)
	      int centerx,           // center of panel, x coord
	      int centery,           // center of panel, y coord
	      double magnification)  // controls size of image within panel
  {
    this.centerx = centerx;
    this.centery = centery;
    this.magnification = magnification;
    m    = new Point[5];
    m[0] = new Point(1.0, 0.0, 0.0);
    m[1] = new Point(0.0, 1.0, 0.0);
    m[2] = new Point(0.0, 0.0, 1.0);
    m[3] = new Point(p.x, p.y, p.z);
    m[4] = new Point(0.0, 0.0, 0.0);
    d    = new Point[3];
    d[0] = new Point(0.0, 0.0, 0.0);
    d[1] = new Point(0.0, 0.0, 0.0);
    d[2] = new Point(0.0, 0.0, 0.0);
    rslm    = new Point[3];
    rslm[0] = new Point(0.0, 0.0, 0.0);
    rslm[1] = new Point(0.0, 0.0, 0.0);
    rslm[2] = new Point(0.0, 0.0, 0.0);
    this.left(left);
    this.up(up);
    this.clockwise(clockwise);
  }

  // spin world left by x radians
  final public void left(double x) {
    d[0].x =  Math.cos(x); d[0].y = 0.0; d[0].z = Math.sin(x);
    d[1].x =  0.0;         d[1].y = 1.0; d[1].z = 0.0;
    d[2].x = -Math.sin(x); d[2].y = 0.0; d[2].z = Math.cos(x);
    mdt();
  }
  // spin world up by x radians
  final public void up(double x) {
    d[0].x = 1.0; d[0].y =  0.0;         d[0].z = 0.0;
    d[1].x = 0.0; d[1].y =  Math.cos(x); d[1].z = Math.sin(x);
    d[2].x = 0.0; d[2].y = -Math.sin(x); d[2].z = Math.cos(x);
    mdt();
  }
  // spin clockwise by x radians
  final public void clockwise(double x) {
    d[0].x =  Math.cos(x); d[0].y = Math.sin(x); d[0].z = 0.0;
    d[1].x = -Math.sin(x); d[1].y = Math.cos(x); d[1].z = 0.0;
    d[2].x =  0.0;         d[2].y = 0.0;         d[2].z = 1.0;
    mdt();
  }
  // move the viewpoint
  final public void center(Point p) { m[4].copy(p); }
  final public void move(Point p) { m[3].plusa(m[3], 1.0, p); }
  final public void zoom(double scale) { magnification *= scale; }

  // m = D times M-Transpose
  final void mdt() {
    Point temp;
    rslm[0].x = m[0].x*d[0].x + m[1].x*d[0].y + m[2].x*d[0].z;
    rslm[0].y = m[0].y*d[0].x + m[1].y*d[0].y + m[2].y*d[0].z;
    rslm[0].z = m[0].z*d[0].x + m[1].z*d[0].y + m[2].z*d[0].z;
    rslm[1].x = m[0].x*d[1].x + m[1].x*d[1].y + m[2].x*d[1].z;
    rslm[1].y = m[0].y*d[1].x + m[1].y*d[1].y + m[2].y*d[1].z;
    rslm[1].z = m[0].z*d[1].x + m[1].z*d[1].y + m[2].z*d[1].z;
    rslm[2].x = m[0].x*d[2].x + m[1].x*d[2].y + m[2].x*d[2].z;
    rslm[2].y = m[0].y*d[2].x + m[1].y*d[2].y + m[2].y*d[2].z;
    rslm[2].z = m[0].z*d[2].x + m[1].z*d[2].y + m[2].z*d[2].z;
    temp = rslm[0]; rslm[0] = m[0]; m[0] = temp;
    temp = rslm[1]; rslm[1] = m[1]; m[1] = temp;
    temp = rslm[2]; rslm[2] = m[2]; m[2] = temp;
  }

  // map a real point to a point from the eye's perspective
  final public void map(Point pout, Point pin) {
    p.minus(pin, m[4]);
    pout.x = p.dot(m[0]);
    pout.y = p.dot(m[1]);
    pout.z = p.dot(m[2]);
    pout.minus(pout, m[3]);
  }

  // get the x pixel for this (already-translated) point
  final public int mapx(Point p) {
    return centerx+(int)(magnification*p.x/p.z);
  }

  // get the y pixel for this (already-translated) point
  final public int mapy(Point p) {
    return centery+(int)(magnification*p.y/p.z);
  }
}
