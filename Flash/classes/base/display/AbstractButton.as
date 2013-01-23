package base.display
{
	import flash.events.MouseEvent;


	public class AbstractButton extends AbstractMovieClip
	{
		/**
		 * Private Methods
		 */
		override protected function setDefaults ():void
		{
			stop ();
			enabled = true;
			buttonMode = true;
			tabEnabled = true;
			tabChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			mouseChildren = false;
		}


		override protected function addListeners ():void
		{
			super.addListeners ();
			addEventListener (MouseEvent.CLICK, clickHandler);
			addEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener (MouseEvent.ROLL_OVER, rollOverHandler);

		}


		override protected function removeListeners ():void
		{
			super.removeListeners ();
			removeEventListener (MouseEvent.CLICK, clickHandler);
			removeEventListener (MouseEvent.ROLL_OUT, rollOutHandler);
			removeEventListener (MouseEvent.ROLL_OVER, rollOverHandler);
		}


		/**
		 * Event Handlers
		 */
		protected function rollOverHandler (e:MouseEvent):void
		{
			//trace (this, "over handler");
		}


		protected function rollOutHandler (e:MouseEvent):void
		{
			//trace (this, "out handler");
		}


		protected function clickHandler (e:MouseEvent):void
		{
			//trace (this, "click handler");
		}
	}
}
