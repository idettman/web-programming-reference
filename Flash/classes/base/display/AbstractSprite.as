package base.display
{
	import flash.display.Sprite;
	import flash.events.Event;


	public class AbstractSprite extends Sprite
	{
		/**
		 * Order of events
		 *
		 * 1) preInit()
		 *
		 * 2) addedToStageHandler()
		 * 3) init()
		 * 4) initLayout()
		 * 5) addListeners()
		 *
		 * 6) removedFromStageHandler()
		 * 7) destroy()
		 * 8) removeListeners();
		 * 9) destroyLayout();
		 *
		 */

		
		public function AbstractSprite()
		{
			super();
			preInit();
		}
		
		
		/**
		 * Executed from the constructor 
		 */
		protected function preInit():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		/**
		 * Executed when/if added to stage
		 */
		public function init():void
		{
			initLayout();
			addListeners();
		}
		
		
		/**
		 * Executed when/if removed from stage
		 */
		public function destroy():void
		{
			removeListeners();
			destroyLayout();
		}
		
		
		/**
		 * Initialize/position display objects
		 */
		protected function initLayout():void
		{
			
		}
		
		
		/**
		 * Cleanup display objects
		 */
		protected function destroyLayout():void
		{
			while(numChildren)
			{
				removeChildAt(0);
			}
			
		}
		
		
		/**
		 * Executed after initLayout()
		 */
		protected function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		/**
		 * Executed before destroy()
		 */
		protected function removeListeners():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}


		/**
		 * Event Handlers for added / removed from stage
		 */
		protected function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		
		protected function removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			destroy();
		}
		

	}
}
