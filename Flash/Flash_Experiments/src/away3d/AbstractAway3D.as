package away3d
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.paths.QuadraticPath;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;

	import base.display.AbstractSprite;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;


	public class AbstractAway3D extends AbstractSprite
	{
		private var _view:View3D;
		private var _cameraController:HoverController;
		private var _skyboxBitmaps:Vector.<Bitmap>;
		private var _loader:Loader3D;
		private var path:QuadraticPath;


		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var tiltSpeed:Number = 4;
		private var panSpeed:Number = 4;
		private var distanceSpeed:Number = 20;
		private var tiltIncrement:Number = 0;
		private var panIncrement:Number = 0;
		private var distanceIncrement:Number = 0;

		private var _lightPicker:StaticLightPicker;


		private var _cameraTarget:ObjectContainer3D;
		private var pointlight_0:PointLight;


		public function AbstractAway3D ()
		{
			super ();
		}


		override protected function initComplete ():void
		{
			super.initComplete ();
			initAway3D ();
		}

		private function initAway3D ():void
		{
			Parsers.enableAllBundled ();


			_view = new View3D ();
			addChild (_view);
			_view.antiAlias = 16;

			_view.camera.lens = new PerspectiveLens (50);
			_view.camera.lens.far = 100000;
			_view.camera.lens.near = 100;


			var data:Vector.<Vector3D> = new <Vector3D>[new Vector3D (20000, 600, 0), new Vector3D (8649, 12000, 2175), new Vector3D(-8000, 3000, 0)];
			path = new QuadraticPath (data);

			//path.addSegment (new QuadraticPathSegment (new Vector3D (20000, 600, 0), new Vector3D (15000, 630, 1000), new Vector3D (8649, 12000, 2175)));
			//trace("point on curve:", path.getPointOnCurve (0));



			_loader = new Loader3D ();
			_loader.addEventListener (LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			_loader.addEventListener (LoaderEvent.LOAD_ERROR, loadErrorHandler);
			_loader.load (new URLRequest ("awd/photonroom/photonroom.awd"), new AssetLoaderContext(true, "awd/photonroom"));


			_cameraTarget = new ObjectContainer3D ();
			_cameraTarget.y = 6000;
			_cameraTarget.x = 20000;
			_view.scene.addChild (_cameraTarget);


			pointlight_0 = new PointLight();
			pointlight_0.castsShadows = true;
			pointlight_0.shadowMapper.depthMapSize = 1024;
			pointlight_0.z = 2175.2;
			pointlight_0.x = 8649.39;
			pointlight_0.y = 11954.76;
			pointlight_0.fallOff = 20000;
			pointlight_0.radius = 6000;
			pointlight_0.zOffset = 0;
			pointlight_0.shaderPickingDetails = false;
			pointlight_0.ambient = 0.5;
			pointlight_0.color = 0xFFFFFF;
			//pointlight_0.ambientColor = 0xa0a0c0;
			pointlight_0.ambientColor = 0xFFFFFF;
			pointlight_0.specular = 1;
			pointlight_0.diffuse = 1;
			pointlight_0.name = "pointlight_0";
			_view.scene.addChild (pointlight_0);

			_lightPicker = new StaticLightPicker ([pointlight_0]);
			_cameraController = new HoverController (_view.camera, _cameraTarget, 90, 0, 1000, -90, 90, NaN, NaN, 8, 2, false);



			var cylinder_0:Mesh = new Mesh(new CylinderGeometry(1000,1000,8000));
			cylinder_0.z = -3144.1542448066334;
			cylinder_0.x = 0;
			cylinder_0.y = 4305.387426560852;
			cylinder_0.zOffset = 0;
			cylinder_0.shaderPickingDetails = false;
			cylinder_0.showBounds = false;
			cylinder_0.mouseChildren = true;
			cylinder_0.scaleZ = 1;
			cylinder_0.rotationX = 0;
			cylinder_0.rotationY = 0;
			cylinder_0.rotationZ = 0;
			cylinder_0.scaleX = 1;
			cylinder_0.scaleY = 1;
			cylinder_0.castsShadows = true;
			cylinder_0.mouseEnabled = true;
			cylinder_0.visible = true;
			cylinder_0.name = "cylinder_0";
			cylinder_0.material = new ColorMaterial (0xFF0000, 1);
			ColorMaterial (cylinder_0.material).lightPicker = _lightPicker;
			_view.scene.addChild (cylinder_0);


			pointlight_0.position = path.getPointOnCurve(0);


			_view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}


		private function resourceCompleteHandler (e:LoaderEvent):void
		{
			_loader.removeEventListener (LoaderEvent.LOAD_ERROR, loadErrorHandler);
			_loader.removeEventListener (LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);


			var child:ObjectContainer3D;
			var mesh:Mesh;
			var material:TextureMaterial;
			for (var i:int = 0; i < _loader.numChildren; i++)
			{
				child = _loader.getChildAt (i);
				mesh = child.getChildAt (0) as Mesh;
				mesh.castsShadows = false;
				material = mesh.material as TextureMaterial;
				material.shadowMethod = new HardShadowMapMethod(pointlight_0);
				material.lightPicker = _lightPicker;

				//trace ("mesh material:", mesh.name, material);
				//trace ("child:", child, child.name);
			}

			_view.scene.addChild (_loader);

			startAnimatingLightOnPath();
		}

		private function startAnimatingLightOnPath ():void
		{
			pathPosition = 0;
		}

		private function loadErrorHandler (e:LoaderEvent):void
		{
			trace ("LOAD ERROR:", e, e.message);
		}

		private function onAssetComplete (e:AssetEvent):void
		{
			trace ("asset complete:", e.asset);
		}

		private var pathPosition:Number = 1;
		private function enterFrameHandler (e:Event):void
		{
			if (pathPosition < 1)
			{
				pointlight_0.position = path.getPointOnCurve(pathPosition);
				pathPosition+=0.0025;
			}

			// Update camera
			if (move) {
				_cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				_cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			_cameraController.panAngle += panIncrement;
			_cameraController.tiltAngle += tiltIncrement;
			_cameraController.distance += distanceIncrement;

			_cameraController.update ();

			_view.render ();
		}


		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					tiltIncrement = tiltSpeed;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					tiltIncrement = -tiltSpeed;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					panIncrement = panSpeed;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					panIncrement = -panSpeed;
					break;
				case Keyboard.Z:
					distanceIncrement = distanceSpeed;
					break;
				case Keyboard.X:
					distanceIncrement = -distanceSpeed;
					break;
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					tiltIncrement = 0;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					panIncrement = 0;
					break;
				case Keyboard.Z:
				case Keyboard.X:
					distanceIncrement = 0;
					break;
			}
		}

		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			move = true;
			lastPanAngle = _cameraController.panAngle;
			lastTiltAngle = _cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}


		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
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
