package
{

	import base.display.AbstractSprite;


	[SWF(width="1024",height="769",frameRate="60")]
	public class FlashExperiments extends AbstractSprite
	{
		public function FlashExperiments ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			//addChild (new AbstractAway3D ());
			//addChild (new OimoPhysicsAway3dIntegrationTest());
			//addChild (new PinballTest ());
			addChild (new PinballFieldBlocking ());
			//addChild (new JointTest ());
		}
	}
}
