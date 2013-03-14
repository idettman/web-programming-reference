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
	import com.element.oimo.physics.collision.shape.BoxShape;
	import com.element.oimo.physics.collision.shape.ShapeConfig;
	import com.element.oimo.physics.collision.shape.SphereShape;
	import com.element.oimo.physics.dynamics.RigidBody;
	import com.element.oimo.physics.dynamics.World;
	import com.element.oimo.physics.util.DebugDraw;

	import flash.events.Event;
	import flash.geom.Matrix3D;


	public class OimoPhysicsAway3dIntegrationTest extends AbstractSprite
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
		public var renderer:DebugDraw;
		public var ballRigidBody:RigidBody;
		/*
		public var s3d:Stage3D;*/


		private var _view:View3D;
		private var _light:PointLight;
		private var _lightPicker:StaticLightPicker;
		public var ballMesh:Mesh;




		public function OimoPhysicsAway3dIntegrationTest ()
		{
			super ();
		}


		override protected function init ():void
		{
			super.init ();

			initOimoPhysicsEngine ();
			initAway3d();
		}




		private function initOimoPhysicsEngine ():void
		{
			world = new World ();

			/*renderer = new DebugDraw (640, 480);
			renderer.setWorld (world);*/


			var rb:RigidBody;
			rb = new RigidBody (7*DEGREES_TO_RADIANS, 1);
			var groundConfig:ShapeConfig = new ShapeConfig ();
			groundConfig.position.init (0, 0, 0);
			groundConfig.rotation.init ();

			/*var rotationAngle:Number = 7;
			groundConfig.rotation.init (
					1, 0, 0,
					0, Math.cos (rotationAngle), -Math.sin (rotationAngle),
					0, Math.sin (rotationAngle), Math.cos (rotationAngle)
			);*/

			var ground:BoxShape = new BoxShape (32, 1, 32, groundConfig);
			rb.addShape (ground);
			rb.setupMass (RigidBody.BODY_STATIC);
			world.addRigidBody (rb);




			var c:ShapeConfig = new ShapeConfig ();
			//c.position.init (0, 0.5, 0);
			c.position.init (0, 0, 0);
			c.rotation.init ();
			c.friction = 2;
			c.density = 10;
			c.restitution = 1;


			var s:SphereShape;
			s = new SphereShape (1, c);

			ballRigidBody = new RigidBody ();
			ballRigidBody.addShape (s);
			ballRigidBody.setupMass (RigidBody.BODY_DYNAMIC);
			ballRigidBody.angularVelocity.x = -10;
			//ballRigidBody.angularVelocity.z = -100;
			ballRigidBody.position.y = 14;
			world.addRigidBody (ballRigidBody);
		}

		private function initAway3d ():void
		{
			_view = new View3D ();
			addChild (_view);
			_view.antiAlias = 4;
			_view.camera.y = 16;
			_view.camera.z = -20;
			_view.camera.lens = new PerspectiveLens (50);
			_view.camera.lens.far = 1000;
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
			groundMesh.rotationX = 7;
			ColorMaterial (groundMesh.material).shadowMethod = new HardShadowMapMethod(_light);
			ColorMaterial (groundMesh.material).lightPicker = _lightPicker;
			_view.scene.addChild (groundMesh);


			ballMesh = new Mesh (new SphereGeometry (1,30,20));
			ballMesh.castsShadows = true;
			ballMesh.material = new ColorMaterial (0xFF0000);
			ColorMaterial (ballMesh.material).lightPicker = _lightPicker;
			_view.scene.addChild (ballMesh);
			_view.camera.lookAt (ballMesh.position);

			//renderer.camera(0, 6, 10, 0, 0.5, 0);


			addEventListener (Event.ENTER_FRAME, frame);
		}


		public var mat44:Mat44 = new Mat44 ();
		public var matrix3d:Matrix3D = new Matrix3D ();

		private function frame (e:Event):void
		{
			world.step();

			mat44.copyMat33 (ballRigidBody.rotation);
			mat44.e03 = ballRigidBody.position.x;
			mat44.e13 = ballRigidBody.position.y;
			mat44.e23 = ballRigidBody.position.z;

			/*matrix3d.rawData = mat44.getMatrix3dRawData ();
			ballMesh.transform = matrix3d;*/
			//ballMesh.transform = mat44.getMatrix3d ();

			//ballMesh.transform.copyRawDataFrom (mat44.getMatrix3dRawData ());
			ballMesh.transform.rawData = mat44.getMatrix3dRawData ();
			ballMesh.transform = ballMesh.transform;

			_view.render ();
		}



	}
}
