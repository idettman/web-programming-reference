package components.media.view
{
	import components.media.model.vo.MediaVo;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;


	public class ThumbnailButton extends Sprite
	{
		private static const DEFAULT_WIDTH:Number = 32;
		private static const DEFAULT_HEIGHT:Number = 32;
		
		private var _data:MediaVo;
		private var _width:Number;
		private var _height:Number;
		private var _selected:Boolean;
		
		public var bitmap:Bitmap;
		
		
		public function ThumbnailButton()
		{
			super();
			init();
		}
		
		
		public function over():void
		{
			if (!_selected)
			{
				alpha = 0.5;
			}
			else
			{
				alpha = 0.1;
			}
		}
		
		public function out():void
		{
			if (!_selected)
			{
				alpha = 1;
			}
			else
			{
				alpha = 0.2;
			}
		}
		
		private function init():void
		{
			buttonMode = true;
			mouseChildren = false;
			
			_selected = false;
			
			bitmap = new Bitmap();
			addChild(bitmap);
			
			if (isNaN(_width))  width = DEFAULT_WIDTH;
			if (isNaN(_height)) height = DEFAULT_HEIGHT;
		}
		
		private function update():void
		{
			if (_data)
			{
				bitmap.bitmapData = _data.thumbnail;
			}
		}
		
		private function updateLayout():void
		{
			if (!isNaN(_width) && !isNaN(_height))
			{
				scrollRect = new Rectangle(0, 0, _width, _height);
			}
		}
		
		private function updateSelected():void
		{
			
			if (!_selected) {
				mouseEnabled = true;
				out();
			}
			else {
				mouseEnabled = false;
				over();
			}
		}
		
		
		public function get data():MediaVo { return _data; }
		public function set data(value:MediaVo):void
		{
			_data = value;
			update();
		}

		override public function get width():Number { return super.width; }
		override public function set width(value:Number):void
		{
			_width = value;
			updateLayout();
		}

		override public function get height():Number { return super.height; }
		override public function set height(value:Number):void
		{
			_height = value;
			updateLayout();
		}

		public function get visibleInSelector():Boolean
		{
			if (this.parent)
				return this.parent.scrollRect.containsRect(getRect(this.parent));
			else 
				return false;
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateSelected();
		}

	}
}
