package
{

	import base.display.AbstractSprite;

	import com.element.oimo.physics.test.JointTest;

	import tweenengines.TestGreenSock;


	[SWF(width="1024", height="760", frameRate="60")]
	public class Flash_Experiments extends AbstractSprite
	{
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
			
			addChild(new TestGreenSock());
		}
	}
}
