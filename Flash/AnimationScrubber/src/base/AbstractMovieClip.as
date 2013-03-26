package base
{

	import flash.display.MovieClip;
	import flash.events.Event;


	public class AbstractMovieClip extends MovieClip
	{
		public function AbstractMovieClip ()
		{
			super ();

			setDefaults ();

			if (loaderInfo)
			{
				if (this.framesLoaded == this.totalFrames)
				{
					if (stage)  init ();
					else        addEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
				}
				else
				{
					// loaderInfo NOT null, movieclip exists on the fla timeline
					loaderInfo.addEventListener (Event.COMPLETE, loaderInfoCompleteHandler);
				}
			}
			else
			{
				// loaderInfo IS null, movieclip not on fla timeline
				if (stage)  init ();
				else        addEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
			}
		}


		protected function setDefaults ():void
		{
			stop ();

			enabled = false;
			buttonMode = false;
			tabEnabled = false;
			tabChildren = true;
			mouseEnabled = false;
			useHandCursor = false;
			mouseChildren = true;
			doubleClickEnabled = false;
		}


		/**
		 * Private Methods
		 */
		protected function init ():void
		{
			addListeners ();
		}


		protected function destroy ():void
		{
			stop ();
			removeListeners ();

			while (numChildren)
			{
				removeChildAt (0);
			}
		}


		protected function addListeners ():void
		{
			addEventListener (Event.UNLOAD, unloadHandler);
			addEventListener (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}


		protected function removeListeners ():void
		{
			removeEventListener (Event.UNLOAD, unloadHandler);
			removeEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			if (loaderInfo)loaderInfo.removeEventListener (Event.COMPLETE, loaderInfoCompleteHandler);
		}


		/**
		 * Event Handlers
		 */
		protected function loaderInfoCompleteHandler (e:Event):void
		{
			loaderInfo.removeEventListener (Event.COMPLETE, loaderInfoCompleteHandler);

			if (stage)  init ();
			else        addEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
		}


		protected function addedToStageHandler (e:Event):void
		{
			removeEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
			init ();
		}


		protected function removedFromStageHandler (e:Event):void
		{
			destroy ();
		}


		protected function unloadHandler (e:Event):void
		{
			destroy ();
		}
	}
}
