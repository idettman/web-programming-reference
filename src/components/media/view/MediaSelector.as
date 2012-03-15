package components.media.view
{
	import com.greensock.TweenLite;

	import components.media.model.vo.GalleryVo;
	import components.media.model.vo.MediaVo;

	import flash.display.Sprite;
	import flash.geom.Rectangle;


	public class MediaSelector extends Sprite
	{
		private const THUMB_SPACING:Number = 6;
		
		private var _data:GalleryVo;
		private var _width:Number;
		private var _height:Number;
		public var thumbnailOffsetX:Number;
		public var viewableArea:Rectangle;
		private var _thumbnails:Vector.<ThumbnailButton>;
		
		
		public function MediaSelector()
		{
			super();
			viewableArea = new Rectangle();
			mouseEnabled = false;
		}
		
		
		public function transitionIn(delay:Number=0):void
		{
			var i:int = 0;
			for each (var thumbnailButton:ThumbnailButton in _thumbnails)
			{
				if (thumbnailButton.visibleInSelector)
				{
					thumbnailButton.visible = false;
					thumbnailButton.y = -50;
					TweenLite.to(thumbnailButton, 0.3, {y: 0, visible: true, delay: (i * 0.1) + delay});
					i++;
				}
			}
		}
		
		private function update():void
		{
			if (_data)
			{
				var selectedThumbnail:ThumbnailButton;
				
				if (!_thumbnails)
				{
					_thumbnails = new Vector.<ThumbnailButton>();
					var lastRightX:Number;
					var thumbnail:ThumbnailButton;
					
					for each (var media:MediaVo in _data.media)
					{
						if (thumbnail) lastRightX = thumbnail.getRect(this).right + THUMB_SPACING;
						else lastRightX = 0;
						
						thumbnail = new ThumbnailButton();
						addChild(thumbnail);
						thumbnail.data = media;
						thumbnail.x = lastRightX;
						thumbnail.selected = (_data.activeMedia == media);
						
						if (thumbnail.selected)
							selectedThumbnail = thumbnail;
						
						_thumbnails.push(thumbnail);
					}
				}
				else
				{
					for each (var thumbnailButton:ThumbnailButton in _thumbnails)
					{
						thumbnailButton.selected = (_data.activeMedia == thumbnailButton.data);
						if (thumbnailButton.selected)
							selectedThumbnail = thumbnailButton;
					}
				}
				
				if (selectedThumbnail)
				{
					thumbnailOffsetX = scrollRect.x + selectedThumbnail.getRect(this).right - scrollRect.right;
					if (thumbnailOffsetX < 0) thumbnailOffsetX = 0;
					
					TweenLite.killTweensOf(viewableArea);
					TweenLite.to(viewableArea, 0.4, { x:thumbnailOffsetX, onUpdate:updateScrollRect});
				}
			}
		}
		
		public function updateScrollRect():void
		{
			scrollRect = viewableArea; 
		}
		
		private function updateLayout():void
		{
			if (!isNaN(_width) && !isNaN(_height))
			{
				graphics.beginFill(0xFFFFFF, 0);
				graphics.drawRect(0, 0, _width, _height);
				graphics.endFill();
				
				viewableArea.x = 0;
				viewableArea.y = -40;
				viewableArea.width = _width;
				viewableArea.height = _height + 40;
				
				scrollRect = viewableArea;
			}
		}
		
		
		public function get data():GalleryVo { return _data; }
		public function set data(value:GalleryVo):void
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
	}
}
