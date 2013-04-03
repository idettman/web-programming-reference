package
{

	import base.display.AbstractSprite;

	import flash.display.Shape;

	import flash.events.Event;

	import planetaryorbitengine.TestOrbitSimulation;


	[SWF(width="1024", height="760", frameRate="60")]
	public class Flash_Experiments extends AbstractSprite
	{
		[Embed(source="./../assets/fonts/RobotoCondensed-Regular.ttf", embedAsCFF="false", fontFamily="RobotoCondensed Regular", fontWeight="regular", mimeType="application/x-font-truetype")]
		public static var Font_RobotoCondensed_Regular:Class;
		

		public var canvas:Shape;

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
			//addChild (new PhysicsWheel ());

			//testOrbitSimulation ();
			testIsaacOrbitSimulation ();
		}

		private var orbit:Simulation;
		private function testIsaacOrbitSimulation ():void
		{
			canvas = new Shape();
			addChild(canvas);
			/*canvas.x = 800;
			canvas.y = 800;*/
			canvas.x = 300;
			canvas.y = 200;
			canvas.graphics.beginFill (0xFF0000);


			orbit = new Simulation ();
			orbit.initSimulation ();


			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}


		private function enterFrameHandler (e:Event):void
		{
			orbit.update ();

			/*canvas.graphics.clear ();
			canvas.graphics.beginFill (0xFF0000);*/

			canvas.graphics.clear ();

			const SCALE_MULTIPLIER:Number = 4;

			for each (var obj:OrbitalBody in orbit.bodies)
			{
				//trace ("orbit:", obj.position.x, obj.position.y, obj.position.z);

				if (obj.lastPosition)
				{
					canvas.graphics.lineStyle (1);
					canvas.graphics.moveTo (obj.lastPosition.x * SCALE_MULTIPLIER, obj.lastPosition.y * SCALE_MULTIPLIER);
					canvas.graphics.lineTo (obj.position.x * SCALE_MULTIPLIER, obj.position.y * SCALE_MULTIPLIER);
					canvas.graphics.lineStyle (0);

					canvas.graphics.beginFill (0xFF0000);
					canvas.graphics.drawCircle (obj.position.x*SCALE_MULTIPLIER, obj.position.y*SCALE_MULTIPLIER, obj.radius*(SCALE_MULTIPLIER*0.00002));
					//canvas.graphics.drawCircle (obj.position.x*SCALE_MULTIPLIER, obj.position.y*SCALE_MULTIPLIER, obj.radius*(SCALE_MULTIPLIER*0.00001));
					//canvas.graphics.drawCircle (obj.position.x*SCALE_MULTIPLIER, obj.position.y*SCALE_MULTIPLIER, 2);
					canvas.graphics.endFill ();
				}

				obj.lastPosition = obj.position;
			}
		}


		private function testOrbitSimulation ():void
		{
			var orbit:TestOrbitSimulation = addChild (new TestOrbitSimulation ()) as TestOrbitSimulation;
			orbit.init ();
		}
	}
}
