package base
{
	import base.events.ViewEvent;

	import flash.display.MovieClip;
	import flash.events.Event;


	public class AbstractMovieClip extends MovieClip
	{
		/**
		 * Order of performance.events
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
		
		
		// Count frames to spacing out code execution on init
		private var _enterFrameCount:uint;
		
		
		public function AbstractMovieClip()
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
			stop();
			initLayout();
			addListeners();
			refreshDisplay();
		}
		
		
		/**
		 * Executed when/if removed from stage
		 */
		public function destroy():void
		{
			stop();
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
		 * Invalidate stage and wait for refresh
		 */
		private function refreshDisplay():void
		{
			_enterFrameCount = 0;
			stage.addEventListener(Event.RENDER, stageRenderHandler);
			stage.invalidate();
		}
		
		
		/**
		 * Invalidate stage and EnterFrame count completed, ready to animate
		 */
		protected function refreshDisplayComplete():void
		{
			dispatchEvent(new ViewEvent(ViewEvent.ADDED_TO_STAGE_COMPLETE));
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
		
		
		private function stageRenderHandler(e:Event):void
		{
			stage.removeEventListener(Event.RENDER, stageRenderHandler);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		private function enterFrameHandler(e:Event):void
		{
			if (_enterFrameCount > 3)
			{
				stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				
				_enterFrameCount = 0;
				refreshDisplayComplete();
				return;
			}
			_enterFrameCount++;
		}
		
		
	}
}
