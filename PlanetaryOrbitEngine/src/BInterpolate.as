package
{
	public class BInterpolate
	{
		public var InterpolationMatrix:BMatrix;
		public var offset:Number;
		public var length:int;

		// set up to interpolate "length" evenly spaced values
		public function BInterpolate (length:int)
		{
			this.length = length;
			this.offset = -length / 2.0;
			this.InterpolationMatrix = makeInterpolationMatrix (length);
		}

		// This generates a matrix that lets us quickly find the polynomial
		// which passes through length consecutive points.  The matrix only
		public function makeInterpolationMatrix (length:int):BMatrix
		{
			var x:BMatrix = new BMatrix (length);
			var v:BVector = new BVector (length);
			var vt:BVector = new BVector (length);
			for (var i:int = 0; i < length; ++i)
			{
				v.zero ();
				v.set (0, 1.0);
				vt.zero ();
				vt.set (1, 1.0);
				for (var j:int = 0; j < length; ++j)
				{
					if (i != j)
					{
						vt.set (0, Number (-offset - j));
						v.mult (v, vt);
					}
				}
				v.scale (1.0 / v.eval (Number (i + offset)));
				x.sety (i, v);
			}
			return x;
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
