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

			/*var away3d:AbstractAway3D = new AbstractAway3D ();
			addChild (away3d);*/

			/*var oimoPhysicsAway3d:OimoPhysicsAway3dIntegrationTest = new OimoPhysicsAway3dIntegrationTest ();
			addChild (oimoPhysicsAway3d);*/


			addChild (new PinballTest ());
			//addChild (new JointTest ());
		}
	}
}
