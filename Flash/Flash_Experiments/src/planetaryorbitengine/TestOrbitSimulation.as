package planetaryorbitengine {
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.LineSegment;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.data.Segment;

	import com.iad.orbitsim.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;


	public class TestOrbitSimulation extends Sprite
	{

		public var view:View3D;
		public var camera:Camera3D;
		public var orbitSimulation:GravitySimulator;
		
		private var _lightPicker:StaticLightPicker;
		private var _cameraTarget:ObjectContainer3D;
		private var _pointlight_sun:PointLight;
		
		
		private const SCALE_MULTIPLIER:Number = 20000;
		




		public function init ():void
		{
			initAway3D();
			initOrbitSimulation ();
			
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}

		private function initAway3D ():void
		{
			view = new View3D ();
			addChild (view);
			
			camera = view.camera;
			camera.lens = new PerspectiveLens (30);
			camera.lens.far = 40 * SCALE_MULTIPLIER;
			camera.lens.near = 0.1;
			
			
			_pointlight_sun = new PointLight();
			//_pointlight_sun.castsShadows = true;
			//_pointlight_sun.shadowMapper.depthMapSize = 512;
			_pointlight_sun.z = 0;
			_pointlight_sun.x = 0;
			_pointlight_sun.y = 0;
			_pointlight_sun.fallOff = 1200000;
			_pointlight_sun.radius = 6000;
			_pointlight_sun.zOffset = 0;
			_pointlight_sun.shaderPickingDetails = false;
			_pointlight_sun.ambient = 0.05;
			_pointlight_sun.color = 0xFFCCFF;
			_pointlight_sun.ambientColor = 0xFFCCFF;
			_pointlight_sun.specular = 0.5;
			_pointlight_sun.diffuse = 0.6;
			_pointlight_sun.name = "_pointlight_sun";
			view.scene.addChild (_pointlight_sun);

			
			_lightPicker = new StaticLightPicker ([_pointlight_sun]);
		}


		private var _segmentSet:SegmentSet;

		private function initOrbitSimulation ():void
		{
			var substepsPerIteration:int = 8;
			var timestepIncrement:Number = 100;
			var scaleMass:Number = 0.0000000012944;
			
			
			var planetaryBodyList:Vector.<NBody> = new Vector.<NBody> (10);
			planetaryBodyList[0] = new NBody (
					new Vector3D (-0.008349066, 0.000189290, 0.000323565),
					new Vector3D (0.000000048, -0.000000348, -0.000000150),
					396.89, 0xffff00,
					0.0093289, 0);

			planetaryBodyList[1] = new NBody (
					new Vector3D (-0.366950735, -0.233017122, -0.087053104),
					new Vector3D (0.000427802, -0.000791151, -0.000466931),
					0.0000658, 0xffdddd,
					0.0000329, 1);

			planetaryBodyList[2] = new NBody (
					new Vector3D (0.517925495, -0.445522365, -0.233499924),
					new Vector3D (0.000576233, 0.000566230, 0.000218276),
					0.00097029, 0xddffdd,
					0.0000817, 2);

			planetaryBodyList[3] = new NBody (
					new Vector3D (-0.18197903, 0.88819973, 0.38532644),
					new Vector3D (-0.000717186, -0.000118962, -0.000051576),
					0.0012067, 0x00ffff,
					0.0000847, 3);

			planetaryBodyList[4] = new NBody (
					new Vector3D (-1.596538576, 0.436171769, 0.243237864),
					new Vector3D (-0.000152089, -0.000462584, -0.000208050),
					0.0001275, 0xff0000,
					0.0000451, 4);

			planetaryBodyList[5] = new NBody (
					new Vector3D (4.940498284, 0.269444615, -0.004844226),
					new Vector3D (-0.000019658, 0.000301945, 0.000129905),
					0.379, 0xffdd88,
					0.0009641, 5);

			planetaryBodyList[6] = new NBody (
					new Vector3D (7.791088486, 4.739656899, 1.622403811),
					new Vector3D (-0.000137611, 0.000178350, 0.000079578),
					0.11348, 0xffffff,
					0.0008109, 6);

			planetaryBodyList[7] = new NBody (
					new Vector3D (13.408727053, -13.374109577, -6.047169310),
					new Vector3D (0.000119777, 0.000094894, 0.000039867),
					0.01728, 0x00ff00,
					0.0003452, 7);

			planetaryBodyList[8] = new NBody (
					new Vector3D (15.848452622, -23.573132782, -10.043179759),
					new Vector3D (0.000110388, 0.000065394, 0.000024018),
					0.02038, 0x0077ff,
					0.000334, 8);

			planetaryBodyList[9] = new NBody (
					new Vector3D (-10.984596612, -27.547235462, -5.287115643),
					new Vector3D (0.000124706, -0.000051827, -0.000053747),
					0.000002575, 0xccccff,
					0.0000155, 9);

			var sphereMesh:Mesh;

			_segmentSet = new SegmentSet ();
			view.scene.addChild (_segmentSet);


			var lastPosition:Vector3D = new Vector3D ();

			var i:int;
			var planet:NBody;

			// scale masses
			for (i = 0; i < planetaryBodyList.length; ++i)
			{
				planet = planetaryBodyList[i];
				planet.mass *= scaleMass;

				sphereMesh = new Mesh (new SphereGeometry (1000+planet.radius * SCALE_MULTIPLIER * 20, 64,54), new ColorMaterial(planet.color));
				
				if (i != 0)
				{
					ColorMaterial (sphereMesh.material).lightPicker = _lightPicker;
				}
				view.scene.addChild (sphereMesh);
				planet.sphereMesh = sphereMesh;
			}

			orbitSimulation = new GravitySimulator (planetaryBodyList, timestepIncrement, substepsPerIteration);


			// Create position debug lines
			for (i = 0; i < planetaryBodyList.length; ++i)
			{
				planet = planetaryBodyList[i];
				sphereMesh = planet.sphereMesh;

				sphereMesh.x = planet.position.x * SCALE_MULTIPLIER;
				sphereMesh.y = planet.position.y * SCALE_MULTIPLIER;
				sphereMesh.z = planet.position.z * SCALE_MULTIPLIER;

				_segmentSet.addSegment (new LineSegment (lastPosition.clone(), sphereMesh.position.clone(), 0xFF0000, 0x0000FF, 0.5));
				lastPosition = sphereMesh.position.clone ();
			}
		}

		private var _isFirstFrame:Boolean = true;

		private function enterFrameHandler (e:Event):void
		{
			var planet:NBody;


			planet = orbitSimulation.nBodyList[9];
			var lastPosition:Vector3D = planet.sphereMesh.position.clone();
			var segment:Segment;
			
			for (var i:int = 0; i < orbitSimulation.nBodyList.length; i++)
			{
				planet = orbitSimulation.nBodyList[i];
				
				planet.sphereMesh.x = planet.position.x * SCALE_MULTIPLIER;
				planet.sphereMesh.y = planet.position.y * SCALE_MULTIPLIER;
				planet.sphereMesh.z = planet.position.z * SCALE_MULTIPLIER;

				segment = _segmentSet.getSegment (i);
				segment.start = lastPosition.clone ();
				lastPosition = planet.sphereMesh.position.clone ();
				segment.end = lastPosition.clone ();
			}




			view.render ();
			orbitSimulation.step ();

			if (_isFirstFrame)
			{
				_isFirstFrame = false;

				planet = orbitSimulation.nBodyList[9];
				camera.position = planet.sphereMesh.position.clone ();
				camera.moveUp (1100000);
				camera.lookAt (planet.sphereMesh.position);
			}
			else
			{
				camera.moveForward (150);
				/*planet = orbitSimulation.planetaryBodies[3];
				camera.position = planet.sphereMesh.position.clone ();
				camera.moveUp (2000);

				planet = orbitSimulation.planetaryBodies[9];
				camera.lookAt (planet.sphereMesh.position);*/


				/*camera.x = orbitSimulation.planetaryBodies[3].position.x + 12000;
				 camera.y = orbitSimulation.planetaryBodies[3].position.y - 6000;
				 camera.z = orbitSimulation.planetaryBodies[3].position.z - 4000;*/
				//camera.rotate (Vector3D.Z_AXIS, -180);
				/*planet = orbitSimulation.planetaryBodies[4];
				 camera.lookAt (new Vector3D (planet.position.x * SCALE_MULTIPLIER, planet.position.y * SCALE_MULTIPLIER, planet.position.z * SCALE_MULTIPLIER));*/
				//camera.lookAt (_globalPivot);

			}

		}
		
		private var _globalPivot:Vector3D = new Vector3D ();
	}
}