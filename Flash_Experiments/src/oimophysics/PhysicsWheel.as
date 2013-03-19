package oimophysics
{
	import base.display.AbstractSprite;

	import com.element.oimo.math.Vec3;
	import com.element.oimo.physics.collision.shape.BoxShape;
	import com.element.oimo.physics.collision.shape.Shape;
	import com.element.oimo.physics.collision.shape.ShapeConfig;
	import com.element.oimo.physics.collision.shape.SphereShape;
	import com.element.oimo.physics.constraint.joint.BallJoint;
	import com.element.oimo.physics.constraint.joint.HingeJoint;
	import com.element.oimo.physics.constraint.joint.JointConfig;
	import com.element.oimo.physics.dynamics.RigidBody;
	import com.element.oimo.physics.dynamics.World;
	import com.element.oimo.physics.util.DebugDraw;

	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class PhysicsWheel extends AbstractSprite
	{
		private var world:World;
		private var s3d:Stage3D;
		private var renderer:DebugDraw;


		override protected function init ():void
		{
			super.init ();

			world = new World ();
			if (!renderer) renderer = new DebugDraw (stage.stageWidth, stage.stageHeight);
			renderer.setWorld (world);

			const WHEEL_HEIGHT:Number = 0.199;

			var rb:RigidBody;
			var s:Shape;
			var c:ShapeConfig = new ShapeConfig ();

			rb = new RigidBody ();
			c.position.init (0, -0.5, 0);
			c.rotation.init ();
			s = new BoxShape (32, 1, 32, c);
			rb.addShape (s);
			rb.setupMass (RigidBody.BODY_STATIC);
			world.addRigidBody (rb);


			var pivotShapeConfig:ShapeConfig = new ShapeConfig ();
			pivotShapeConfig.density = 100000;
			pivotShapeConfig.position.init (0, WHEEL_HEIGHT, 0);

			var pivotRigidBody:RigidBody = new RigidBody ();

			var pivotShape:SphereShape = new SphereShape (0.1, pivotShapeConfig);
			pivotRigidBody.addShape (pivotShape);
			pivotRigidBody.setupMass ();
			world.addRigidBody (pivotRigidBody);


			var jointConfig:JointConfig = new JointConfig ();
			jointConfig.allowCollide = false;
			jointConfig.localAxis1 = new Vec3 (0, 1);
			jointConfig.localAxis2 = new Vec3 (0, 1);
			jointConfig.localRelativeAnchorPosition1 = new Vec3 (0, 0.5, 0);
			jointConfig.localRelativeAnchorPosition2 = new Vec3 (0, -WHEEL_HEIGHT, 0);

			var flipperHingeLeft:HingeJoint = new HingeJoint (rb, pivotRigidBody, jointConfig);

			/*flipperHingeLeft.enableMotor = true;
			 flipperHingeLeft.motorSpeed = 0.2;*/
			world.addJoint (flipperHingeLeft);


			var boxShapeConfig:ShapeConfig = new ShapeConfig ();

			var boxJoinConfig:JointConfig = new JointConfig ();
			boxJoinConfig.allowCollide = false;
			boxJoinConfig.localAxis1 = new Vec3 (0, 1);
			boxJoinConfig.localAxis2 = new Vec3 (0, 1);

			boxShapeConfig.density = 0.1;
			boxShapeConfig.position.init (3, WHEEL_HEIGHT, 0);
			boxJoinConfig.localRelativeAnchorPosition1.init (3, 0, 0);
			createPivotingRigidBox (boxShapeConfig, boxJoinConfig, pivotRigidBody);

			boxShapeConfig.position.init (0, WHEEL_HEIGHT, 3);
			boxJoinConfig.localRelativeAnchorPosition1.init (0, 0, 3);
			createPivotingRigidBox (boxShapeConfig, boxJoinConfig, pivotRigidBody);

			boxShapeConfig.position.init (-3, WHEEL_HEIGHT, 0);
			boxJoinConfig.localRelativeAnchorPosition1.init (-3, 0, 0);
			createPivotingRigidBox (boxShapeConfig, boxJoinConfig, pivotRigidBody);

			boxShapeConfig.position.init (0, WHEEL_HEIGHT, -3);
			boxJoinConfig.localRelativeAnchorPosition1.init (0, 0, -3);
			_pivotingRigidBox = createPivotingRigidBox (boxShapeConfig, boxJoinConfig, pivotRigidBody);


			s3d = stage.stage3Ds[0];
			s3d.addEventListener (Event.CONTEXT3D_CREATE, onContext3DCreated);
			s3d.requestContext3D ();
		}

		private var _pivotingRigidBox:RigidBody;


		private function createPivotingRigidBox (boxShapeConfig:ShapeConfig, boxJoinConfig:JointConfig, pivotRigidBody:RigidBody):RigidBody
		{
			var box2RigidBody:RigidBody = new RigidBody ();
			var box2Shape:BoxShape = new BoxShape (0.5, 0.5, 0.5, boxShapeConfig);

			box2RigidBody.addShape (box2Shape);
			box2RigidBody.setupMass ();

			world.addRigidBody (box2RigidBody);
			world.addJoint (new BallJoint (pivotRigidBody, box2RigidBody, boxJoinConfig));


			return box2RigidBody;
		}


		private function onContext3DCreated (e:Event = null):void
		{
			renderer.setContext3D (s3d.context3D);
			renderer.camera (0, 8, -3);

			addEventListener (Event.ENTER_FRAME, frame);
			stage.addEventListener (MouseEvent.CLICK, spinWheel);
		}

		private function spinWheel (event:MouseEvent):void
		{
			_pivotingRigidBox.applyImpulse (_pivotingRigidBox.position, new Vec3 (2 + Math.random () * 10, 0, 0));
		}

		private function frame (e:Event = null):void
		{

			world.step ();

			renderer.render ();
		}
	}
}
