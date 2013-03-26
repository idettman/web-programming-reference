/**
 * Point.java -- a 3D point.  Also some miscellaneous useful routines.
 *
 * By Bob Jenkins, July 1998
 * Permission granted to use, reuse, rewrite this without notifying me.
 */
import java.awt.*;

// a 3D point
final public class Point {
  public double x,y,z;    // value of point

  Point(double x, double y, double z) { this.x=x; this.y=y; this.z=z; }
  public final void scale(double a)   { x=x*a; y=y*a; z=z*a; }
  public final void copy(Point p) { x=p.x; y=p.y; z=p.z; }
  public final void zero()        { x=0.0; y=0.0; z=0.0; }
  public String toString() {
    return "("+(float)x+","+(float)y+","+(float)z+")"; 
  }
  public final double dot(Point p){ return p.x*x+p.y*y+p.z*z; }

  // this = b-c
  public final void minus(Point b, Point c) {
    x=b.x-c.x;  y=b.y-c.y;  z=b.z-c.z;
  }

  // this = b+c
  public final void plus(Point b, Point c) {
    x=b.x+c.x;  y=b.y+c.y;  z=b.z+c.z;
  }

  // this = b+ac
  public final void plusa(Point b, double a, Point c) {
    x=b.x+a*c.x;  y=b.y+a*c.y;  z=b.z+a*c.z;
  }

  // convert a string to a double
  public static double s2d(String s, double dflt) {
    if (s==null) {
      return dflt;
    } else {
      try {
	return Double.valueOf(s).doubleValue();
      } catch (NumberFormatException e) {
	return dflt;
      }
    }
  }

  // convert a string to a color
  public static Color s2c(String s, Color dflt) {
    if (s==null) {
      return dflt;
    } else {
      return new Color(Integer.parseInt(s, 16));
    }
  }

  // evaluate polynomial p at value x
  public void eval(Point p[], double x) {
    double y = 1.0;
    zero();
    for (int i=0; i<p.length; ++i) {
      this.plusa(this, y, p[i]);
      y *= x;
    }
  }
}

