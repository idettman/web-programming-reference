package com.iad.orbitsim
{
	public class Point3D
	{
		public var x:Number, y:Number, z:Number;


		public function Point3D (x:Number=0, y:Number=0, z:Number=0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function scaleBy (a:Number):void
		{
			x = x * a;
			y = y * a;
			z = z * a;
		}

		public function copyFrom (p:Point3D):void
		{
			x = p.x;
			y = p.y;
			z = p.z;
		}

		public function dotProduct (p:Point3D):Number
		{
			return p.x * x + p.y * y + p.z * z;
		}

		public function toString():String
		{
			return x.toString () + ", " + y.toString () + ", " + z.toString ();
		}

		// this = b-c
		/*public function minus (b:Point3D, c:Point3D):void
		{
			x = b.x - c.x;
			y = b.y - c.y;
			z = b.z - c.z;
		}*/

		public function subtract(value:Point3D):Point3D
		{
			return new Point3D (x - value.x, y - value.y, z - value.z);
		}

		// this = b+c
		public function plus (b:Point3D, c:Point3D):void
		{
			x = b.x + c.x;
			y = b.y + c.y;
			z = b.z + c.z;
		}

		public function add(value:Point3D):Point3D
		{
			return new Point3D (x + value.x, y + value.y, z + value.z);
		}

		// this = b+ac
		public function plusMultiplied (b:Point3D, a:Number, c:Point3D):void
		{
			x = b.x + a * c.x;
			y = b.y + a * c.y;
			z = b.z + a * c.z;
		}

		public function setTo (xa:Number, ya:Number, za:Number):void
		{
			x = xa;
			y = ya;
			z = za;
		}
	}
}
