package base.events
{
	import flash.events.Event;


	public class ContentEvent extends Event
	{
		public static const LOAD_STARTED:String = "ContentEvent.loadStarted"; 
		public static const LOAD_COMPLETED:String = "ContentEvent.loadCompleted";
		
		public var data:*;
		
		
		public function ContentEvent(type:String, data:*=null)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		
		override public function clone():Event
		{
			return new ContentEvent(type,  data);
		}
	}
}
