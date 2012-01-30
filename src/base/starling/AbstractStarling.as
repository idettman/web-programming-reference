package base.starling
{
	import base.AbstractSprite;

	import starling.core.Starling;


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
