package components.media
{
	import components.media.controls.MediaSelector;
	import components.media.model.MediaViewerProxy;
	import components.media.model.vo.GalleryVo;
	import components.media.model.vo.MediaVo;

	import flash.display.Sprite;
	import flash.events.Event;


	public class MediaViewerComponent extends Sprite
	{
		public var imageViewerProxy:MediaViewerProxy;
		
		public var viewer:Viewer;
		public var thumbnailsTopRow:MediaSelector;
		public var thumbnailsBottomRow:MediaSelector;
		
		
		public function MediaViewerComponent()
		{
			super();
			if (stage)  init();
			else        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		private function init():void
		{
			addListeners();
			initLayout();
			initModel();
		}
		
		private function destroy():void
		{
			destroyModel();
			removeListeners();
			destroyLayout();
		}
		
		private function initModel():void
		{
			imageViewerProxy = new MediaViewerProxy();
			
		}
		
		private function destroyModel():void
		{
			imageViewerProxy = null;
		}
		
		private function initLayout():void
		{
			viewer = new Viewer();
			addChild(viewer);

			var galleryData:GalleryVo = new GalleryVo();
			galleryData.images = new Vector.<MediaVo>();
			var mediaData:MediaVo;
			for (var i:int = 0; i < 6; i++)
			{
				mediaData = new MediaVo();
				mediaData.id = i.toString();
				galleryData.images.push(mediaData);
			}
			
			thumbnailsTopRow = new MediaSelector();
			addChild(thumbnailsTopRow);
			thumbnailsTopRow.data = galleryData;
			thumbnailsTopRow.y = 200;
			
			thumbnailsBottomRow = new MediaSelector();
			addChild(thumbnailsBottomRow);
			thumbnailsBottomRow.data = galleryData;
			thumbnailsBottomRow.y = 240;
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
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		private function removedFromStageHandler(e:Event):void {    destroy();  }
		
	}
}
