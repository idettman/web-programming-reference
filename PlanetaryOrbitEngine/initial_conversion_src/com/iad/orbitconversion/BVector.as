package com.iad.orbitconversion
{
	public class BVector
	{
		public var c:Vector.<Number>;


		public function BVector (length:int)
		{
			c = new Vector.<Number> (length);
		}

		// scale a vector by x
		public function scale (x:Number):void
		{
			for (var i:int = 0; i < c.length; ++i) c[i] = x * c[i];
		}


		// return a copy of a vector
		public function copy (x:BVector):void
		{
			for (var i:int = 0; i < c.length; ++i)
			{c[i] = x.c[i];}
		}

		// zero a vector
		public function zero ():void
		{
			for (var i:int = 0; i < c.length; ++i)
			{c[i] = 0.0;}
		}

		// return the length of a vector
		public function length ():int
		{
			return c.length;
		}

		// return the value at some position
		public function get (position:int):Number
		{
			return c[position];
		}

		// set the value at some position
		public function set (position:int, value:Number):void
		{
			c[position] = value;
		}

		// cast a vector to a string
		public function toString ():String
		{
			var x:String = "(" + Number ([0]);
			for (var i:int = 1; i < c.length; ++i)
			{
				x += "," + Number (c[i]);
			}
			x += ")";
			return x;
		}

		// return this dot x
		public function dot (x:BVector):Number
		{
			var rslt:Number = 0.0;
			for (var i:int = 0; i < c.length; ++i)
			{rslt += c[i] * x.c[i];}
			return rslt;
		}

		// set this = x-y
		public function minus (x:BVector, y:BVector):void
		{
			for (var i:int = 0; i < c.length; ++i) c[i] = x.c[i] - y.c[i];
		}

		// set this = x+y
		public function plus (x:BVector, y:BVector):void
		{
			for (var i:int = 0; i < c.length; ++i) c[i] = x.c[i] + y.c[i];
		}

		// set this = x+ay
		public function plusa (x:BVector, a:Number, y:BVector):void
		{
			for (var i:int = 0; i < c.length; ++i) c[i] = x.c[i] + a * y.c[i];
		}

		// set this = x*y, interpreting the vectors as polynomials
		// assume it will fit
		public function mult (x:BVector, y:BVector):void
		{
			if (this == x)
			{
				var vt:BVector = new BVector (x.c.length);
				vt.copy (x);
				x = vt;
				if (this == y) y = vt;
			}
			else if (this == y)
			{
				var vt:BVector = new BVector (y.c.length);
				vt.copy (y);
				y = vt;
			}
			zero ();
			for (var i:int = 0; i < c.length; ++i)
			{
				for (var j:int = 0; i + j < c.length; ++j)
				{
					c[i + j] += x.c[i] * y.c[j];
				}
			}
		}

		// set this = x*y-transpose
		public function multt (x:BVector, y:BMatrix):void
		{
			if (this == x)
			{
				var vt:BVector = new BVector (x.c.length);
				vt.copy (x);
				x = vt;
			}
			zero ();
			for (var i:int = 0; i < c.length; ++i)
			{
				for (var j:int = 0; j < c.length; ++j)
				{
					c[i] += x.c[j] * y.d[j].c[i];
				}
			}
		}

		// set this = x*y
		public function multMatrix (x:BVector, y:BMatrix):void
		{
			if (this == x)
			{
				var vt:BVector = new BVector (x.c.length);
				vt.copy (x);
				x = vt;
			}
			zero ();
			for (var i:int = 0; i < c.length; ++i)
			{
				for (var j:int = 0; j < c.length; ++j)
				{
					c[i] += x.c[j] * y.d[i].c[j];
				}
			}
		}

		// evaluate Bvector, interpreted as a polynomial, at x
		public function eval (x:Number):Number
		{
			var y:Number = 0.0;  // the result
			var z:Number = 1.0;  // x to the ith
			for (var i:int = 0; i < c.length; ++i)
			{
				y += c[i] * z;
				z *= x;
			}
			return y;
		}
	}
}
