/**
 * BVector.java -- manipulate vectors
 *
 * By Bob Jenkins, October 1999
 * Permission granted to use, reuse, rewrite this without notifying me.
 */

// A vector.
// Assumes that all vectors are of the same length.
public class BVector {
  double c[];   // array of coefficients of polynomial

  // make a vector of length "length" initialized to zero
  BVector(int length) {c = new double[length];}

  // scale a vector by x
  final public void   scale(double x) {
    for (int i=0; i<c.length; ++i) c[i] = x*c[i];
  }

  // return a copy of a vector
  final public void   copy(BVector x) {
    for (int i=0; i<c.length; ++i) {c[i] = x.c[i];}
  }

  // zero a vector
  final public void   zero() {
    for (int i=0; i<c.length; ++i) {c[i] = 0.0;}
  }

  // return the length of a vector
  final public int    length() {
    return c.length;
  }

  // return the value at some position
  final public double get(int position) {
    return c[position];
  }

  // set the value at some position
  final public void   set(int position, double value) {
    c[position] = value;
  }

  // cast a vector to a string
  public String toString() {
    String x = "("+(float)c[0];
    for (int i=1; i<c.length; ++i) {
      x += ","+(float)c[i];
    }
    x += ")";
    return x;
  }

  // return this dot x
  public final double dot(BVector x) {
    double rslt = 0.0;
    for (int i=0; i<c.length; ++i) {rslt += c[i]*x.c[i];}
    return rslt;
  }

  // set this = x-y
  public final void minus(BVector x, BVector y) {
    for (int i=0; i<c.length; ++i) c[i] = x.c[i]-y.c[i];
  }

  // set this = x+y
  public final void plus(BVector x, BVector y) {
    for (int i=0; i<c.length; ++i) c[i] = x.c[i]+y.c[i];
  }
  
  // set this = x+ay
  public final void plusa(BVector x, double a, BVector y) {
    for (int i=0; i<c.length; ++i) c[i] = x.c[i]+a*y.c[i];
  }

  // set this = x*y, interpreting the vectors as polynomials
  // assume it will fit
  public final void mult(BVector x, BVector y) {
    if (this == x) {
      BVector vt = new BVector(x.c.length);
      vt.copy(x);
      x = vt;
      if (this == y) y = vt;
    } else if (this == y) {
      BVector vt = new BVector(y.c.length);
      vt.copy(y);
      y = vt;
    }
    zero();
    for (int i=0; i<c.length; ++i) {
      for (int j=0; i+j<c.length; ++j) {
	c[i+j] += x.c[i]*y.c[j];
      }
    }
  }

  // set this = x*y-transpose
  public final void multt(BVector x, BMatrix y) {
    if (this == x) {
      BVector vt = new BVector(x.c.length);
      vt.copy(x);
      x = vt;
    }
    zero();
    for (int i=0; i<c.length; ++i) {
      for (int j=0; j<c.length; ++j) {
	c[i] += x.c[j]*y.d[j].c[i];
      }
    }
  }

  // set this = x*y
  public final void mult(BVector x, BMatrix y) {
    if (this == x) {
      BVector vt = new BVector(x.c.length);
      vt.copy(x);
      x = vt;
    }
    zero();
    for (int i=0; i<c.length; ++i) {
      for (int j=0; j<c.length; ++j) {
	c[i] += x.c[j]*y.d[i].c[j];
      }
    }
  }

  // evaluate Bvector, interpreted as a polynomial, at x
  public final double eval(double x) {
    double y = 0.0;  // the result
    double z = 1.0;  // x to the ith
    for (int i=0; i<c.length; ++i) {
      y += c[i]*z;
      z *= x;
    }
    return y;
  }

}

