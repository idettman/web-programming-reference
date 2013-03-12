package
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;

	import base.display.AbstractSprite;

	import com.element.oimo.math.Mat44;
	import com.element.oimo.math.Vec3;
	import com.element.oimo.physics.collision.shape.BoxShape;
	import com.element.oimo.physics.collision.shape.Shape;
	import com.element.oimo.physics.collision.shape.ShapeConfig;
	import com.element.oimo.physics.collision.shape.SphereShape;
	import com.element.oimo.physics.constraint.joint.HingeJoint;
	import com.element.oimo.physics.constraint.joint.JointConfig;
	import com.element.oimo.physics.dynamics.RigidBody;
	import com.element.oimo.physics.dynamics.World;

	import flash.events.Event;


	public class PinballTest extends AbstractSprite
	{

		/**
		 * The amount to multiply with when converting radians to degrees.
		 */
		public static const RADIANS_TO_DEGREES : Number = 180 / Math.PI;

		/**
		 * The amount to multiply with when converting degrees to radians.
		 */
		public static const DEGREES_TO_RADIANS : Number = Math.PI / 180;




		public var world:World;
		public var ballRigidBody:RigidBody;

		private var _view:View3D;
		private var _light:PointLight;
		private var _lightPicker:StaticLightPicker;
		public var ballMesh:Mesh;




		public function PinballTest ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			initOimoPhysicsEngine ();
			initAway3d();
		}



		public var flipperLeft:RigidBody;
		private function initOimoPhysicsEngine ():void
		{
			world = new World ();


			var rb:RigidBody = new RigidBody (-12*DEGREES_TO_RADIANS, 1);
			rb.id = "groundBody";


			var groundConfig:ShapeConfig = new ShapeConfig ();
			groundConfig.position.init (0, 0, 0);
			groundConfig.rotation.init ();
			groundConfig.restitution = 0.75;
			groundConfig.friction = 1;

			/*var rotationAngle:Number = 7;
			groundConfig.rotation.init (
					1, 0, 0,
					0, Math.cos (rotationAngle), -Math.sin (rotationAngle),
					0, Math.sin (rotationAngle), Math.cos (rotationAngle)
			);*/

			var ground:BoxShape = new BoxShape (32, 1, 32, groundConfig);
			rb.addShape (ground);

			groundConfig.position.init (0, 2.5, -15.5);
			var boundaryTop:BoxShape = new BoxShape (32, 4, 1, groundConfig);
			rb.addShape (boundaryTop);

			groundConfig.position.init (0, 2.5, 15.5);
			var boundaryBottom:BoxShape = new BoxShape (32, 4, 1, groundConfig);
			rb.addShape (boundaryBottom);

			groundConfig.position.init (-15.5, 2.5, 0);
			var boundaryLeft:BoxShape = new BoxShape (1, 4, 31, groundConfig);
			rb.addShape (boundaryLeft);

			groundConfig.position.init (15.5, 2.5, 0);
			var boundaryRight:BoxShape = new BoxShape (1, 4, 31, groundConfig);
			rb.addShape (boundaryRight);

			rb.setupMass (RigidBody.BODY_STATIC);
			world.addRigidBody (rb);



			flipperLeft = new RigidBody (-12*DEGREES_TO_RADIANS, 1);
			flipperLeft.id = "flipperLeftShape";

			var flipperShapeConfig:ShapeConfig = new ShapeConfig ();
			flipperShapeConfig.density = 10;
			flipperShapeConfig.friction = 2;

			var flipperShape:BoxShape = new BoxShape (4, 2, 1, flipperShapeConfig);
			flipperLeft.addShape (flipperShape);
			flipperLeft.setupMass ();
			flipperLeft.position.x = 5;
			flipperLeft.position.z = -4;
			flipperLeft.position.y = 0.7;
			world.addRigidBody (flipperLeft);
			flipperLeft.collisionCallback = flipperCollisionHandler;

			var jointConfig:JointConfig = new JointConfig ();
			jointConfig.allowCollide = false;
			jointConfig.localAxis1 = new Vec3 (0, 1);
			jointConfig.localAxis2 = new Vec3 (0, 1);
			jointConfig.localRelativeAnchorPosition2 = new Vec3 (5, 0.5, -4);
			jointConfig.localRelativeAnchorPosition1 = new Vec3 (2, -0.5, 0);

			var flipperHingeLeft:HingeJoint = new HingeJoint (flipperLeft, rb, jointConfig);
			flipperHingeLeft.enableMotor = true;
			flipperHingeLeft.motorSpeed = 10;
			world.addJoint (flipperHingeLeft);


			var ballShapeConfig:ShapeConfig = new ShapeConfig ();
			//c.position.init (0, 0.5, 0);
			ballShapeConfig.position.init (0, 0, 0);
			ballShapeConfig.rotation.init ();
			ballShapeConfig.friction = 0.1;
			ballShapeConfig.density = 10;
			ballShapeConfig.restitution = 0.6;


			ballRigidBody = new RigidBody ();
			ballRigidBody.id = "ballBody";
			ballRigidBody.addShape (new SphereShape (1, ballShapeConfig));
			ballRigidBody.setupMass ();
			//ballRigidBody.collisionCallback = ballCollisionHandler;
			//ballRigidBody.angularVelocity.x = 110;
			ballRigidBody.position.z = 5;
			ballRigidBody.position.x = 3;
			ballRigidBody.position.y = 40;
			ballRigidBody.linearVelocity = new Vec3 (0, 0, 0);
			world.addRigidBody (ballRigidBody);
		}

		private function flipperCollisionHandler (child:Shape, collider:Shape):void
		{
			trace ("flipper collision:", collider.parent.id);
		}

		/*private function ballCollisionHandler ():void
		{
			trace ("ball collision");
		}*/


		private function initAway3d ():void
		{
			_view = new View3D ();
			addChild (_view);
			_view.antiAlias = 4;
			_view.camera.y = 80;
			_view.camera.z = -40;
			_view.camera.lens = new PerspectiveLens (40);
			_view.camera.lens.far = 160;
			_view.camera.lens.near = 0.5;


			_light = new PointLight ();
			_light.castsShadows = true;
			_light.shadowMapper.depthMapSize = 1024;
			_light.y = 30;
			_light.z = 6;
			_light.x = 1;
			_light.fallOff = 100;
			_light.radius = 1;
			_view.scene.addChild (_light);

			_lightPicker = new StaticLightPicker ([_light]);





			var groundMesh:Mesh = new Mesh (new CubeGeometry (32, 1, 32));
			groundMesh.castsShadows = false;
			groundMesh.material = new ColorMaterial (0x00FF00);
			groundMesh.rotationX = -12;
			ColorMaterial (groundMesh.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (groundMesh.material).lightPicker = _lightPicker;


			var borderMeshTop:Mesh = new Mesh (new CubeGeometry (32, 4, 1));
			borderMeshTop.y = 2.5;
			borderMeshTop.z = -15.5;
			borderMeshTop.castsShadows = false;
			borderMeshTop.material = new ColorMaterial (0x0000FF);
			ColorMaterial (borderMeshTop.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (borderMeshTop.material).lightPicker = _lightPicker;
			groundMesh.addChild (borderMeshTop);


			var borderMeshBottom:Mesh = new Mesh (new CubeGeometry (32, 4, 1));
			borderMeshBottom.y = 2.5;
			borderMeshBottom.z = 15.5;
			borderMeshBottom.castsShadows = false;
			borderMeshBottom.material = new ColorMaterial (0x0000FF);
			ColorMaterial (borderMeshBottom.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (borderMeshBottom.material).lightPicker = _lightPicker;
			groundMesh.addChild (borderMeshBottom);



			var borderMeshLeft:Mesh = new Mesh (new CubeGeometry (1, 4, 31));
			borderMeshLeft.y = 2.5;
			borderMeshLeft.x = -15.5;
			borderMeshLeft.castsShadows = false;
			borderMeshLeft.material = new ColorMaterial (0x0000FF);
			ColorMaterial (borderMeshLeft.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (borderMeshLeft.material).lightPicker = _lightPicker;
			groundMesh.addChild (borderMeshLeft);


			var borderMeshRight:Mesh = new Mesh (new CubeGeometry (1, 4, 31));
			borderMeshRight.y = 2.5;
			borderMeshRight.x = 15.5;
			borderMeshRight.castsShadows = false;
			borderMeshRight.material = new ColorMaterial (0x0000FF);
			ColorMaterial (borderMeshRight.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (borderMeshRight.material).lightPicker = _lightPicker;
			groundMesh.addChild (borderMeshRight);



			_view.scene.addChild (groundMesh);







			flipperMeshLeft = new Mesh (new CubeGeometry (4, 2, 1));
			flipperMeshLeft.y = 1;
			flipperMeshLeft.z = -4;
			flipperMeshLeft.x = 4;
			flipperMeshLeft.castsShadows = true;
			flipperMeshLeft.material = new ColorMaterial (0x666666);
			ColorMaterial (flipperMeshLeft.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (flipperMeshLeft.material).lightPicker = _lightPicker;
			_view.scene.addChild (flipperMeshLeft);





			ballMesh = new Mesh (new SphereGeometry (1,30,30));
			ballMesh.castsShadows = true;
			ballMesh.material = new ColorMaterial (0xFF0000);
			ColorMaterial (ballMesh.material).lightPicker = _lightPicker;
			_view.scene.addChild (ballMesh);
			_view.camera.lookAt (ballMesh.position);


			addEventListener (Event.ENTER_FRAME, frame);
		}

		public var flipperMeshLeft:Mesh;

		public var mat44:Mat44 = new Mat44 ();

		private function frame (e:Event):void
		{
			world.step();

			ballMesh.transform.rawData = ballRigidBody.matrix3d.getMatrix3dRawData ();
			ballMesh.transform = ballMesh.transform;

			flipperMeshLeft.transform.rawData = flipperLeft.matrix3d.getMatrix3dRawData ();
			flipperMeshLeft.transform = flipperMeshLeft.transform;

			_view.render ();
		}



	}
}
