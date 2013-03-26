package components.animationscrubber
{
	import base.AbstractMovieClip;

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	public class AnimationScrubberComponent extends AbstractMovieClip
	{
		private var _animation:MovieClip;


		private var _mouseDown:Boolean;
		private var _mousePosition:Point;
		private var _prevMousePosition:Point;

		private var _startDragFrameNum:uint;
		private var _animationActiveFrame:uint;
		public var debugView:Shape;


		override protected function setDefaults ():void
		{
			super.setDefaults ();
			_mouseDown = false;
			_startDragFrameNum = 1;
			_animationActiveFrame = 0;
		}


		override protected function init ():void
		{
			super.init ();
			debugView = new Shape ();
			_mousePosition = new Point (mouseX, 0);
			_prevMousePosition = new Point (mouseX, 0);
		}


		override protected function addListeners ():void
		{
			super.addListeners ();
			stage.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener (Event.MOUSE_LEAVE, mouseLeaveHandler);
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}


		override protected function removeListeners ():void
		{
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.removeEventListener (Event.MOUSE_LEAVE, mouseLeaveHandler);
			removeEventListener (Event.ENTER_FRAME, enterFrameHandler);
			super.removeListeners ();
		}


		private function updateAnimation ():void
		{
			_animation.stop ();
			addChild (_animation);
			trace ("Update animation:", _animation, _animation.width, _animation.height, _animation.totalFrames);
		}


		public function get animation ():MovieClip { return _animation; }


		public function set animation (value:MovieClip):void
		{
			_animation = value;
			updateAnimation ();
		}


		public function get animationActiveFrame ():uint { return _animationActiveFrame; }

		public function set animationActiveFrame (value:uint):void
		{
			if (value != _animationActiveFrame)
			{
				_animationActiveFrame = value;
				_animation.gotoAndStop (value);
			}
		}


		public function get mouseDown ():Boolean { return _mouseDown; }
		
		public function set mouseDown (value:Boolean):void
		{
			if (value != _mouseDown)
			{
				_mouseDown = value;

				if (_mouseDown)
				{
					_startDragFrameNum = _animation.currentFrame;
					_prevMousePosition.x = mouseX;
					_prevMousePosition.y = mouseY;
				}
				else
				{

				}
			}
		}


		private function mouseMoveHandler (e:MouseEvent):void
		{
			mouseDown = e.buttonDown;

			if (mouseDown)
			{
				/*_mousePosition.x = mouseX;

				var offsetX:Number = _mousePosition.x - _prevMousePosition.x;
				var frameOffset:Number = Math.round ((offsetX / stage.stageWidth) * (_animation.totalFrames));
				var nextFrame:Number = 1 + (_startDragFrameNum + frameOffset) % (_animation.totalFrames - 1);

				if (nextFrame < 1)
				{
					nextFrame = _animation.totalFrames - (Math.abs (nextFrame) % _animation.totalFrames);
				}

				animationActiveFrame = nextFrame;*/
			}
		}


		private function enterFrameHandler (e:Event):void
		{

		}



		private function mouseDownHandler (e:MouseEvent):void
		{
			mouseDown = true;
		}


		private function mouseUpHandler (e:MouseEvent):void
		{
			mouseDown = false;
		}


		private function mouseLeaveHandler (e:Event):void
		{
			//trace ("mouse LEAVE");
		}


	}
}
