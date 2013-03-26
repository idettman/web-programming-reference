package tweenengines
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	import base.display.AbstractSprite;

	import flash.events.Event;
	import flash.geom.Vector3D;


	public class Tween24_Away3d_Test extends AbstractSprite
	{
		private var _view:View3D;
		private var _camera:Camera3D;
		private var _cameraTarget:Vector3D;

		private var _cube:Mesh;


		override protected function init ():void
		{
			super.init ();

			_view = addChild (new View3D()) as View3D;
			_view.antiAlias = 4;

			_cube = new Mesh (new CubeGeometry (), new ColorMaterial(0xFF0000));
			_cube.z = 400;
			_view.scene.addChild (_cube);

			_camera = _view.camera;
			_camera.y = 300;
			_camera.x = -300;
			_camera.z = -400;

			_cameraTarget = _cube.position.clone();
			_camera.lookAt (_cameraTarget);

			addEventListener (Event.ENTER_FRAME, enterFrameHandler);


			// Works with Away3d
			//Tween24.tween (_cameraTarget, 2, Ease24._3_CubicInOut, {x: 400, y:400, z:2400}).delay(4).play();
			//Tween24.tween (_cube, 4, null, {x: 400}).play();
			//Tween24.tween (_cube, 4, null, {rotationY:360}).play();
			//Tween24.tween (_cube, 4, Ease24._3_CubicInOut).x (0).y (400).bezier (800, 200).play ();

			// Bezier doesn't work properly with a "z" property
			//Tween24.tween (_cube, 4, Ease24._4_QuartInOut).x (0).y (400).z (2400).bezier (800, 200).play ();
			//Tween24.tween (_cube, 4, Ease24._4_QuartInOut, {x: 0, y: 400, z:2400}).bezier (800, 200).play ();


			// Doesn't work with Away3d (issue is that Mesh does not extend DisplayObject, it extends EventDispatcher
			//Tween24.tweenVelocity (_cube, 200, null, {rotationY: 360}).play();

		}


		private function enterFrameHandler (e:Event):void
		{
			_camera.lookAt (_cameraTarget);
			_view.render ();
		}

	}
}
