package
{
	public class Point
	{
		public var x:Number, y:Number, z:Number;    // value of point

		public function Point (x:Number, y:Number, z:Number)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function scale (a:Number):void
		{
			x = x * a;
			y = y * a;
			z = z * a;
		}

		public function copy (p:Point):void
		{
			x = p.x;
			y = p.y;
			z = p.z;
		}

		public function zero ():void
		{
			x = 0.0;
			y = 0.0;
			z = 0.0;
		}

		public function toString ():String
		{
			return "(" + x + "," + y + "," + z + ")";
		}

		public function dot (p:Point):Number { return p.x * x + p.y * y + p.z * z; }

		// this = b-c
		public function minus (b:Point, c:Point):void
		{
			x = b.x - c.x;
			y = b.y - c.y;
			z = b.z - c.z;
		}

		// this = b+c
		public function plus (b:Point, c:Point):void
		{
			x = b.x + c.x;
			y = b.y + c.y;
			z = b.z + c.z;
		}

		// this = b+ac
		public function plusa (b:Point, a:Number, c:Point):void
		{
			x = b.x + a * c.x;
			y = b.y + a * c.y;
			z = b.z + a * c.z;
		}

		// convert a string to a double
		public static function s2d (s:String, dflt:Number):Number
		{
			if (s == null)
			{
				return dflt;
			}
			else
			{
				return parseFloat (s);
				/*
				 try {

				 } catch (NumberFormatException e) {
				 return dflt;
				 }*/
			}
		}

		// convert a string to a color
		public static function s2c (s:String, dflt:Color):Color
		{
			if (s == null)
			{
				return dflt;
			}
			else
			{
				return new Color (parseInt (s, 16));
			}
		}

		// evaluate polynomial p at value x
		public function eval (p:Vector.<Point>, x:Number):void
		{
			var y:Number = 1.0;
			zero ();
			for (var i:int = 0; i < p.length; ++i)
			{
				this.plusa (this, y, p[i]);
				y *= x;
			}
		}
	}
}
