package
{

	import base.display.AbstractSprite;

	import lunchwheel.LunchWheelAltLabelRotation;

	import oimophysics.OimoPhysicsAway3dIntegrationTest;

	import oimophysics.PhysicsWheel;


	[SWF(width="1024", height="760", frameRate="60")]
	public class Flash_Experiments extends AbstractSprite
	{
		[Embed(source="./../assets/fonts/RobotoCondensed-Regular.ttf", embedAsCFF="false", fontFamily="RobotoCondensed Regular", fontWeight="regular", mimeType="application/x-font-truetype")]
		public static var Font_RobotoCondensed_Regular:Class;
		

		public function Flash_Experiments ()
		{
			super ();
		}
		

		override protected function init ():void
		{
			super.init ();

			//addChild (new AbstractAway3D ());
			//addChild (new OimoPhysicsAway3dIntegrationTest());
			//addChild (new PinballTest ());
			//addChild (new PinballFieldBlocking ());
			//addChild (new JointTest ());
			//addChild (new FlareTest ());
			//addChild (new Tween24_Test ());
			//addChild(new GreenSock_Test());
			//addChild(new GreensockAway3d_Test());
			//addChild (new Tween24_Away3d_Test ());
			//addChild(new DrawArcsAndPolys_Test());
			//addChild (new CreateWheelGeometry_Test ());
			//addChild (new CreatePolygonWithRectangles_Test ());
			//addChild (new LunchWheel_Test ());
			//addChild (new LunchWheelAltLabelRotation ());
			//addChild (new PhysicsWheel ());

		}
	}
}
