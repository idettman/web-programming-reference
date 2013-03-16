package lunchwheel
{
	import base.display.AbstractSprite;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;


	public class CreatePolygonWithRectangles_Test extends AbstractSprite
	{
		private var _startingIndex:uint;
		private var _circleRadius:Number;
		private var _circleCenter:Point;
		private var _data:Vector.<LunchVo>;

		public var wheelShape:Shape;


		override protected function init ():void
		{
			super.init ();

			_startingIndex = 0;
			_circleRadius = 200;
			_circleCenter = new Point (1024 / 2, 700 / 2);

			wheelShape = new Shape ();
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
				createLunchData ("The Sizzler"),
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
			var count:uint = sum;

			var step:Number, start:Number, n:uint, dx:Number, dy:Number;

			var point1:Point = new Point ();
			var point2:Point = new Point ();

			var _lunchVo:LunchVo;


			// calculate span of sides
			step = (Math.PI * 2) / count;
			// calculate starting angle in radians
			start = (angle / 180) * Math.PI;

			point1.x = _circleCenter.x + (Math.cos (start) * radius);
			point1.y = _circleCenter.y + (Math.sin (start) * radius);


			// create the polygon
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

				var pointVert1:Point = new Point (point1.x - pVectorX, point1.y + pVectorY);
				var pointVert2:Point = new Point (point2.x - pVectorX, point2.y + pVectorY);
				var pointVert3:Point = new Point (point2.x + pVectorX, point2.y - pVectorY);
				var pointVert4:Point = new Point (point1.x + pVectorX, point1.y - pVectorY);


				wheelShape.graphics.lineStyle (0);
				wheelShape.graphics.beginFill (0xFFFF00);
				wheelShape.graphics.drawCircle (point1.x, point1.y, 4);
				wheelShape.graphics.endFill ();

				// Draw poly segment line
				wheelShape.graphics.lineStyle (2, 0x000000);
				wheelShape.graphics.moveTo (point1.x, point1.y);
				wheelShape.graphics.lineTo (point2.x, point2.y);

				// Lets check the length of the segment

				// Distance forumula: d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
				var diffX:Number = point2.x - point1.x;
				var diffY:Number = point2.y - point1.y;
				var polySegmentLength:Number = Math.sqrt(diffX * diffX + diffY * diffY);
				var polySegmentAngleInRadians:Number = Math.atan2 (diffY, diffX);
				var polySegmentAngleInDegress:Number = polySegmentAngleInRadians * (180 / Math.PI);
				trace ("Rectangle TopLeft:", point1 ," Length: ", polySegmentLength, " Angle:", polySegmentAngleInDegress);



				// Create rectangle with text and position at polygon segment extruded rectangle
				var testRectangle:Sprite = new Sprite ();
				testRectangle.graphics.beginFill (0x00FFFF);
				testRectangle.graphics.drawRect (0, 0, polySegmentLength, 20);
				testRectangle.graphics.endFill ();
				testRectangle.x = point1.x;
				testRectangle.y = point1.y;
				testRectangle.rotation = polySegmentAngleInDegress;

				var testRectangleLable:TextField = new TextField ();
				testRectangleLable.embedFonts = true;
				testRectangleLable.defaultTextFormat = new TextFormat ("RobotoCondensed Regular", 12);
				testRectangleLable.text = /*_lunchVo.index.toString() + ". " +*/ _lunchVo.title;
				testRectangleLable.selectable = false;
				testRectangleLable.mouseEnabled = false;
				testRectangle.addChild (testRectangleLable);
				addChild (testRectangle);




				// Draw extruded rectangle from poly segment line
				wheelShape.graphics.lineStyle (1, 0xFF0000);
				wheelShape.graphics.moveTo (pointVert1.x, pointVert1.y);
				wheelShape.graphics.lineStyle (1, 0xCC66FF);
				wheelShape.graphics.lineTo (pointVert2.x, pointVert2.y);
				wheelShape.graphics.lineStyle (1, 0xFF6600);
				wheelShape.graphics.lineTo (pointVert3.x, pointVert3.y);
				wheelShape.graphics.lineStyle (1, 0x00FF00);
				wheelShape.graphics.lineTo (pointVert4.x, pointVert4.y);
				wheelShape.graphics.lineStyle (1, 0x0000FF);
				wheelShape.graphics.lineTo (pointVert1.x, pointVert1.y);


				point1.x = point2.x;
				point1.y = point2.y;
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