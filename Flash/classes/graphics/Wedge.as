package graphics
{
	import base.display.AbstractSprite;

	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * Draw a segment of a circle
	 * @param target    <Sprite> The object we want to draw into
	 * @param x         <Number> The x-coordinate of the origin of the segment
	 * @param y         <Number> The y-coordinate of the origin of the segment
	 * @param r         <Number> The radius of the segment
	 * @param aStart    <Number> The starting angle (degrees) of the segment (0 = East)
	 * @param aEnd      <Number> The ending angle (degrees) of the segment (0 = East)
	 * @param step      <Number=1> The number of degrees between each point on the segment's circumference
	 */

	public dynamic class Wedge extends AbstractSprite {

		private var _colour:Number;
		private var _x:Number;
		private var _y:Number;
		private var _radius:Number;
		private var _aStart:Number;
		private var _aEnd:Number;
		private var _step:Number;

		public function Wedge(colour:Number, x:Number, y:Number, radius:Number, aStart:Number, aEnd:Number, step:Number = 1)
		{
			_colour = colour;
			_x = x;
			_y = y;
			_radius = radius;
			_aStart = aStart;
			_aEnd = aEnd;
			_step = step;

			init();
		}

		private function init(e:Event = null):void
		{
			this.graphics.lineStyle (1);
			this.graphics.beginFill(_colour);
			this.drawSegment(this, _x, _y, _radius, _aStart, _aEnd, _step);
			this.graphics.endFill();
		}

		private function drawSegment(target:Sprite, x:Number, y:Number, r:Number, aStart:Number, aEnd:Number, step:Number = 1):void {
			// More efficient to work in radians
			var degreesPerRadian:Number = Math.PI / 180;
			aStart *= degreesPerRadian;
			aEnd *= degreesPerRadian;
			step *= degreesPerRadian;

			// Draw the segment

			target.graphics.moveTo(x, y);


			// Uncomment next line to draw with no interpolation, also comment out the for loop
			//target.graphics.lineTo(x + r * Math.cos(aStart), y + r * Math.sin(aStart));

			for (var theta:Number = aStart; theta < aEnd; theta += Math.min(step, aEnd - theta)) {
				target.graphics.lineTo(x + r * Math.cos(theta), y + r * Math.sin(theta));
			}

			target.graphics.lineTo(x + r * Math.cos(aEnd), y + r * Math.sin(aEnd));
			target.graphics.lineTo(x, y);
		}
	}
}
