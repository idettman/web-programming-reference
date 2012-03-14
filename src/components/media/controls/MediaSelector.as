package components.media.controls
{
	import components.media.model.vo.GalleryVo;
	import components.media.model.vo.MediaVo;

	import flash.display.Sprite;
	
	
	public class MediaSelector extends Sprite
	{
		private var _data:GalleryVo;
		private var _thumbnails:Vector.<ThumbnailButton>;
		
		
		private function update():void
		{
			if (_data)
			{
				var lastRightX:Number = 0;
				var thumbnail:ThumbnailButton;
				for each (var media:MediaVo in _data.images)
				{
					if (thumbnail)
						lastRightX = thumbnail.getRect(this).right;
					
					thumbnail = new ThumbnailButton();
					addChild(thumbnail);
					thumbnail.data = media;
					thumbnail.x = lastRightX + 4; 
				}
			}
		}
		
		public function get data():GalleryVo { return _data; }
		public function set data(value:GalleryVo):void
		{
			_data = value;
			update();
		}

		
	}
}
