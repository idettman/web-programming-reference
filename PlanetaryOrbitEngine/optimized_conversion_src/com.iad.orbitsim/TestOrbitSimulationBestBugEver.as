package com.iad.orbitsim
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;


	public class TestOrbitSimulationBestBugEver extends Sprite
	{

		public var view:View3D;
		public var camera:Camera3D;
		public var orbitSimulation:OrbitSimulation;
		
		private const SCALE_MULTIPLIER:Number = 10000;
		




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
			camera.lens = new PerspectiveLens (60);
			camera.lens.far = 10 * SCALE_MULTIPLIER;
			camera.lens.near = 1;
			camera.moveLeft (20);
			camera.moveBackward (0.5*SCALE_MULTIPLIER);
			camera.moveUp (0.5*SCALE_MULTIPLIER + 10000);
			
			camera.lookAt (new Vector3D);
		}


		private function initOrbitSimulation ():void
		{
			var substepsPerIteration:int = 7;
			var timestepIncrement:Number = 10.25;
			var scaleMass:Number = 0.0000000012944;
			

			var planetaryBodyList:Vector.<PlanetaryBody> = new Vector.<PlanetaryBody> (10);
			planetaryBodyList[0] = new PlanetaryBody (
					new Point3D (-0.008349066, 0.000189290, 0.000323565),
					new Point3D (0.000000048, -0.000000348, -0.000000150),
					396.89, 0xffff00,
					0.0093289, 0);

			planetaryBodyList[1] = new PlanetaryBody (
					new Point3D (-0.366950735, -0.233017122, -0.087053104),
					new Point3D (0.000427802, -0.000791151, -0.000466931),
					0.0000658, 0xffdddd,
					0.0000329, 1);

			planetaryBodyList[2] = new PlanetaryBody (
					new Point3D (0.517925495, -0.445522365, -0.233499924),
					new Point3D (0.000576233, 0.000566230, 0.000218276),
					0.00097029, 0xddffdd,
					0.0000817, 2);

			planetaryBodyList[3] = new PlanetaryBody (
					new Point3D (-0.18197903, 0.88819973, 0.38532644),
					new Point3D (-0.000717186, -0.000118962, -0.000051576),
					0.0012067, 0x00ffff,
					0.0000847, 3);

			planetaryBodyList[4] = new PlanetaryBody (
					new Point3D (-1.596538576, 0.436171769, 0.243237864),
					new Point3D (-0.000152089, -0.000462584, -0.000208050),
					0.0001275, 0xff0000,
					0.0000451, 4);

			planetaryBodyList[5] = new PlanetaryBody (
					new Point3D (4.940498284, 0.269444615, -0.004844226),
					new Point3D (-0.000019658, 0.000301945, 0.000129905),
					0.379, 0xffdd88,
					0.0009641, 5);

			planetaryBodyList[6] = new PlanetaryBody (
					new Point3D (7.791088486, 4.739656899, 1.622403811),
					new Point3D (-0.000137611, 0.000178350, 0.000079578),
					0.11348, 0xffffff,
					0.0008109, 6);

			planetaryBodyList[7] = new PlanetaryBody (
					new Point3D (13.408727053, -13.374109577, -6.047169310),
					new Point3D (0.000119777, 0.000094894, 0.000039867),
					0.01728, 0x00ff00,
					0.0003452, 7);

			planetaryBodyList[8] = new PlanetaryBody (
					new Point3D (15.848452622, -23.573132782, -10.043179759),
					new Point3D (0.000110388, 0.000065394, 0.000024018),
					0.02038, 0x0077ff,
					0.000334, 8);

			planetaryBodyList[9] = new PlanetaryBody (
					new Point3D (-10.984596612, -27.547235462, -5.287115643),
					new Point3D (0.000124706, -0.000051827, -0.000053747),
					0.000002575, 0xccccff,
					0.0000155, 9);

			var sphereMesh:Mesh;

			// scale masses
			for (var i:int = 0; i < planetaryBodyList.length; ++i)
			{
				planetaryBodyList[i].mass *= scaleMass;
				
				//sphereMesh = new Mesh (new SphereGeometry (planetaryBodyList[i].radius * SCALE_MULTIPLIER));
				sphereMesh = new Mesh (new SphereGeometry (50), new ColorMaterial(planetaryBodyList[i].color));
				view.scene.addChild (sphereMesh);
				
				planetaryBodyList[i].sphereMesh = sphereMesh;
				
			}

			orbitSimulation = new OrbitSimulation (planetaryBodyList, timestepIncrement, substepsPerIteration);
		}


		private function enterFrameHandler (e:Event):void
		{
			//SCALE_MULTIPLIER

			
			
			
			var planet:PlanetaryBody;
			for (var i:int = 0; i < orbitSimulation.planetaryBodies.length; i++)
			{
				planet = orbitSimulation.planetaryBodies[i];
				
				planet.sphereMesh.x = planet.position.x * SCALE_MULTIPLIER;
				planet.sphereMesh.y = planet.position.y * SCALE_MULTIPLIER;
				planet.sphereMesh.z = planet.position.z * SCALE_MULTIPLIER;
				
				//canvas.graphics.drawCircle (OFFSET_X + (planet.position.x * SCALER), OFFSET_Y + (planet.position.y * SCALER), planet.radius * SCALER);
				//trace ("scaled radius:", (planet.radius * SCALER), "   scaled x position:", (planet.position.x * SCALER));
			}
			
			camera.moveForward (20);
			//camera.moveForward (50);
			camera.moveDown (0.5);
			camera.lookAt (new Vector3D ());
			
			view.render ();
			orbitSimulation.step ();
		}



		/*
				private function enterFrameHandler (e:Event):void
				{
					const SCALER:Number = 40000;
					const OFFSET_X:Number = 1024/2;
					const OFFSET_Y:Number = 720/2;
					var planet:PlanetaryBody;
					for (var i:int = 0; i < orbitSimulation.planetaryBodies.length; i++)
					{
						planet = orbitSimulation.planetaryBodies[i];
						canvas.graphics.beginFill (planet.color);
						canvas.graphics.drawCircle (OFFSET_X + (planet.position.x * SCALER), OFFSET_Y + (planet.position.y * SCALER), planet.radius * SCALER);
						canvas.graphics.endFill ();
						//trace ("scaled radius:", (planet.radius * SCALER), "   scaled x position:", (planet.position.x * SCALER));
					}
					orbitSimulation.step ();
				}
		*/
	}
}