package lunchwheel
{
	import base.display.AbstractSprite;

	import flash.display.Shape;
	import flash.geom.Point;

	import graphics.Wedge;


	public class DrawArcsAndPolys_Test extends AbstractSprite
	{
		private var _degree:Number;
		private var _startingIndex:uint;
		private var _circleRadius:Number;
		private var _circleCenter:Point;
		public var startAngle:Number = Math.PI / 2;
		/** The total angular size of the layout (in radians, default 2 pi). */
		public var angleWidth:Number = 2 * Math.PI;

		private var _lunchVo:LunchVo;
		private var _data:Vector.<LunchVo>;

		public var wheelShape:Shape;


		public function DrawArcsAndPolys_Test ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			_degree = 0;
			_startingIndex = 0;
			_circleRadius = 200;
			_circleCenter = new Point (1024 / 2, 700 / 2);

			wheelShape = new Shape ();
			wheelShape.graphics.lineStyle (2);
			//wheelShape.graphics.beginFill (0xFF0000);


			var lunchData:Vector.<LunchVo> = new <LunchVo>[
				createLunchData ("Hots Kitchen"),
				createLunchData ("Britts BBQ"),
				createLunchData ("The Golf Course"),
				createLunchData ("Chipotle"),
				createLunchData ("Silvios"),
				createLunchData ("Chilies"),
				createLunchData ("Carls JR"),
				createLunchData ("The Habbit"),
				createLunchData ("Five Guys")
			];

			data = lunchData;
		}


		public var wedge:Wedge;

		private function updateLayout ():void
		{
			var degree:Number, percent:Number;


			for (var i:int = 0, sum:int = _data.length; i < sum; i++)
			{
				_lunchVo = _data[i];

				percent = i / (sum - 1);
				degree = percent * 360;
				addChild (new Wedge (0x00FF00, _circleCenter.x, _circleCenter.y, _circleRadius, degree, degree + 360 / (sum - 1), 1));

				//trace ("percent:", percent, "  degree:", degree, "  angle:", 360 / (sum-1));
				//drawArc (wheelShape, _circleCenter.x, _circleCenter.y, _circleRadius, 360 / (sum-1), degree, _circleRadius/2);
			}

			addChild (wheelShape);
			drawPoly (_circleCenter.x, _circleCenter.y, _data.length - 1, _circleRadius, 0);
		}


		private function drawPoly (x:Number, y:Number, sides:uint, radius:Number, angle:Number):void
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


				wheelShape.graphics.moveTo (x + (Math.cos (start) * radius), y - (Math.sin (start) * radius));

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
					trace ("legDistance:", legDistance);

					wheelShape.graphics.lineTo (dx, dy);

					//trace ("getP3:", getP3 (point1));

					point1.x = point2.x;
					point1.y = point2.y;
				}
			}
		}


		public static function getP3 (p1:Point, distanceFromP1:Number, p2:Point, distanceFromP2:Number):Vector.<Point>
		{
			var d:Number = Point.distance (p1, p2);

			if (d > (distanceFromP1 + distanceFromP2) || p1.equals (p2) || d < Math.abs (distanceFromP1 - distanceFromP2))
			{
				// there does not exist a 3rd point, or there are an infinite amount of them
				return new <Point>[new Point ()];
			}

			var a:Number = (distanceFromP1 * distanceFromP1 - distanceFromP2 * distanceFromP2 + d * d) / (2 * d);
			var h:Number = Math.sqrt (distanceFromP1 * distanceFromP1 - a * a);

			var temp:Point = new Point (p1.x + a * (p2.x - p1.x) / d, p1.y + a * (p2.y - p1.y) / d);

			return new <Point>[
				new Point (temp.x + h * (p2.y - p1.y) / d, temp.y - h * (p2.x - p1.x) / d),
				new Point (temp.x - h * (p2.y - p1.y) / d, temp.y + h * (p2.x - p1.x) / d)
			]
		}

		private function drawArc (arcRef:Shape, sx:Number, sy:Number, radius:Number, arc:Number, startAngle:Number = 0, radiusInner:Number = 30):void
		{
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var bxInner:Number;
			var byInner:Number;
			var cx:Number;
			var cy:Number;

			// Move the pen
			//arcRef.graphics.moveTo(sx, sy);

			numOfSegs = Math.ceil (Math.abs (arc) / 45);
			segAngle = arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (startAngle / 180) * Math.PI;

			// Calculate the start point
			ax = sx + Math.cos (angle) * radius;
			ay = sy + Math.sin (angle) * radius;

			// Draw the first line
			//arcRef.graphics.lineTo(ax, ay);
			//arcRef.graphics.moveTo(ax, ay);


			arcRef.graphics.moveTo (ax, ay);

			// Draw the arc
			for (var i:int = 0; i < numOfSegs; i++)
			{
				angle += segAngle;
				angleMid = angle - (segAngle / 2);
				bx = sx + Math.cos (angle) * radius;
				by = sy + Math.sin (angle) * radius;

				bxInner = sx + Math.cos (angle) * radiusInner;
				byInner = sy + Math.sin (angle) * radiusInner;


				cx = sx + Math.cos (angleMid) * (radius / Math.cos (segAngle / 2));
				cy = sy + Math.sin (angleMid) * (radius / Math.cos (segAngle / 2));

				//arcRef.graphics.curveTo(cx, cy, bx, by);

				//arcRef.graphics.lineTo(bxInner, byInner);
				arcRef.graphics.lineTo (bx, by);
			}

			// Close the wedge
			//arcRef.graphics.lineTo(sx, sy);
		}


		private function createLunchData (title:String):LunchVo
		{
			var lunchVo:LunchVo = new LunchVo ();
			lunchVo.index = _startingIndex;
			lunchVo.title = title;
			_startingIndex++;
			return lunchVo;
		}


		public function get data ():Vector.<LunchVo> { return _data; }

		public function set data (value:Vector.<LunchVo>):void
		{
			_data = value;
			updateLayout ();
		}


	}
}
class LunchVo
{
	public function LunchVo () {}

	public var index:uint;
	public var title:String;
}