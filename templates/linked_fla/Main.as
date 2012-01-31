package 
{
	import events.ApplicationEvent;

	import flash.display.MovieClip;
	import flash.events.Event;

	import model.ContentProxy;

	import view.MainContent;


	public class Main extends MovieClip
	{
		private var _mainContent:MainContent;// Application View
		private var _contentProxy:ContentProxy;// Application Model
		
		
		public function Main()
		{
			trace("Main constructor");
			
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		private function init():void
		{
			trace("init");
			
			addListeners();
			initView();
		}
		
		
		private function destroy():void
		{
			removeListeners();
			destroyModel();
			destroyView();
		}


		private function initView():void
		{
			_mainContent = new MainContent();
			_mainContent.addEventListener(ApplicationEvent.VIEW_INIT_COMPLETE, viewInitCompleteHandler);
			addChild(_mainContent);
		}

		
		private function initViewComplete():void
		{
			trace("init view complete");
			initModel();
		}
		
		
		private function initModel():void
		{
			_contentProxy = new ContentProxy();
			_contentProxy.addEventListener(ApplicationEvent.MODEL_LOAD_DATA_COMPLETE, contentLoadCompleteHandler);
			_contentProxy.loadData();
		}
		

		private function initModelComplete():void
		{
			trace("init model complete");
			animateIn();
		}


		private function destroyModel():void
		{
			if (_contentProxy)
			{
				_contentProxy.removeEventListener(ApplicationEvent.MODEL_LOAD_DATA_COMPLETE, contentLoadCompleteHandler);
				_contentProxy.destroy();
				_contentProxy = null;
			}
		}
		
		
		private function destroyView():void
		{
			if (_mainContent)
			{
				if (_mainContent.parent)
					removeChild(_mainContent);
				
				_mainContent = null;
			}
		}
		
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}


		private function animateIn():void
		{

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
		
		
		private function contentLoadCompleteHandler(e:ApplicationEvent):void
		{
			_contentProxy.removeEventListener(ApplicationEvent.MODEL_LOAD_DATA_COMPLETE, contentLoadCompleteHandler);
			_mainContent.data = e.data;
			
			initModelComplete();
		}

		
		private function viewInitCompleteHandler(e:ApplicationEvent):void
		{
			_mainContent.removeEventListener(ApplicationEvent.VIEW_INIT_COMPLETE, viewInitCompleteHandler);
			
			initViewComplete();
		}

	}
}
