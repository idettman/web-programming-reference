package com.eclecticdesignstudio.utils {
	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	
	/**
	 * @author Joshua Granick
	 */
	public class FPSCounter extends Sprite {
		
		
		private var TimeCounter:Timer;
		private var TimeDisplay:TextField;
		
		private var frameCount:uint;
		
		
		public function FPSCounter () {
			
			initialize ();
			
		}
		
		
		private function initialize ():void {
			
			frameCount = 0;
			
			TimeDisplay = new TextField ();
			TimeDisplay.background = true;
			TimeDisplay.autoSize = TextFieldAutoSize.LEFT;
			TimeDisplay.selectable = false;
			addChild (TimeDisplay);
			
			addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
			
			TimeCounter = new Timer (1000);
			TimeCounter.addEventListener (TimerEvent.TIMER, TimeCounter_onTimer);
			TimeCounter.start ();
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function this_onEnterFrame (event:Event):void {
			
			frameCount ++;
			
		}
		
		
		private function TimeCounter_onTimer (event:TimerEvent):void {
			
			TimeDisplay.text = "FPS: " + frameCount;
			frameCount = 0;
			
		}
		
		
	}
	
	
}