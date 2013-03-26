package oimophysics
{
	import base.display.AbstractSprite;

	import com.element.oimo.physics.collision.shape.BoxShape;
	import com.element.oimo.physics.collision.shape.ShapeConfig;
	import com.element.oimo.physics.collision.shape.SphereShape;
	import com.element.oimo.physics.dynamics.RigidBody;
	import com.element.oimo.physics.dynamics.World;
	import com.element.oimo.physics.util.DebugDraw;

	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	public class PinballFieldBlocking extends AbstractSprite
	{
		private var s3d:Stage3D;
		private var renderer:DebugDraw;
		private var l:Boolean;
		private var r:Boolean;
		private var u:Boolean;
		private var d:Boolean;

		public var world:World;
		private var ctr:RigidBody;


		public function PinballFieldBlocking ()
		{
			super();
		}



		override protected function init ():void
		{
			super.init ();
			world = new World ();

			if (!renderer) renderer = new DebugDraw(640, 480);
			renderer.setWorld(world);


			var shapeConfig:ShapeConfig = new ShapeConfig ();
			shapeConfig.position.init ();
			shapeConfig.rotation.init ();


			var groundBody:RigidBody = new RigidBody ();


			var groundShape:BoxShape = new BoxShape (32, 1, 64, shapeConfig);
			groundBody.addShape (groundShape);

			shapeConfig.position.x = 15;
			var wallShape:BoxShape = new BoxShape (2, 6, 64, shapeConfig);
			groundBody.addShape (wallShape);

			shapeConfig.position.x = -15;
			wallShape = new BoxShape (2, 6, 64, shapeConfig);
			groundBody.addShape (wallShape);


			groundBody.setupMass (RigidBody.BODY_STATIC);
			world.addRigidBody (groundBody);


			var ballConfig:ShapeConfig = new ShapeConfig ();
			ballConfig.friction = 2;
			ballConfig.position.init(0, 1, 8);
			ballConfig.density = 10;
			ballConfig.rotation.init();
			ctr = new RigidBody ();
			ctr.addShape (new SphereShape (1, ballConfig));
			ctr.setupMass(RigidBody.BODY_DYNAMIC);
			world.addRigidBody(ctr);


			s3d = stage.stage3Ds[0];
			s3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			s3d.requestContext3D();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				var code:uint = e.keyCode;
				if (code == Keyboard.W) {
					u = true;
				}
				if (code == Keyboard.S) {
					d = true;
				}
				if (code == Keyboard.A) {
					l = true;
				}
				if (code == Keyboard.D) {
					r = true;
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				var code:uint = e.keyCode;
				if (code == Keyboard.W) {
					u = false;
				}
				if (code == Keyboard.S) {
					d = false;
				}
				if (code == Keyboard.A) {
					l = false;
				}
				if (code == Keyboard.D) {
					r = false;
				}
			});
		}


		override protected function destroy ():void
		{
			super.destroy ();

		}


		override protected function addListeners ():void
		{
			super.addListeners ();

		}

		override protected function removeListeners ():void
		{
			super.removeListeners ();

		}


		private function onContext3DCreated(e:Event = null):void {
			renderer.setContext3D(s3d.context3D);
			renderer.camera(0, 4, -4);

			addEventListener (Event.ENTER_FRAME, frame);
		}


		private function frame(e:Event):void
		{
			var ang:Number = (320 - mouseX) * 0.01 + Math.PI * 0.5;
			renderer.camera(
					ctr.position.x + Math.cos(ang) * 8,
					ctr.position.y + (240 - mouseY) * 0.1,
					ctr.position.z + Math.sin(ang) * 8,
					ctr.position.x, ctr.position.y, ctr.position.z
			);

			if (l) {
				ctr.linearVelocity.x -= Math.cos(ang - Math.PI * 0.5) * 0.8;
				ctr.linearVelocity.z -= Math.sin(ang - Math.PI * 0.5) * 0.8;
			}
			if (r) {
				ctr.linearVelocity.x -= Math.cos(ang + Math.PI * 0.5) * 0.8;
				ctr.linearVelocity.z -= Math.sin(ang + Math.PI * 0.5) * 0.8;
			}
			if (u) {
				ctr.linearVelocity.x -= Math.cos(ang) * 0.8;
				ctr.linearVelocity.z -= Math.sin(ang) * 0.8;
			}
			if (d) {
				ctr.linearVelocity.x += Math.cos(ang) * 0.8;
				ctr.linearVelocity.z += Math.sin(ang) * 0.8;
			}

			world.step ();
			renderer.render ();
		}

	}
}
