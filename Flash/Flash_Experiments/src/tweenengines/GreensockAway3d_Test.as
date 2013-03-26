/**
 * Created with IntelliJ IDEA.
 * User: Faygo
 * Date: 3/18/13
 * Time: 2:02 PM
 * To change this template use File | Settings | File Templates.
 */
package tweenengines
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;

	import base.display.AbstractSprite;

	import com.greensock.TweenMax;
	import com.greensock.core.Animation;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.events.Event;
	import flash.geom.Vector3D;


	public class GreensockAway3d_Test extends AbstractSprite
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
			_camera.x = 0;
			_camera.z = -400;

			_cameraTarget = _cube.position.clone();
			_camera.lookAt (_cameraTarget);



			TweenPlugin.activate([BezierPlugin]);
			TweenMax.to (_cube, 4, {
				bezier:[
					{x: 50, y: 300, z: -150},
					{x: 100, y: 100, z: 600},
					{x: 0, y: 0, z: 400},
					{x: 50, y: 300, z: -150},
					{x: 0, y: 0, z: 400}
				],
				ease: Cubic.easeInOut

			}).delay(1);

			// Handle TweenMax update in main game loop, saves having a second enterframe listener
			Animation.ticker.removeEventListener ("enterFrame", Animation._updateRoot);


			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}


		private function enterFrameHandler (e:Event):void
		{
			// Update tweenmax
			Animation._updateRoot ();

			_camera.lookAt (_cameraTarget);
			_view.render ();
		}
	}
}
