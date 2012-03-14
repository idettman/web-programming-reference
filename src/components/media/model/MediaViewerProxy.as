package components.media.model
{
	import components.media.model.vo.GalleryVo;


	public class MediaViewerProxy
	{
		private var _data:Vector.<GalleryVo>;
		private var _activeGallery:GalleryVo;
		
		
		public function MediaViewerProxy()
		{
			
		}
		
		public function next():void
		{
			
		}
		
		public function previous():void
		{
			
		}
		
		private function update():void
		{
			if (_data)
			{
				
			}
		}
		
		public function get data():Vector.<GalleryVo> { return _data; }
		public function set data(value:Vector.<GalleryVo>):void
		{
			_data = value;
			update();
		}

		public function get activeGallery():GalleryVo { return _activeGallery; }
		public function set activeGallery(value:GalleryVo):void
		{
			_activeGallery = value;
			update();
		}
	}
}
