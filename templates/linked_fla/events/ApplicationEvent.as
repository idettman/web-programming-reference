package events
{
	import flash.events.Event;


	public class ApplicationEvent extends Event
	{
		public static const VIEW_INIT:String = "viewInit";
		public static const VIEW_INIT_COMPLETE:String = "viewInitComplete";
		
		public static const MODEL_INIT:String = "modelInit";
		public static const MODEL_LOAD_DATA:String = "modelLoadData";
		public static const MODEL_LOAD_DATA_COMPLETE:String = "modelLoadDataComplete";
		
		public static const CLOSE_APPLICATION:String = "closeApplication";


		public var data:*;
		
		
		public function ApplicationEvent(type:String, data:* = null)
		{
			super(type, true, false);
			
			this.data = data;
		}
		
		
		override public function clone():Event
		{
			return new ApplicationEvent(type, data);
		}
	}
}
