package com.iad.orbitsim
{
	public class InterpolateBVector
	{
		public var InterpolationMatrix:BVectorMatrix;
		public var offset:Number;
		public var length:int;

		// set up to interpolate "length" evenly spaced values
		public function InterpolateBVector (length:int)
		{
			this.length = length;
			this.offset = -length / 2.0;

			// This generates a matrix that lets us quickly find the polynomial
			// which passes through length consecutive points.  The matrix only
			InterpolationMatrix = new BVectorMatrix (length);
			var v:BVector = new BVector (length);
			var vt:BVector = new BVector (length);
			for (var i:int = 0; i < length; ++i)
			{
				v.setToZero ();
				v.set (0, 1);
				vt.setToZero ();
				vt.set (1, 1);
				for (var j:int = 0; j < length; ++j)
				{
					if (i != j)
					{
						vt.set (0, Number (-offset - j));
						v.mult (v, vt);
					}
				}
				v.scale (1.0 / v.evalAsPolynomialAtValue (Number (i + offset)));
				InterpolationMatrix.sety (i, v);
			}

		}


		// Build an interpolating polynomial such that
		//   out.eval(i-interpolate.offset) == in.get(i)
		// (eval(i-offset) is more accurate than eval(i) would be.)
		public function makeInterpolator (outVector:BVector, inVector:BVector):void
		{
			outVector.multMatrix (inVector, InterpolationMatrix);
		}
	}
}
