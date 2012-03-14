package components.media.controls
{
	import components.media.model.vo.MediaVo;

	import flash.display.Sprite;


	public class ThumbnailButton extends Sprite
	{
		private var _data:MediaVo;
		
		public function ThumbnailButton()
		{
			super();
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 32, 32);
			graphics.endFill();
		}

		public function get data():MediaVo { return _data; }
		public function set data(value:MediaVo):void
		{
			_data = value;
		}
	}
}
