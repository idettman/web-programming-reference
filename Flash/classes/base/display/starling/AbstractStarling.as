package base.display.starling
{
	import base.display.AbstractSprite;


	public class AbstractStarling extends AbstractSprite
	{
		private var starling:Starling;


		/**
		 * Getters/Setters
		 */
		

		/**
		 * Private/Protected
		 */
		override protected function initLayout():void
		{
			trace("init layout");
			
			super.initLayout();
			
			starling = new Starling(AbstractStarlingSprite, stage);
			starling.antiAliasing = 1;
			starling.start();
		}
		
		
		override protected function destroyLayout():void
		{
			if (starling)
			{
				starling.dispose();
				starling = null;
			}
		}
	}
}
