package base.display
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;

	import utils.DisplayListUtils;


	public class AbstractMovieClip extends MovieClip
	{
		public function AbstractMovieClip ()
		{
			super ();

			setDefaults ();

			// If root exists, then display obj was sitting on frame 1, and not added with code
			if (root)
			{
				if (!InitializationCue.initializeCue)
					InitializationCue.initializeCue = new Vector.<Object> ();

				InitializationCue.initializeCue.push (this);
				root.loaderInfo.addEventListener (Event.COMPLETE, loadInfoCompleteHandler);
			}
			else
			{
				if (stage)  init ();
				else        addEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
			}
		}


		protected function setDefaults ():void
		{
			enabled = false;
			buttonMode = false;
			tabEnabled = false;
			tabChildren = true;
			mouseEnabled = false;
			useHandCursor = false;
			mouseChildren = true;
			doubleClickEnabled = false;
		}


		protected function init ():void
		{
			addListeners ();

			trace ("INIT: ", (getTimer()).toString(), this, this.name, "  depth:", DisplayListUtils.calculateDisplayListDepth(this));

			if (InitializationCue.initializeCue)
			{
				var cuePosition:int = InitializationCue.initializeCue.indexOf (this);
				if (cuePosition != -1)
					InitializationCue.initializeCue[cuePosition] = null;

				var initializeCueEmpty:Boolean = true;
				for (var i:int = 0; i < InitializationCue.initializeCue.length; i++)
				{
					if (InitializationCue.initializeCue[i] != null)
					{
						initializeCueEmpty = false;
						break;
					}
				}

				if (initializeCueEmpty)
				{
					InitializationCue.initializeCue = null;
					stage.dispatchEvent (new Event ("initializeCueEmpty"));
				}
			}
			else
			{
				initComplete ();
			}
		}


		protected function initComplete():void
		{
			trace ("INIT COMPLETE: ", (getTimer()).toString(), this, this.name, "  depth:", DisplayListUtils.calculateDisplayListDepth(this));
		}


		protected function destroy ():void
		{
			if (InitializationCue.initializeCue)
			{
				var cuePosition:int = InitializationCue.initializeCue.indexOf (this);
				if (cuePosition != -1)
					InitializationCue.initializeCue[cuePosition] = null;

				var initializeCueEmpty:Boolean = true;
				for (var i:int = 0; i < InitializationCue.initializeCue.length; i++)
				{
					if (InitializationCue.initializeCue[i] != null)
					{
						initializeCueEmpty = false;
						break;
					}
				}

				if (initializeCueEmpty)
				{
					InitializationCue.initializeCue = null;
				}
			}

			while (numChildren)
			{
				removeChildAt (0);
			}
		}


		protected function addListeners ():void
		{
			addEventListener (Event.UNLOAD, unloadHandler);
			addEventListener (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			stage.addEventListener ("initializeCueEmpty", initializeCueEmptyHandler);
		}


		protected function removeListeners ():void
		{
			removeEventListener (Event.UNLOAD, unloadHandler);
			removeEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			stage.removeEventListener ("initializeCueEmpty", initializeCueEmptyHandler);
		}


		/**
		 * Event Handlers
		 */
		protected function loadInfoCompleteHandler (e:Event):void
		{
			if (stage)  init ();
			else        addEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
		}


		protected function addedToStageHandler (e:Event):void
		{
			//trace ("ADDED TO STAGE:", this, this.name);
			removeEventListener (Event.ADDED_TO_STAGE, addedToStageHandler);
			init ();
		}


		protected function removedFromStageHandler (e:Event):void
		{
			trace ("REMOVED FROM STAGE:", this, this.name);
			removeListeners ();
			destroy ();
		}


		protected function unloadHandler (e:Event):void
		{
			trace ("UNLOAD:", this, this.name);
			removeListeners ();
			destroy ();
		}


		protected function initializeCueEmptyHandler (e:Event):void
		{
			stage.removeEventListener ("initializeCueEmpty", initializeCueEmptyHandler);
			initComplete ();
		}

	}
}
