package components.media
{
	import components.media.view.MediaButton;
	import components.media.view.MediaSelector;
	import components.media.view.ThumbnailButton;
	import components.media.model.MediaViewerProxy;
	import components.media.model.MediaViewerProxyEvent;
	import components.media.view.Viewer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	[SWF(width='640', height='480', backgroundColor='#000000', frameRate='30')]
	public class MediaViewerComponent extends Sprite
	{
		public var imageViewerProxy:MediaViewerProxy;
		
		public var viewer:Viewer;
		public var thumbnailsTopRow:MediaSelector;
		public var thumbnailsBottomRow:MediaSelector;
		
		public var nextButton:MediaButton;
		public var previousButton:MediaButton;
		
		
		public function MediaViewerComponent()
		{
			super();
			if (stage)  init();
			else        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		private function init():void
		{
			initLayout();
			initModel();
			addListeners();
		}
		
		private function destroy():void
		{
			removeListeners();
			destroyModel();
			destroyLayout();
		}
		
		private function initModel():void
		{
			imageViewerProxy = new MediaViewerProxy();
			imageViewerProxy.addEventListener(MediaViewerProxyEvent.UPDATED, modelUpdatedHandler);
			imageViewerProxy.createTestData();
			imageViewerProxy.selectDefaultGallery();
		}

		private function destroyModel():void
		{
			imageViewerProxy.removeEventListener(MediaViewerProxyEvent.UPDATED, modelUpdatedHandler);
			imageViewerProxy.destroy();
			imageViewerProxy = null;
		}
		
		private function initLayout():void
		{
			viewer = new Viewer();
			addChild(viewer);
			viewer.viewerWidth = 300;
			viewer.viewerHeight = 225;
			
			thumbnailsTopRow = new MediaSelector();
			addChild(thumbnailsTopRow);
			thumbnailsTopRow.height = 32;
			thumbnailsTopRow.width = 300;
			thumbnailsTopRow.y = viewer.getRect(this).bottom + 8;
			
			thumbnailsBottomRow = new MediaSelector();
			addChild(thumbnailsBottomRow);
			thumbnailsBottomRow.height = 32;
			thumbnailsBottomRow.width = 300;
			thumbnailsBottomRow.y = thumbnailsTopRow.getRect(this).bottom + 8;
			
			
			previousButton = new MediaButton();
			addChild(previousButton);
			previousButton.clickHandler = previousButtonClickHandler;
			previousButton.x = 0;
			previousButton.y = viewer.height/2 - previousButton.height/2;
			
			nextButton = new MediaButton();
			addChild(nextButton);
			nextButton.clickHandler = nextButtonClickHandler;
			nextButton.x = viewer.width - nextButton.width;
			nextButton.y = viewer.height/2 - nextButton.height/2;
		}

		private function destroyLayout():void
		{
			
			while (numChildren) { removeChildAt(0); }
		}
		
		private function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		private function removedFromStageHandler(e:Event):void {    destroy();  }
		
		private function modelUpdatedHandler(e:MediaViewerProxyEvent):void
		{
			viewer.data = imageViewerProxy.selectedMedia;
			thumbnailsTopRow.data = imageViewerProxy.data[0];
			thumbnailsBottomRow.data = imageViewerProxy.data[1];
		}
		
		private function mouseOverHandler(e:MouseEvent):void
		{
			if (e.target is ThumbnailButton)
				ThumbnailButton(e.target).over();
		}

		private function mouseOutHandler(e:MouseEvent):void
		{
			if (e.target is ThumbnailButton)
				ThumbnailButton(e.target).out();
		}

		private function mouseClickHandler(e:MouseEvent):void
		{
			if (e.target is ThumbnailButton)
				imageViewerProxy.selectedMedia = ThumbnailButton(e.target).data;
		}
		
		private function nextButtonClickHandler():void
		{
			imageViewerProxy.next();
		}
		
		private function previousButtonClickHandler():void
		{
			imageViewerProxy.previous();
		}
		
		
		
		
	}
}
