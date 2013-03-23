package
{
	public class BMatrix
	{
		public var d:Vector.<BVector>;   // array of vectors

		// make a matrix of size length x length initialized to zero
		public function BMatrix (length:int)
		{
			d = new Vector.<BVector> (length);
			for (var i:int = 0; i < length; ++i)
			{
				d[i] = new BVector (length);
			}
		}

		// scale this matrix by x
		public function scale (x:Number):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].scale (x);
			}
		}

		// make this matrix a copy of x
		public function copy (x:BMatrix):void
		{
			if (this == x) return;
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].copy (x.d[i]);
			}
		}

		// make v a copy of this[x][*]
		public function copyx (v:BVector, x:int):void
		{
			v.copy (d[x]);
		}

		// make v a copy of this[*][y]
		/*public function copy (v:BVector, y:int):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				v.c[i] = d[i].c[y];
			}
		}*/

		// set this matrix to zero
		public function zero ():void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].zero ();
			}
		}

		// return the length of this matrix
		public function length ():int
		{
			return d.length;
		}

		// return this[x][y]
		public function get (x:int, y:int):Number
		{
			return d[x].c[y];
		}

		// set this[x][y] to value
		public function set (x:int, y:int, value:Number):void
		{
			d[x].c[y] = value;
		}

		// set this[x][*] to value
		public function setx (x:int, value:BVector):void
		{
			d[x].copy (value);
		}

		// set this[*][y] to value
		public function sety (y:int, value:BVector):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].c[y] = value.c[i];
			}
		}

		// return a string representing this matrix
		public function toString ():String
		{
			var x:String = d.length + "x" + d.length + " matrix:\n";
			for (var i:int = 0; i < d.length; ++i)
			{
				x += d[i].toString () + "\n";
			}
			return x;
		}

		// set this = x-y
		public function minus (x:BMatrix, y:BMatrix):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].minus (x.d[i], y.d[i]);
			}
		}

		// set this = x+y
		public function plus (x:BMatrix, y:BMatrix):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].plus (x.d[i], y.d[i]);
			}
		}

		// set this = x+ay
		public function plusa (x:BMatrix, a:Number, y:BMatrix):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				d[i].plusa (x.d[i], a, y.d[i]);
			}
		}

		// set this = x transpose
		public function mult (x:BMatrix):void
		{
			for (var i:int = 0; i < d.length; ++i)
			{
				for (var j:int = 0; j < i; ++j)
				{
					var tempValue:Number = d[i].c[j];
					d[i].c[j] = d[j].c[i];
					d[j].c[i] = tempValue;
				}
			}
		}

		// set this = x times y
		/*public function mult (x:BMatrix, y:BMatrix):void
		{
			if (this == x)
			{
				var mt:BMatrix = new BMatrix (d.length);
				mt.copy (this);
				x = mt;
				if (this == y) y = mt;
			}
			else if (this == y)
			{
				var mt:BMatrix = new BMatrix (d.length);
				mt.copy (this);
				y = mt;
			}
			zero ();
			for (var i:int = 0; i < d.length; ++i)
			{
				for (var j:int = 0; j < d.length; ++j)
				{
					for (var k:int = 0; k < d.length; ++k)
					{
						d[i].c[k] += x.d[i].c[j] * y.d[j].c[k];
					}
				}
			}
		}*/

		// set this = x times y-transpose
		public function multt (x:BMatrix, y:BMatrix):void
		{
			if (this == x)
			{
				var tx:BMatrix = new BMatrix (d.length);
				tx.copy (this);
				x = tx;
				if (this == y) y = tx;
			}
			else if (this == y)
			{
				var ty:BMatrix = new BMatrix (d.length);
				ty.copy (this);
				y = ty;
			}
			zero ();
			for (var i:int = 0; i < d.length; ++i)
			{
				for (var j:int = 0; j < d.length; ++j)
				{
					for (var k:int = 0; k < d.length; ++k)
					{
						d[i].c[k] += x.d[i].c[j] * y.d[k].c[j];
					}
				}
			}
		}

		// set this to the inverse of x
		public function inverse (x:BMatrix):void
		{
			var p:Vector.<int> = new Vector.<int> (d.length);// permutation of rows due to pivots

			// get ready
			copy (x);
			for (var i:int = 0; i < d.length; ++i)
			{
				p[i] = i;
			}

			// invert the sucker
			for (var j:int = 0; j < d.length; ++j)
			{

				// pivot search
				var max:Number = ((d[j].c[j] > 0.0) ? d[j].c[j] : -d[j].c[j]);
				var r:int = j;
				for (var i:int = j + 1; i < d.length; ++i)
				{
					var tempValue:Number;
					if ((tempValue = ((d[i].c[j] > 0.0) ? d[i].c[j] : -d[i].c[j])) > max)
					{
						max = tempValue;
						r = i;
					}
				}

				// raise an error if matrix is not invertible
				if (max == 0.0)
				{
					/*System.out.println("Singular matrix!  No inverse!");
					 System.out.println(toString());*/
					return;
				}

				// row interchange
				if (r > j)
				{
					var tempBVect:BVector = d[j];
					d[j] = d[r];
					d[r] = tempBVect;
					var tempi:int = p[j];
					p[j] = p[r];
					p[r] = tempi;
				}

				// transformation
				var hr:Number = 1.0 / d[j].c[j];
				for (var i:int = 0; i < d.length; ++i)
				{
					d[i].c[j] = hr * d[i].c[j];
				}
				d[j].c[j] = hr;
				for (var k:int = 0; k < d.length; ++k)
				{
					var temp:Number = d[j].c[k];
					if (k == j)
					{
						continue;
					}
					else
					{
						for (var i:int = 0; i < d.length; ++i)
						{
							if (i == j)
							{
								d[j].c[k] = -hr * temp;
							}
							else
							{
								d[i].c[k] = d[i].c[k] - d[i].c[j] * temp;
							}
						}
					}
				}
			}

			// column interchange
			var hv:BVector = new BVector (d.length);
			for (var i:int = 0; i < d.length; ++i)
			{
				for (var k:int = 0; k < d.length; ++k)
				{
					hv.c[p[k]] = d[i].c[k];
				}
				for (var k:int = 0; k < d.length; ++k)
				{
					d[i].c[k] = hv.c[k];
				}
			}
		}
	}
}
