/**
 * BInterpolate.java -- Build an interpolating polynomial
 *
 * By Bob Jenkins, October 1999
 * Permission granted to use, reuse, rewrite this without notifying me.
 */

// A vector.
// Assumes that all vectors are of the same length.
public class BInterpolate {
  BMatrix InterpolationMatrix;
  double  offset;
  int     length;

  // set up to interpolate "length" evenly spaced values
  BInterpolate(int length) {
    this.length = length;
    this.offset = -length/2.0;
    this.InterpolationMatrix = makeInterpolationMatrix(length);
  }

  // This generates a matrix that lets us quickly find the polynomial
  // which passes through length consecutive points.  The matrix only
  final BMatrix makeInterpolationMatrix(int length) {
    BMatrix x  = new BMatrix(length);
    BVector v  = new BVector(length);
    BVector vt = new BVector(length);
    for (int i=0; i<length; ++i) {
      v.zero();
      v.set(0, 1.0);
      vt.zero();
      vt.set(1, 1.0);
      for (int j=0; j<length; ++j) {
	if (i != j) {
	  vt.set(0, (double)(-offset-j));
	  v.mult(v, vt);
	}
      }
      v.scale(1.0/v.eval((double)(i+offset)));
      x.sety(i, v);
    }
    return x;
  }

  // Build an interpolating polynomial such that 
  //   out.eval(i-interpolate.offset) == in.get(i)
  // (eval(i-offset) is more accurate than eval(i) would be.)
  final void makeInterpolator(BVector out, BVector in) {
    out.mult(in, InterpolationMatrix);
  }
}

