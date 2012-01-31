package base.display.ui.tooltip
{
	import flash.display.MovieClip;


	public class AbstractTooltip extends MovieClip
	{
		private var _data:*;
		
		public function AbstractTooltip()
		{
			super();
		}


		/**
		 * Getters/Setters
		 */
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:*):void
		{
			_data = value;
			updateData();
		}


		/**
		 * Private/Protected 
		 */
		private function updateData():void
		{
			if (_data)
			{
				
			}
		}
		
	}
}
