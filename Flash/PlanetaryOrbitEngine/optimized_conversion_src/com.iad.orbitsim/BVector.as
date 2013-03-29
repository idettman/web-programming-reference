package com.iad.orbitsim
{
	public class BVector
	{
		public var elements:Vector.<Number>;


		public function BVector (length:int)
		{
			elements = new Vector.<Number> (length);
		}

		// scale a vector by x
		public function scale (scale:Number):void
		{
			for (var i:int = 0; i < elements.length; ++i)
				elements[i] = scale * elements[i];
		}


		// return a copy of a vector
		public function copy (vector:BVector):void
		{
			for (var i:int = 0; i < elements.length; ++i)
			{
				elements[i] = vector.elements[i];
			}
		}

		// zero a vector
		public function setToZero ():void
		{
			for (var i:int = 0; i < elements.length; ++i)
			{
				elements[i] = 0;
			}
		}

		// return the value at some position
		public function get (position:int):Number
		{
			return elements[position];
		}

		// set the value at some position
		public function set (position:int, value:Number):void
		{
			elements[position] = value;
		}

		// set this = x*y, interpreting the vectors as polynomials
		// assume it will fit
		public function mult (vectorA:BVector, vectorB:BVector):void
		{
			var vt:BVector;

			if (this == vectorA)
			{
				vt = new BVector (vectorA.elements.length);
				vt.copy (vectorA);
				vectorA = vt;
				if (this == vectorB) vectorB = vt;
			}
			else if (this == vectorB)
			{
				vt = new BVector (vectorB.elements.length);
				vt.copy (vectorB);
				vectorB = vt;
			}
			setToZero ();
			for (var i:int = 0; i < elements.length; ++i)
			{
				for (var j:int = 0; i + j < elements.length; ++j)
				{
					elements[i + j] += vectorA.elements[i] * vectorB.elements[j];
				}
			}
		}

		// set this = x*y
		public function multMatrix (x:BVector, y:BVectorMatrix):void
		{
			if (this == x)
			{
				var vt:BVector = new BVector (x.elements.length);
				vt.copy (x);
				x = vt;
			}
			setToZero ();
			for (var i:int = 0; i < elements.length; ++i)
			{
				for (var j:int = 0; j < elements.length; ++j)
				{
					elements[i] += x.elements[j] * y.matrixRows[i].elements[j];
				}
			}
		}

		// evaluate Bvector, interpreted as a polynomial, at x
		public function evalAsPolynomialAtValue (x:Number):Number
		{
			var y:Number = 0;  // the result
			var z:Number = 1;  // x to the ith
			for (var i:int = 0; i < elements.length; ++i)
			{
				y += elements[i] * z;
				z *= x;
			}
			return y;
		}
	}
}
