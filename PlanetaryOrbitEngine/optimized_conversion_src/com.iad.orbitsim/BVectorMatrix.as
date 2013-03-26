package com.iad.orbitsim
{
	public class BVectorMatrix
	{
		public var matrixRows:Vector.<BVector>;


		// make a matrix of size length x length
		public function BVectorMatrix (length:int)
		{
			matrixRows = new Vector.<BVector> (length);
			for (var i:int = 0; i < length; ++i)
			{
				matrixRows[i] = new BVector (length);
			}
		}

		public function sety (y:int, value:BVector):void
		{
			for (var i:int = 0; i < matrixRows.length; ++i)
			{
				matrixRows[i].elements[y] = value.elements[i];
			}
		}
	}
}
