package base.events
{
	import base.data.ButtonVo;

	import flash.events.Event;


	public class ButtonEvent extends Event
	{
		public static const CLICK:String = "ButtonEvent.click";
		public static const OVER:String = "ButtonEvent.over";
		public static const OUT:String = "ButtonEvent.out";
		public static const OFF:String = "ButtonEvent.off";
		public static const ON:String = "ButtonEvent.on";
		
		
		public var data:ButtonVo;
		
		public function ButtonEvent(type:String, data=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		
		override public function clone():Event
		{
			return new ButtonEvent(type, data, bubbles, cancelable);
		}
	}
}
