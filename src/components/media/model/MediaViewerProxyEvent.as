package components.media.model
{
	import flash.events.Event;


	public class MediaViewerProxyEvent extends Event
	{
		public static const UPDATED:String = "updated";
		public static const MEDIA_SELECTED:String = "mediaSelected";
		
		
		public function MediaViewerProxyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
