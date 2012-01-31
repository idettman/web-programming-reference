package base.display.animation
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class AbstractLibraryAnimation extends MovieClip
	{
		public function AbstractLibraryAnimation()
		{
			super();
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		protected function init():void
		{
			initLayout();
			addListeners();
			update();
		}
		
		
		protected function destroy():void
		{

		}
		
		
		protected function initLayout():void
		{
			
		}


		protected function destroyLayout():void
		{
			// Removed all chilren, call .stop() if child is movieclip
			var child:DisplayObject;
			while (numChildren)
			{
				child = removeChildAt(0);
				if (child is MovieClip)
					MovieClip(child).stop();
				child = null;
			}
		}
		
		
		protected function addListeners():void
		{
			
		}

		
		protected function removeListeners():void
		{
			
		}

		
		private function update():void
		{
			
		}
		

		/**
		 * Event Handlers
		 */
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			init();
		}


		private function removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			destroy();
		}


		
	}
}
