package performance.display.starling
{

	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;


	public class AbstractStarlingSprite extends Sprite
	{
		private var q:Quad;
		
		public function AbstractStarlingSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}


		/**
		 * Getters/Setters
		 */
		public function get isRunningInHardware():Boolean
		{
//			trace(Starling.context.driverInfo.toLowerCase().indexOf("software") == -1);
			return true;
		}
		
		
		/**
		 * Public Methods
		 */
		
		
		/**
		 * Private Methods
		 */
		private function init():void
		{
			q = new Quad(200, 200);
			q.setVertexColor(0, 0x000000);
			q.setVertexColor(1, 0xFF0000);
			q.setVertexColor(2, 0x00FF00);
			q.setVertexColor(3, 0x0000FF);
			addChild(q);
			
			q.x = stage.stageWidth - q.width >> 1;
			q.y = stage.stageHeight - q.height >> 1;
		}
		
		
		/**
		 * 
		 * Event Handlers
		 */
		private function addedToStageHandler(e:Event):void
		{
			init();
//			trace(Starling.context.driverInfo);

			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}


		private function enterFrameHandler(e:Event):void
		{
			q.rotation += 0.01;
		}

		
		
	}
}
