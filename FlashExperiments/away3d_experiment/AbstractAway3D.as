package
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;

	import base.display.AbstractSprite;

	import flash.display.Bitmap;
	import flash.events.Event;


	public class AbstractAway3D extends AbstractSprite
	{
		private var _view:View3D;
		private var _plane:Mesh;
		private var _skyboxBitmaps:Vector.<Bitmap>;


		public function AbstractAway3D ()
		{
			super ();
		}


		override protected function initComplete ():void
		{
			super.initComplete ();

			initAway3D ();



			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}

		private function initAway3D ():void
		{
			_view = new View3D ();
			addChild (_view);

			_plane = new Mesh (new PlaneGeometry (700, 700), new ColorMaterial (0xFF0000));
			_plane.z = 700;
			_view.scene.addChild (_plane);

			_view.camera.z = -600;
			_view.camera.y = 500;
			_view.camera.lens = new PerspectiveLens (90);
			_view.camera.lookAt (_plane.position);

		}

		private function onAssetComplete (e:AssetEvent):void
		{
			trace ("asset complete:", e.asset);
		}

		private function enterFrameHandler (e:Event):void
		{
			_plane.rotationY += 1;
			_view.render ();
		}

		private var _skyBox:SkyBox;
		public function set skyboxBitmaps (skyboxBitmaps:Vector.<Bitmap>):void {
			_skyboxBitmaps = skyboxBitmaps;

			var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture (_skyboxBitmaps[0].bitmapData, _skyboxBitmaps[1].bitmapData, _skyboxBitmaps[2].bitmapData, _skyboxBitmaps[3].bitmapData, _skyboxBitmaps[4].bitmapData, _skyboxBitmaps[5].bitmapData);

			_skyBox = new SkyBox (cubeTexture);
			_view.scene.addChild (_skyBox);
		}
	}
}
