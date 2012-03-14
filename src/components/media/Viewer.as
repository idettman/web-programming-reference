package components.media
{
	import components.media.model.vo.MediaVo;

	import flash.display.Sprite;


	public class Viewer extends Sprite
	{
		private var _viewerWidth:Number;
		private var _viewerHeight:Number;
		
		private var _activeMedia:MediaVo;
		
		
		public function Viewer()
		{
			super();
		}
		
		private function update():void
		{
			if (_activeMedia)
			{
				
			}
		}
		
		public function get viewerWidth():Number { return _viewerWidth; }
		public function set viewerWidth(value:Number):void
		{
			_viewerWidth = value;
			
		}

		public function get viewerHeight():Number { return _viewerHeight; }
		public function set viewerHeight(value:Number):void
		{
			_viewerHeight = value;
		}

		public function get activeMedia():MediaVo { return _activeMedia; }
		public function set activeMedia(value:MediaVo):void
		{
			_activeMedia = value;
			update();
		}

		
	}
}
