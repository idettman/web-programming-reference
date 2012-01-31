package base.display.ui.buttons
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;


	public class AbstractLibraryButton extends MovieClip
	{
		private var _buttonText:String;
		private var _buttonIcon:DisplayObject;
		
		
		public function AbstractLibraryButton()
		{
			super();
			preInit();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}


		/**
		 * Getters/Setters
		 */
		public function get buttonText():String
		{
			return _buttonText;
		}


		public function set buttonText(value:String):void
		{
			_buttonText = value;
			update();
		}


		public function get buttonIcon():DisplayObject
		{
			return _buttonIcon;
		}


		public function set buttonIcon(value:DisplayObject):void
		{
			_buttonIcon = value;
			update();
		}


		/**
		 * Public methods
		 */
		
		
		/**
		 * Private/Protected methods
		 */
		private function preInit():void
		{
			
		}
		
		
		protected function init():void
		{
			setDefaults();
			initLayout();
			addListeners();
		}


		private function setDefaults():void
		{
			mouseChildren = false;
		}


		protected function initLayout():void
		{
			
		}


		private function destroyLayout():void
		{
			
		}

		
		protected function addListeners():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		private function removeListeners():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		
		protected function destroy():void
		{
			destroyLayout();
			removeListeners();
		}

		
		protected function update():void
		{
			
		}


		/**
		 * Button has been added to stage, call init and add listeners
		 */
		protected function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}

		protected function removedFromStageHandler(e:Event):void
		{
			destroy();
		}


		
	}
}
