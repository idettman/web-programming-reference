package lunchwheel
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.textures.BitmapTexture;

	import base.display.AbstractSprite;

	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Cubic;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import utils.GeometryUtils;


	public class LunchWheel_Test extends AbstractSprite
	{
		private var _startingIndex:uint;
		private var _circleRadius:Number;
		private var _circleCenter:Point;
		private var _data:Vector.<LunchVo>;
		public var wheelShape:Shape;

		private var _view:View3D;
		private var _cameraController:HoverController;


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
		private var _wheelContainer:ObjectContainer3D;
		private var pointlight_0:PointLight;


		// Spin variables
		private var _dragging:Boolean;
		private var _a:Number;
		private var _b:Number;
		private var _oldRadius:Number;
		private var _square:Sprite;
		private var _rad:Number;
		private var _accr:Number = 0;
		private var _damp:Number = .96;



		override protected function init ():void
		{
			initAway3d();

			_startingIndex = 0;
			_circleRadius = 200;
			//_circleCenter = new Point (1024 / 2, 700 / 2);
			_circleCenter = new Point (0, 0);// Centered for away3d
			wheelShape = new Shape ();
			//addChild (wheelShape);

			var lunchData:Vector.<LunchVo> = new <LunchVo>[
				createLunchData ("Hots Kitchen"),
				createLunchData ("Britts BBQ"),
				createLunchData ("The Golf Course"),
				createLunchData ("Chipotle"),
				createLunchData ("Panda Express"),
				createLunchData ("Pickup Sticks"),
				createLunchData ("Mc Donalds"),
				createLunchData ("Silvios"),
				createLunchData ("The Sizzler"),
				createLunchData ("Chilies"),
				createLunchData ("Carls JR"),
				createLunchData ("The Habbit"),
				createLunchData ("Applebees"),
				createLunchData ("TGI Fridays"),
				createLunchData ("Corner Bakery"),
				createLunchData ("Jacks"),
				createLunchData ("Subway"),
				createLunchData ("Noahs Bagels"),
				createLunchData ("Five Guys")
			];
			
			data = lunchData;
			super.init ();
		}

		private var _cameraTarget:Vector3D;
		
		private function initAway3d ():void
		{
			Parsers.enableAllBundled ();

			_view = new View3D ();
			addChild (_view);
			_view.antiAlias = 16;
			
			
			_view.camera.lens = new PerspectiveLens (50);
			_view.camera.lens.far = 8000;
			_view.camera.lens.near = 0.5;
			
			_wheelContainer = new ObjectContainer3D ();
			_view.scene.addChild (_wheelContainer);
			_cameraController = new HoverController (_view.camera, _wheelContainer, 0, 12, 2440, 12, 90, NaN, NaN, 8, 1.2, false);


			// Create light
			pointlight_0 = new PointLight();
			pointlight_0.castsShadows = true;
			pointlight_0.shadowMapper.depthMapSize = 512;
			pointlight_0.z = -120;
			pointlight_0.x = 10;
			pointlight_0.y = 900;
			pointlight_0.fallOff = 20000;
			pointlight_0.radius = 3000;
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
			

			_cubeGeometry = new CubeGeometry ();
			createBoxChainLayout(new Vector3D());
		}

		private var _cubeGeometry:Geometry;
		private function createBoxChainLayout (lastPosition:Vector3D, recusionDepth:uint = 0):void
		{
			var cube:Mesh 
			
			if (recusionDepth < 20)
			{
				createBoxChainLayout (lastPosition, ++recusionDepth);
			}
		}


		override protected function addListeners ():void
		{
			super.addListeners ();
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}

		private function updateLayout ():void
		{
			var angle:Number = 0;
			var sum:uint = _data.length;
			var radius:Number = _circleRadius;
			var count:uint = sum;

			var step:Number, start:Number, n:uint, dx:Number, dy:Number;

			var point1:Point = new Point ();
			var point2:Point = new Point ();

			var _lunchVo:LunchVo;


			// calculate span of sides
			step = (Math.PI * 2) / count;
			// calculate starting angle in radians
			start = (angle / 180) * Math.PI;

			point1.x = _circleCenter.x + (Math.cos (start) * radius);
			point1.y = _circleCenter.y + (Math.sin (start) * radius);

			var lastBitmapY:Number = 0;

			// create the polygon
			for (n = 1; n <= count; n++)
			{
				_lunchVo = _data[n - 1];

				dx = _circleCenter.x + Math.cos (start + (step * n)) * radius;
				dy = _circleCenter.y - Math.sin (start + (step * n)) * radius;

				point2.x = dx;
				point2.y = dy;


				var deltaX:Number = point2.x - point1.x;
				var deltaY:Number = point2.y - point1.y;

				var lineLength:Number = Math.sqrt (deltaX * deltaX + deltaY * deltaY);

				deltaX /= lineLength;
				deltaY /= lineLength;

				const THICKNESS:Number = 20;
				const pVectorX:Number = THICKNESS * deltaY;
				const pVectorY:Number = THICKNESS * deltaX;

				var pointVert1:Point = new Point (point1.x - pVectorX, point1.y + pVectorY);
				var pointVert2:Point = new Point (point2.x - pVectorX, point2.y + pVectorY);
				var pointVert3:Point = new Point (point2.x + pVectorX, point2.y - pVectorY);
				var pointVert4:Point = new Point (point1.x + pVectorX, point1.y - pVectorY);


				const RECTANGLE_HEIGHT:Number = 20;

				// Get the length of the polygon segment
				// Distance forumula: d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
				var diffX:Number = point2.x - point1.x;
				var diffY:Number = point2.y - point1.y;
				var polySegmentLength:Number = Math.sqrt(diffX * diffX + diffY * diffY);
				var polySegmentAngleInRadians:Number = Math.atan2 (diffY, diffX);
				var polySegmentAngleInDegress:Number = polySegmentAngleInRadians * (180 / Math.PI);
				trace ("Rectangle TopLeft:", point1 ," Length: ", polySegmentLength, " Angle:", polySegmentAngleInDegress);



				// Create rectangle with text and position at polygon segment extruded rectangle
				var testRectangle:Sprite = new Sprite ();
				testRectangle.graphics.beginFill (0x00FFFF);
				testRectangle.graphics.drawRect (0, 0, polySegmentLength, RECTANGLE_HEIGHT);
				testRectangle.graphics.endFill ();
				testRectangle.x = point1.x;
				testRectangle.y = point1.y;
				testRectangle.rotation = polySegmentAngleInDegress;

				var testRectangleLable:TextField = new TextField ();
				testRectangleLable.embedFonts = true;
				testRectangleLable.defaultTextFormat = new TextFormat ("RobotoCondensed Regular", 12);
				testRectangleLable.text = /*_lunchVo.index.toString() + ". " +*/ _lunchVo.title;
				testRectangleLable.selectable = false;
				testRectangleLable.mouseEnabled = false;
				testRectangle.addChild (testRectangleLable);
				//addChild (testRectangle);


				//trace ("bitmapWidth:", bitmapWidth, "   bitmapHeight:", bitmapHeight);



				var bitmapCapture:BitmapData = new BitmapData (256, 256, false, 0xFF0000);
				var m:Matrix = new Matrix();
				var scaleToWidth:Number = bitmapCapture.width / polySegmentLength;
				m.scale(scaleToWidth, scaleToWidth);
				bitmapCapture.draw (testRectangle, m);
				

				var centeredTestRectanglePosition:Point = GeometryUtils.getMidPoint (point1.x, point1.y, polySegmentLength, RECTANGLE_HEIGHT, polySegmentAngleInDegress);

				var geometry:CubeGeometry = new CubeGeometry (polySegmentLength, 8, RECTANGLE_HEIGHT, 1, 1, 1, false);
				var cubeMesh:Mesh = new Mesh (geometry, new TextureMaterial(new BitmapTexture(bitmapCapture), true, false, true));
				TextureMaterial(cubeMesh.material).lightPicker = _lightPicker;
				

				// To use projector.project need to correct for CompactSubGeometries/SubGeometries bug in away3d 4.1
				/*cubeMesh.geometry.convertToSeparateBuffers ();
				Projector.project (Projector.TOP, cubeMesh);
				*/
				cubeMesh.geometry.scaleUV (1, RECTANGLE_HEIGHT/polySegmentLength);


				cubeMesh.x = centeredTestRectanglePosition.x;
				cubeMesh.z = centeredTestRectanglePosition.y;
				cubeMesh.rotationY = -polySegmentAngleInDegress;
				//cubeMesh.rotationX = 90;
				_wheelContainer.addChild (cubeMesh);


				point1.x = point2.x;
				point1.y = point2.y;
			}


			Actuate.tween (_cameraController, 2.5, {distance: 430, tiltAngle: 82}).ease(Cubic.easeInOut);
		}


		private function createLunchData (title:String):LunchVo
		{
			var lunchVo:LunchVo = new LunchVo ();
			lunchVo.index = _startingIndex;
			lunchVo.title = title;
			_startingIndex++;
			return lunchVo;
		}


		public function get data ():Vector.<LunchVo> { return _data; }

		public function set data (value:Vector.<LunchVo>):void
		{
			_data = value;
			updateLayout ();
		}



		private function enterFrameHandler (e:Event):void
		{
			// Update camera
			/*if (move) {
				_cameraController.panAngle = 0.1*(stage.mouseX - lastMouseX) + lastPanAngle;
				_cameraController.tiltAngle = 0.1*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}

			_cameraController.panAngle += panIncrement;
			_cameraController.tiltAngle += tiltIncrement;
			_cameraController.distance += distanceIncrement;
			_cameraController.update ();*/


			if (_dragging)
			{
				_a = stage.mouseY - stage.stageHeight/2;
				_b = stage.mouseX - stage.stageWidth/2;


				_rad = Math.atan2(_a, _b) * 180/Math.PI;

				if (_rad - _oldRadius > 160 || _rad - _oldRadius < -160)
				{
					_accr = ((0) + _accr);
				}
				else
				{
					_accr = ((_rad - _oldRadius) + _accr) / 2;
				}

				_wheelContainer.rotationY += _accr;
				_oldRadius = _rad;
			}
			/*else
			{
				_wheelContainer.rotationY += _accr;

				if (Math.pow(_accr, 2) > .0001 )
				{
					_accr *= + _damp;
				}
				else
				{
					_accr = 0;
				}
			}*/


			_view.render ();
		}


		private function onMouseUp(event:MouseEvent):void
		{
			_dragging = false;
			move = false;
			
			//trace ("power:", _a, _b, _accr);
			
			if (Math.abs(_accr) > 3)
			{
				Actuate.tween (_wheelContainer, Math.abs (_accr) * 0.5, {rotationY: _wheelContainer.rotationY + (_accr * 90)}).ease(Cubic.easeOut).onComplete(spinTweenCompleteHandler);
			}
			else
			{
				Actuate.tween (_wheelContainer, Math.abs (_accr) * 0.5, {rotationY: _wheelContainer.rotationY + (_accr * 90)}).ease(Cubic.easeOut);
			}
			
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}


		private function spinTweenCompleteHandler ():void
		{
			Actuate.tween (_cameraController, 2, { distance: 300 }).ease(Cubic.easeInOut).onComplete(resetCamera);
		}


		private function resetCamera ():void
		{
			Actuate.tween (_cameraController, 1.5, { distance: 600 }).ease(Cubic.easeInOut).delay(3);
		}


		private function onMouseDown(event:MouseEvent):void
		{
			Actuate.stop (_wheelContainer);

			_dragging = true;

			_a = stage.mouseY - stage.stageHeight/2;
			_b = stage.mouseX - stage.stageWidth/2;

			_oldRadius = Math.atan2(_a, _b) * 180 / Math.PI;


			move = true;
			lastPanAngle = _cameraController.panAngle;
			lastTiltAngle = _cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		private function onStageMouseLeave(event:Event):void
		{
			_dragging = false;
			move = false;

			trace ("mouse leave: power:", _a, _b, _accr);

			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
	}
}
class LunchVo
{
	public function LunchVo () {}

	public var index:uint;
	public var title:String;
}