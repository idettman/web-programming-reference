package base.display.away3d
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.primitives.PlaneGeometry;

	import flash.display.Sprite;
	import flash.events.Event;


	public class AbstractAway3dScene extends Sprite
	{
		public var view:View3D;
		public var scene:Scene3D;
		public var camera:Camera3D;
		public var ground:PlaneGeometry;
		public var groundMesh:Mesh;

		
		public function AbstractAway3dScene()
		{
			super();
			initAway3d();
			initWorldGeometry();
			initCameraPosition();
		}


		private function initAway3d():void
		{
			scene = new Scene3D();
			camera = new Camera3D();
			
			view = new View3D(scene, camera);
			addChild(view);
		}
		
		private function initCameraPosition():void
		{
			
		}
		
		private function initWorldGeometry():void
		{
			ground = new PlaneGeometry(100, 100, 1, 1, true);
			groundMesh = new Mesh(ground);
			scene.addChild(groundMesh);
			
			groundMesh.lookAt(camera.position);
			groundMesh.moveBackward(1000);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}


		private function onEnterFrame(e:Event):void
		{
			view.render();
		}
		
		
		
	}
}
