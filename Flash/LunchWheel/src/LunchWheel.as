package
{

	import base.display.AbstractSprite;

	import lunchwheel.*;


	[SWF(width="1024", height="760", frameRate="60")]
	public class LunchWheel extends AbstractSprite
	{
		[Embed(source="./../assets/fonts/RobotoCondensed-Regular.ttf", embedAsCFF="false", fontFamily="RobotoCondensed Regular", fontWeight="regular", mimeType="application/x-font-truetype")]
		public static var Font_RobotoCondensed_Regular:Class;


		public function LunchWheel ()
		{
			//addChild(new DrawArcsAndPolys_Test());
			//addChild (new CreateWheelGeometry_Test ());
			//addChild (new CreatePolygonWithRectangles_Test ());
			//addChild (new LunchWheel_Test ());
			addChild (new LunchWheelAltLabelRotation ());
		}
	}
}
