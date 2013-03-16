package utils
{
	import flash.geom.Point;


	public class GeometryUtils
	{
		public static function getMidPoint (x:Number, y:Number, width:Number, height:Number, angle_degrees:Number):Point
		{
			var angle_rad:Number = angle_degrees * Math.PI / 180;
			var cosa:Number = Math.cos(angle_rad);
			var sina:Number = Math.sin(angle_rad);
			var wp:Number = width/2;
			var hp:Number = height/2;

			return new Point (( x + wp * cosa - hp * sina ),( y + wp * sina + hp * cosa ));
		}

		// Unfinished, add either path output or pass in display object
		public static function drawPoly (x:Number, y:Number, sides:uint, radius:Number, angle:Number):void
		{
			var count:uint = sides;

			var point1:Point = new Point ();
			var point2:Point = new Point ();

			// check that count is sufficient to build polygon
			if (count > 2)
			{
				// init vars
				var step:Number, start:Number, n:uint, dx:Number, dy:Number;
				// calculate span of sides
				step = (Math.PI * 2) / sides;
				// calculate starting angle in radians
				start = (angle / 180) * Math.PI;


				//wheelShape.graphics.moveTo (x + (Math.cos (start) * radius), y - (Math.sin (start) * radius));

				point1.x = x + (Math.cos (start) * radius);
				point1.y = y + (Math.sin (start) * radius);


				var legDistance:Number;
				var hypotenuse:Number;


				// draw the polygon
				for (n = 1; n <= count; n++)
				{
					dx = x + Math.cos (start + (step * n)) * radius;
					dy = y - Math.sin (start + (step * n)) * radius;

					point2.x = dx;
					point2.y = dy;

					legDistance = Point.distance (point1, point2);
					//trace ("legDistance:", legDistance);

					//wheelShape.graphics.lineTo (dx, dy);

					//trace ("getP3:", getP3 (point1));

					point1.x = point2.x;
					point1.y = point2.y;
				}
			}
		}

	}
}
