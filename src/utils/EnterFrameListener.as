package utils
{
	import flash.display.Stage;
	import flash.events.Event;
	
	
	public class EnterFrameListener
	{
		private static var _instance:EnterFrameListener;
		
		private var _stageReference:Stage;
		private var _enterFrameHandlers:Array;
		
		
		/**
		 * Singleton pattern, do not instantiate using new EnterFrameSingleton(). Use EnterFrameSingleton.getInstance()
		 */
		public function EnterFrameListener()
		{
			if (_instance) throw new Error("EnterFrameListener - Singleton Exception");
			_enterFrameHandlers = new Array();
		}
		
		
		/**
		 * Getters/Setters
		 */
		public function get stageReference():Stage
		{
			return _stageReference;
		}
		
		
		public function set stageReference(value:Stage):void
		{
			if (_stageReference && !value) // setting to null, remove all handlers
			{
				destroy();
			}
			else if (_stageReference && value)
			{
				return;
			}

			_stageReference = value;

			if (_stageReference && _enterFrameHandlers.length)
			{
				addListeners();
			}
		}
		
		
		public function addEnterFrameListener (eventHandler:Function):void
		{
			var index:int = _enterFrameHandlers.indexOf(eventHandler);
			if (index == -1)
			{
				_enterFrameHandlers.push(eventHandler);
				if (_stageReference)
				{
					_stageReference.addEventListener(Event.ENTER_FRAME, eventHandler);
				}
			}
		}
		
		public function removeEnterFrameListener (eventHandler:Function):void
		{
			var index:int = _enterFrameHandlers.indexOf(eventHandler);
			if (index != -1)
			{
				_enterFrameHandlers.splice(index, 1);
				
				if (_stageReference)
				{
					_stageReference.removeEventListener(Event.ENTER_FRAME, eventHandler);
				}
			}
		}

		public static function getInstance():EnterFrameListener
		{
			if (_instance)
			{
				return _instance;
			}
			else
			{
				_instance = new EnterFrameListener();
				return _instance;
			}
		}
		
		public function destroy():void
		{
			removeListeners();
			_enterFrameHandlers = null;
			_instance = null;
		}
		
		private function addListeners():void
		{
			var handler:Function;
			for (var i:int = 0; _enterFrameHandlers.length; i++)
			{
				handler = Function(_enterFrameHandlers[i]);
				_stageReference.addEventListener(Event.ENTER_FRAME, handler);
			}
		}
		
		private function removeListeners():void
		{
			var handler:Function;
			for (var i:int = 0; _enterFrameHandlers.length; i++)
			{
				handler = Function(_enterFrameHandlers[i]);
				_stageReference.removeEventListener(Event.ENTER_FRAME, handler);
				_enterFrameHandlers[i] = null;
			}
		}
	}
}
