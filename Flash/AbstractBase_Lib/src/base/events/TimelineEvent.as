package base.events
{
	import flash.events.Event;


	public class TimelineEvent extends Event
	{
		public static const INIT:String = "timeline.Init";
		public static const ANIMATE_IN:String = "timeline.animateIn";
		public static const ANIMATE_IN_COMPLETE:String = "timeline.animateInComplete";
		public static const ANIMATE_OUT:String = "timeline.animateOut";
		public static const ANIMATE_OUT_COMPLETE:String = "timeline.animateOutComplete";
		
		
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			return new TimelineEvent(type, bubbles, cancelable);
		}
	}
}
