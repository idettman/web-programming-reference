package
{

	import away3dlite.cameras.Camera3D;
	import away3dlite.cameras.lenses.PerspectiveLens;
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.primitives.Sphere;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;


	public class Away3dLite_Experiment extends Sprite
	{
		private var _view:View3D;
		private var _scene:Scene3D;
		private var _camera:Camera3D;


		public function Away3dLite_Experiment ()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;


			_camera = new Camera3D (10, 100, new PerspectiveLens ());
			_camera.z = -600;

			_view = new View3D (null, _camera);
			addChild (_view);

			var sphere:Sphere = new Sphere (new ColorMaterial (0xFF0000), 200);
			_view.scene.addChild (sphere);

			_view.render ();
		}
	}
}
