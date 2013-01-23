package components.media.model
{
	import components.media.model.vo.GalleryVo;
	import components.media.model.vo.MediaVo;

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;


	public class MediaViewerProxy extends EventDispatcher
	{
		private var _data:Vector.<GalleryVo>;
		private var _selectedMedia:MediaVo;
		
		
		public function createTestData():void
		{
			var galleryA:GalleryVo = new GalleryVo();
			galleryA.id = "galleryA";
			galleryA.title = "Gallery A";
			galleryA.media = new Vector.<MediaVo>();
			
			var i:int;
			var media:MediaVo;
			for (i = 0; i < 12; i++)
			{
				media = new MediaVo();
				media.id = i.toString();
				media.image = getRandomBitmapData(300, 250);
				media.thumbnail = getRandomBitmapData(32, 32);
				galleryA.media.push(media);
			}
			
			// SET DEFAULT GALLERY
			galleryA.activeMedia = galleryA.media[0];
			_selectedMedia = galleryA.activeMedia;
			
			
			var galleryB:GalleryVo = new GalleryVo();
			galleryB.id = "galleryB";
			galleryB.title = "Gallery B";
			galleryB.media = new Vector.<MediaVo>();
			
			for (i = 0; i < 12; i++)
			{
				media = new MediaVo();
				media.id = i.toString();
				media.image = getRandomBitmapData(300, 250);
				media.thumbnail = getRandomBitmapData(32, 32);
				galleryB.media.push(media);
			}
			
			var galleries:Vector.<GalleryVo> = new Vector.<GalleryVo>();
			galleries.push(galleryA);
			galleries.push(galleryB);
			
			_data = galleries;
			dispatchEvent(new MediaViewerProxyEvent(MediaViewerProxyEvent.MEDIA_LOADED));
		}

		private const RANDOM_COLORS:Vector.<uint> = new <uint>[0xCDCDCD, 0x666666, 0x3b69a8, 0x3ba89f, 0x9c3ba8, 0xa8283d, 0xa87f28, 0xab0000, 0x21902c ];
		
		private function getRandomBitmapData(width:Number, height:Number):BitmapData
		{
			var fillColor:uint = RANDOM_COLORS[Math.round(Math.random() * (RANDOM_COLORS.length-1))]; 
			return new BitmapData(width, height, false, fillColor);
		}
		
		public function next():void
		{
			if (_selectedMedia)
			{
				var gallery:GalleryVo;
				var mediaGalleryIndex:int;
				
				for each (gallery in _data)
				{
					mediaGalleryIndex = gallery.media.indexOf(_selectedMedia);
					
					if (mediaGalleryIndex != -1)
					{
						if ((mediaGalleryIndex+1) < gallery.media.length)
						{
							selectedMedia = gallery.media[mediaGalleryIndex+1]; 
						}
						else
						{
							var currentGalleryIndex:int = _data.indexOf(gallery);
							var nextGallery:GalleryVo;
							
							if ((currentGalleryIndex+1) < _data.length)
								nextGallery = _data[currentGalleryIndex + 1];
							else
								nextGallery = _data[0];
							selectedMedia = nextGallery.media[0];
						}
						return;
					}
				}
			}
		}
		
		public function previous():void
		{
			if (_selectedMedia)
			{
				var gallery:GalleryVo;
				var mediaGalleryIndex:int;
				
				for each (gallery in _data)
				{
					mediaGalleryIndex = gallery.media.indexOf(_selectedMedia);
					
					if (mediaGalleryIndex != -1)
					{
						if ((mediaGalleryIndex-1) >= 0)
						{
							selectedMedia = gallery.media[mediaGalleryIndex-1]; 
						}
						else
						{
							var currentGalleryIndex:int = _data.indexOf(gallery);
							var nextGallery:GalleryVo;
							
							if ((currentGalleryIndex-1) >= 0)
								nextGallery = _data[currentGalleryIndex - 1];
							else
								nextGallery = _data[_data.length-1];
							selectedMedia = nextGallery.media[nextGallery.media.length-1];
						}
						return;
					}
				}
			}
		}
		
		private function updateSelectedMedia():void
		{
			var mediaGalleryIndex:int;
			
			for each (var gallery:GalleryVo in _data)
			{
				gallery.activeMedia = null;
				mediaGalleryIndex = gallery.media.indexOf(_selectedMedia);
				if (mediaGalleryIndex != -1)
				{
					gallery.activeMedia = _selectedMedia;
				}
			}
			dispatchEvent(new MediaViewerProxyEvent(MediaViewerProxyEvent.UPDATED));
		}
		
		
		
		
		public function get data():Vector.<GalleryVo> { return _data; }
		public function set data(value:Vector.<GalleryVo>):void
		{
			_data = value;
			dispatchEvent(new MediaViewerProxyEvent(MediaViewerProxyEvent.UPDATED));
		}
		
		public function destroy():void
		{
			_data = null;
		}
		
		public function get selectedMedia():MediaVo { return _selectedMedia; }
		public function set selectedMedia(value:MediaVo):void
		{
			_selectedMedia = value;
			updateSelectedMedia();
		}

		
	}
}
