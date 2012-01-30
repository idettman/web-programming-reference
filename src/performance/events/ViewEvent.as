package performance.events
{
	import flash.events.Event;


	public class ViewEvent extends Event
	{
		public static const ADDED_TO_STAGE_COMPLETE:String = "addedToStageComplete";
		
		public static const DESTROY_START:String = "destroyStart";
		
		public static const ANIMATE_IN:String = "animateIn";
		public static const ANIMATE_IN_COMPLETE:String = "animateInComplete";
		
		public static const ANIMATE_OUT:String = "animateOut";
		public static const ANIMATE_OUT_COMPLETE:String = "animateOutComplete";
		
		
		public function ViewEvent(type:String)
		{
			super(type, false, false);
		}
	}
}
