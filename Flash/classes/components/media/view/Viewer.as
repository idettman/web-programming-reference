package components.media.view
{
	import components.media.model.vo.MediaVo;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;


	public class Viewer extends Sprite
	{
		private var _viewerWidth:Number;
		private var _viewerHeight:Number;
		
		private var _data:MediaVo;
		
		public var bitmap:Bitmap;
		
		
		public function Viewer()
		{
			super();
			bitmap = new Bitmap();
			addChild(bitmap);
		}
		
		private function update():void
		{
			if (!isNaN(_viewerWidth) && !isNaN(_viewerHeight))
			{
				graphics.clear();
				graphics.beginFill(0x00FF00);
				graphics.drawRect(0, 0, _viewerWidth, _viewerHeight);
				
				scrollRect = new Rectangle(0, 0, _viewerWidth, _viewerHeight);
			}
			
			if (_data)
			{
				bitmap.bitmapData = _data.image;
			}
		}
		
		public function get viewerWidth():Number { return _viewerWidth; }
		public function set viewerWidth(value:Number):void
		{
			_viewerWidth = value;
			update();
		}

		public function get viewerHeight():Number { return _viewerHeight; }
		public function set viewerHeight(value:Number):void
		{
			_viewerHeight = value;
			update();
		}

		public function set data(data:MediaVo):void 
		{
			_data = data;
			update();
		}
	}
}
