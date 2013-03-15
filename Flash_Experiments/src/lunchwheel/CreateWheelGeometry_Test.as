package lunchwheel
{
	import base.display.AbstractSprite;

	import flash.display.Shape;
	import flash.geom.Point;


	public class CreateWheelGeometry_Test extends AbstractSprite
	{
		private var _startingIndex:uint;
		private var _circleRadius:Number;
		private var _circleCenter:Point;

		private var _lunchVo:LunchVo;
		private var _data:Vector.<LunchVo>;

		public var wheelShape:Shape;


		public function CreateWheelGeometry_Test ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			_startingIndex = 0;
			_circleRadius = 200;
			_circleCenter = new Point (1024 / 2, 700 / 2);

			wheelShape = new Shape ();
			wheelShape.graphics.lineStyle (2);
			//wheelShape.graphics.beginFill (0xFF0000);
			addChild (wheelShape);


			var lunchData:Vector.<LunchVo> = new <LunchVo>[
				createLunchData ("Hots Kitchen"),
				createLunchData ("Britts BBQ"),
				createLunchData ("The Golf Course"),
				createLunchData ("Chipotle"),
				createLunchData ("Panda Express"),
				createLunchData ("Pickup Sticks"),
				createLunchData ("Mc Donalds"),
				createLunchData ("Silvios"),
				createLunchData ("Chilies"),
				createLunchData ("Carls JR"),
				createLunchData ("The Habbit"),
				createLunchData ("Five Guys")
			];

			data = lunchData;
		}


		private function updateLayout ():void
		{
			var angle:Number = 0;
			var sum:uint = _data.length;
			var radius:Number = _circleRadius;
			var count:uint = sum-1;

			var step:Number, start:Number, n:uint, dx:Number, dy:Number;

			var point1:Point = new Point ();
			var point2:Point = new Point ();


			// calculate span of sides
			step = (Math.PI * 2) / count;
			// calculate starting angle in radians
			start = (angle / 180) * Math.PI;

			//wheelShape.graphics.moveTo (_circleCenter.x + (Math.cos (start) * radius), _circleCenter.y - (Math.sin (start) * radius));

			point1.x = x + (Math.cos (start) * radius);
			point1.y = y + (Math.sin (start) * radius);

			var legDistance:Number;
			var hypotenuse:Number;


			// draw the polygon
			for (n = 1; n <= count; n++)
			{
				_lunchVo = _data[n - 1];

				dx = _circleCenter.x + Math.cos (start + (step * n)) * radius;
				dy = _circleCenter.y - Math.sin (start + (step * n)) * radius;

				point2.x = dx;
				point2.y = dy;


				var deltaX:Number = point2.x - point1.x;
				var deltaY:Number = point2.y - point1.y;

				var lineLength:Number = Math.sqrt (deltaX * deltaX + deltaY * deltaY);

				deltaX /= lineLength;
				deltaY /= lineLength;

				const THICKNESS:Number = 20;
				/*const pVectorX:Number = 0.5 * THICKNESS * (-deltaY);
				const pVectorY:Number = 0.5 * THICKNESS * deltaX;*/
				const pVectorX:Number = THICKNESS * deltaY;
				const pVectorY:Number = THICKNESS * deltaX;

				/*var pointVert1:Point = new Point (point1.x - pVectorX, point1.y + pVectorY);
				var pointVert2:Point = new Point (point2.x - pVectorX, point2.y + pVectorY);
				var pointVert3:Point = new Point (point2.x + pVectorX, point2.y - pVectorY);
				var pointVert4:Point = new Point (point1.x + pVectorX, point1.y - pVectorY);*/
				var pointVert1:Point = new Point (point1.x - pVectorX, point1.y + pVectorY);
				var pointVert2:Point = new Point (point2.x - pVectorX, point2.y + pVectorY);
				var pointVert3:Point = new Point (point2.x + pVectorX, point2.y - pVectorY);
				var pointVert4:Point = new Point (point1.x + pVectorX, point1.y - pVectorY);


				/*legDistance = Point.distance (point1, point2);
				trace ("legDistance:", legDistance);

				var tanB:Number = Math.tan (4 / legDistance);
				var tanA:Number = Math.tan (legDistance / 4);

				trace ("tanB:", tanB);
				trace ("tanA:", tanA);

				var sinB:Number = 4 / Math.sin (tanB);

				var sideC:Number = sinB;

				trace ("sideC:", sideC);*/


				/*hypotenuse = Math.sqrt((legDistance*legDistance) + (4*4));
				trace ("hypotenuse:", hypotenuse);*/


				wheelShape.graphics.lineStyle (2, 0x000000);
				wheelShape.graphics.moveTo (point1.x, point1.y);
				wheelShape.graphics.lineTo (point2.x, point2.y);



				point1.x = point2.x;
				point1.y = point2.y;
				//wheelShape.graphics.lineTo (dx, dy);


				wheelShape.graphics.lineStyle (2, 0xFF0000);
				wheelShape.graphics.moveTo (pointVert1.x, pointVert1.y);
				wheelShape.graphics.lineTo (pointVert2.x, pointVert2.y);
				wheelShape.graphics.lineTo (pointVert3.x, pointVert3.y);
				wheelShape.graphics.lineTo (pointVert4.x, pointVert4.y);
				wheelShape.graphics.lineTo (pointVert1.x, pointVert1.y);
			}
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