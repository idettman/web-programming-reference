package lunchwheel
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * ...
	 * @author Jonathan Kafkaris
	 */
	public class Spin extends Sprite
	{
		private var _dragging:Boolean;
		private var _a:Number;
		private var _b:Number;
		private var _oldRadius:Number;
		private var _square:Sprite;
		private var _rad:Number;
		private var _accr:Number = 0;
		private var _damp:Number = .96;


		public function Spin()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			_square = new Sprite();
			_square.graphics.beginFill(0xCCCCCC);
			_square.graphics.drawRect( -100, -100, 200, 200);
			_square.graphics.endFill();
			_square.x = stage.stageWidth * .5;
			_square.y = stage.stageHeight * .5;
			addChild(_square);

			_square.addEventListener(MouseEvent.MOUSE_DOWN, squareDownHandler, false, 0, true);
		}

		private function squareDownHandler(e:Event):void
		{
			_dragging = true;
			_a= mouseY - _square.y;
			_b= mouseX - _square.x;
			_oldRadius = Math.atan2(_a, _b) * 180 / Math.PI;

			_square.addEventListener(Event.ENTER_FRAME, squareEnterFrameHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHandler, false, 0, true);
		}

		private function stageUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageUpHandler);

			_dragging = false;
		}

		private function squareEnterFrameHandler(e:Event):void
		{
			if (_dragging)
			{
				_a = mouseY - _square.y;
				_b = mouseX - _square.x;
				_rad = Math.atan2(_a, _b) * 180/Math.PI;

				if (_rad - _oldRadius > 160 || _rad - _oldRadius < -160)
				{
					_accr = ((0) + _accr);
				}
				else
				{
					_accr = ((_rad - _oldRadius) + _accr) / 2;
				}

				_square.rotation += _accr;

				_oldRadius = _rad;
			}
			else
			{
				_square.rotation += _accr;
				if (Math.pow(_accr, 2) > .0001 )
				{
					_accr *= + _damp;
				}
				else
				{
					_accr = 0;
				}
			}
		}

	}

}
