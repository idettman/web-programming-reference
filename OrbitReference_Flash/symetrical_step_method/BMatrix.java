/**
 * BMatrix.java -- manipulate square matrices
 *
 * By Bob Jenkins, October 1999
 * Permission granted to use, reuse, rewrite this without notifying me.
 */

// A square matrix, built out of vectors
// Assumes that all matrices vectors are of the same length.
final public class BMatrix {
  BVector d[];   // array of vectors

  // make a matrix of size length x length initialized to zero
  BMatrix(int length) {
    d = new BVector[length];
    for (int i=0; i<length; ++i) {
      d[i] = new BVector(length);
    }
  }

  // scale this matrix by x
  final public void   scale(double x) {
    for (int i=0; i<d.length; ++i) {
      d[i].scale(x);
    }
  }

  // make this matrix a copy of x
  final public void   copy(BMatrix x) {
    if (this == x) return;
    for (int i=0; i<d.length; ++i) {
      d[i].copy(x.d[i]);
    }
  }

  // make v a copy of this[x][*]
  final public void   copyx(BVector v, int x) {
    v.copy(d[x]);
  }

  // make v a copy of this[*][y]
  final public void   copy(BVector v, int y) {
    for (int i=0; i<d.length; ++i) {
      v.c[i] = d[i].c[y];
    }
  }

  // set this matrix to zero
  final public void   zero() {
    for (int i=0; i<d.length; ++i) {
      d[i].zero();
    }
  }

  // return the length of this matrix
  final public int    length() {
    return d.length;
  }

  // return this[x][y]
  final public double get(int x, int y) {
    return d[x].c[y];
  }

  // set this[x][y] to value
  final public void   set(int x, int y, double value) {
    d[x].c[y] = value;
  }

  // set this[x][*] to value
  final public void   setx(int x, BVector value) {
    d[x].copy(value);
  }

  // set this[*][y] to value
  final public void   sety(int y, BVector value) {
    for (int i=0; i<d.length; ++i) {
      d[i].c[y] = value.c[i];
    }
  }

  // return a string representing this matrix
  public String toString() {
    String x = d.length+"x"+d.length+" matrix:\n";
    for (int i=0; i<d.length; ++i) {
      x += d[i].toString()+"\n";
    }
    return x;
  }

  // set this = x-y
  public final void minus(BMatrix x, BMatrix y) {
    for (int i=0; i<d.length; ++i) {
      d[i].minus(x.d[i],y.d[i]);
    }
  }

  // set this = x+y
  public final void plus(BMatrix x, BMatrix y) {
    for (int i=0; i<d.length; ++i) {
      d[i].plus(x.d[i],y.d[i]);
    }
  }
  
  // set this = x+ay
  public final void plusa(BMatrix x, double a, BMatrix y) {
    for (int i=0; i<d.length; ++i) {
      d[i].plusa(x.d[i],a,y.d[i]);
    }
  }

  // set this = x transpose
  public final void mult(BMatrix x) {
    for (int i=0; i<d.length; ++i) {
      for (int j=0; j<i; ++j) {
	double temp = d[i].c[j]; 
	d[i].c[j] = d[j].c[i];
	d[j].c[i] = temp;
      }
    }
  }

  // set this = x times y
  public final void mult(BMatrix x, BMatrix y) {
    if (this == x) {
      BMatrix mt = new BMatrix(d.length);
      mt.copy(this);
      x = mt;
      if (this == y) y = mt;
    } else if (this == y) {
      BMatrix mt = new BMatrix(d.length);
      mt.copy(this);
      y = mt;
    }
    zero();
    for (int i=0; i<d.length; ++i) {
      for (int j=0; j<d.length; ++j) {
	for (int k=0; k<d.length; ++k) {
	  d[i].c[k] += x.d[i].c[j]*y.d[j].c[k];
	}
      }
    }
  }

  // set this = x times y-transpose
  public final void multt(BMatrix x, BMatrix y) {
    if (this == x) {
      BMatrix tx = new BMatrix(d.length);
      tx.copy(this);
      x = tx;
      if (this == y) y = tx;
    } else if (this == y) {
      BMatrix ty = new BMatrix(d.length);
      ty.copy(this);
      y = ty;
    }
    zero();
    for (int i=0; i<d.length; ++i) {
      for (int j=0; j<d.length; ++j) {
	for (int k=0; k<d.length; ++k) {
	  d[i].c[k] += x.d[i].c[j]*y.d[k].c[j];
	}
      }
    }
  }

  // set this to the inverse of x
  public final void inverse(BMatrix x) {
    int p[] = new int[d.length];        // permutation of rows due to pivots

    // get ready
    copy(x);
    for (int i=0; i<d.length; ++i) {
      p[i] = i;
    }

    // invert the sucker
    for (int j=0; j<d.length; ++j) {

      // pivot search
      double max = ((d[j].c[j]>0.0) ? d[j].c[j] : -d[j].c[j]);
      int r = j;
      for (int i=j+1; i<d.length; ++i) {
	double temp;
	if ((temp=((d[i].c[j]>0.0) ? d[i].c[j] : -d[i].c[j])) > max) {
	  max = temp;
	  r = i;
	}
      }

      // raise an error if matrix is not invertible
      if (max == 0.0) {
	System.out.println("Singular matrix!  No inverse!");
	System.out.println(toString());
	return;
      }
    
      // row interchange
      if (r > j) {
	BVector temp=d[j];  d[j]=d[r];  d[r]=temp;
	int tempi = p[j];  p[j]=p[r];  p[r]=tempi;
      }

      // transformation
      double hr = 1.0/d[j].c[j];
      for (int i=0; i<d.length; ++i) {
	d[i].c[j] = hr*d[i].c[j];
      }
      d[j].c[j] = hr;
      for (int k=0; k<d.length; ++k) {
	double temp = d[j].c[k];
	if (k==j) {
	  continue;
	} else {
	  for (int i=0; i<d.length; ++i) {
	    if (i==j) {
	      d[j].c[k] = -hr*temp;
	    } else {
	      d[i].c[k] = d[i].c[k] - d[i].c[j]*temp;
	    }
	  }
	}
      }
    }

    // column interchange
    BVector hv = new BVector(d.length);
    for (int i=0; i<d.length; ++i) {
      for (int k=0; k<d.length; ++k) {
	hv.c[p[k]] = d[i].c[k];
      }
      for (int k=0; k<d.length; ++k) {
	d[i].c[k] = hv.c[k];
      }
    }
  }

}

