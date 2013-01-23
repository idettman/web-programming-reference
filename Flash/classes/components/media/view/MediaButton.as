package components.media.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;


	public class MediaButton extends Sprite
	{
		private static const DEFAULT_WIDTH:Number = 40;
		private static const DEFAULT_HEIGHT:Number = 40;
		
		private var _width:Number;
		private var _height:Number;
		private var _clickHandler:Function;
		
		
		public function MediaButton()
		{
			mouseChildren = false;
			buttonMode = true;
			
			width = DEFAULT_WIDTH;
			height = DEFAULT_HEIGHT;
			
			addListeners();
		}

		private function addListeners():void
		{
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
		}

		private function removeListeners():void
		{
			removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			removeEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			removeEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
		}
		
		
		public function over():void
		{
			alpha = 0.5;
		}
		
		public function out():void
		{
			alpha = 1;
		}
		
		private function update():void
		{
			if (!isNaN(_width) && !isNaN(_height))
			{
				graphics.beginFill(0xFF0000);
				graphics.drawCircle(_width/2, _height/2, _width/2);
				
				scrollRect = new Rectangle(0, 0, _width, _height);
			}
		}
		
		override public function get width():Number { return super.width; }
		override public function set width(value:Number):void
		{
			_width = value;
			update();
		}
		
		override public function get height():Number { return super.height; }
		override public function set height(value:Number):void
		{
			_height = value;
			update();
		}
		
		public function set clickHandler(clickHandler:Function):void 
		{
			_clickHandler = clickHandler;
		}
		
		private function mouseClickHandler(e:MouseEvent):void
		{
			
			if (_clickHandler != null)
				_clickHandler();
		}

		private function mouseRollOverHandler(e:MouseEvent):void
		{
			alpha = 0.5;
		}

		private function mouseRollOutHandler(e:MouseEvent):void
		{
			alpha = 1;
		}
		
		
	}
}
