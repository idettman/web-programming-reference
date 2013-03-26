package tweenengines
{
	import a24.tween.Ease24;
	import a24.tween.Tween24;

	import base.display.AbstractSprite;

	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;


	public class Tween24_Test extends AbstractSprite
	{
		//private var _shapes:Vector.<Shape>;
		private var _shapes:Array;

		private var _shape:Shape;
		private var _circle:Shape;

		private var _canvas:Shape;


		public function Tween24_Test ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			/*_shape = new Shape ();
			_shape.graphics.beginFill (0xFF0000);
			_shape.graphics.drawRect (0, 0, 80, 80);
			_shape.graphics.endFill ();
			addChild (_shape);
			Tween24.tween (_shape, 3).x (900).onComplete(initialTweenCompleteHandler).play();*/


			/*_shapes = new Array (100);
			var i:int = 0;
			while (i < _shapes.length)
			{
				_shapes[i] = new Shape ();
				_shapes[i].graphics.beginFill (0x00FF00);
				_shapes[i].graphics.drawRect (0, 0, 80, 80);
				_shapes[i].graphics.endFill ();
				addChild (_shapes[i]);

				//Tween24.tween (_shapes[i], Math.random () * 10, Ease24._4_QuartInOut).xy (Math.random () * 1000, Math.random () * 690).delay (Math.random () * 5).play ();
				//Tween24.tweenVelocity (_shapes[i], 100 + Math.random () * 100, Ease24._4_QuartInOut).xy (100 + Math.random () * 900, 100 + Math.random () * 690).delay (Math.random () * 0.2).play ();

				i++;
			}

			Tween24.lag (0.3,
				Tween24.prop (_shapes).fadeOut (),
				Tween24.tween(_shapes, Math.random () * 10, Ease24._4_QuartInOut).xy (Math.random () * 1000, Math.random () * 690).fadeIn()
			).play ();*/



			// Bezier tween with path debug display
			_canvas = new Shape ();
			_canvas.graphics.lineStyle (2);
			_canvas.graphics.moveTo (0, 0);
			addChild (_canvas);

			_circle = new Shape ();
			_circle.graphics.beginFill (0x0000FF);
			_circle.graphics.drawCircle (30, 30, 30);
			_circle.graphics.endFill ();
			addChild (_circle);

			Tween24.tween (_circle, 4, Ease24._3_CubicInOut).x (900).y(700).bezier(500, 400).bezier(50, 300).bezier(800, 50).bezier(100, 460).onUpdate(circleTweenUpdateHandler).play();



			// Tween function arguments
			graphics.lineStyle (1, 0x0F0F0F, 1, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 1);
			Tween24.tweenFunc (draw, 3, [0, 760, 1], [1024, 0, 200], Ease24._3_CubicInOut).play ();
		}

		private function draw(xPos:Number, yPos:Number, lineThickness:Number):void
		{
			graphics.lineStyle (Math.ceil (lineThickness));
			graphics.lineTo (xPos, yPos);
		}

		private function circleTweenUpdateHandler ():void
		{
			_canvas.graphics.lineTo (_circle.x, _circle.y);
		}

		private function initialTweenCompleteHandler ():void
		{
			Tween24.tweenVelocity (_shape, 400, Ease24._4_QuartIn).x(10).play ();
		}
	}
}
