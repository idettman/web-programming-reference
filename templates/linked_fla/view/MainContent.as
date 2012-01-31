package view
{
	import events.ApplicationEvent;

	import flash.display.MovieClip;
	import flash.events.Event;


	/**
	 * MainContent should always be linked to a library movieclip and instantiated from the Document class
	 */
	public class MainContent extends MovieClip
	{
		private var _data:*;
		
		
		public function MainContent()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}


		/**
		 * Getters/Setters
		 */
		public function set data(data:*):void
		{
			_data = data;
			updateData();
		}


		private function init():void
		{
			initLayout();
			addListeners();
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.VIEW_INIT_COMPLETE));
		}


		private function destroy():void
		{
			removeListeners();
			destroyLayout();
		}
		
		
		private function initLayout():void
		{

		}


		private function destroyLayout():void
		{

		}
		

		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		
		private function updateData():void
		{
			if (_data)
			{
				
			}
		}


		/**
		 * Event Handlers
		 */
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		
		private function removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			destroy();
		}


		
	}
}
